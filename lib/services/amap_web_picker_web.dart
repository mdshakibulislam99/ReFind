import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

int _nextMapId = 0;

Widget buildAmapWebPicker({required ValueChanged<String> onSelected}) =>
    _AmapWebPicker(onSelected: onSelected);

class _AmapWebPicker extends StatefulWidget {
  final ValueChanged<String> onSelected;
  const _AmapWebPicker({required this.onSelected});

  @override
  State<_AmapWebPicker> createState() => _AmapWebPickerState();
}

class _AmapWebPickerState extends State<_AmapWebPicker> {
  late final String viewType = 'refind-amap-${_nextMapId++}';
  final searchController = TextEditingController();
  JSObject? map;
  Object? error;
  String? locationMessage;

  @override
  void initState() {
    super.initState();
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
      final element = web.document.createElement('div') as web.HTMLDivElement
        ..id = '$viewType-element'
        ..style.width = '100%'
        ..style.height = '300px';
      unawaited(_loadMap(element));
      return element;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMap(web.HTMLElement element) async {
    final key = const String.fromEnvironment('AMAP_WEB_KEY');
    if (key.isEmpty) {
      if (mounted) setState(() => error = 'AMAP_WEB_KEY is not configured.');
      return;
    }
    try {
      final securityCode = const String.fromEnvironment(
        'AMAP_WEB_SECURITY_CODE',
      );
      if (securityCode.isNotEmpty) {
        globalContext['_AMapSecurityConfig'] = (JSObject()
          ..['securityJsCode'] = securityCode.toJS);
      }
      await _loadScript(
        'https://webapi.amap.com/maps?v=2.0&key=${Uri.encodeQueryComponent(key)}'
        '&plugin=AMap.PlaceSearch,AMap.Geolocation',
      );
      final amap = globalContext['AMap'] as JSObject;
      final mapConstructor = amap['Map'] as JSFunction;
      final options = JSObject()..['zoom'] = 12.toJS;
      map = mapConstructor.callAsConstructor<JSObject>(element, options);
      map!.callMethodVarArgs<JSAny?>('on'.toJS, <JSAny?>[
        'click'.toJS,
        ((JSObject event) {
          final lngLat = event['lnglat'] as JSObject;
          final lng = (lngLat.callMethodVarArgs<JSNumber>(
            'getLng'.toJS,
            const [],
          )).toDartDouble;
          final lat = (lngLat.callMethodVarArgs<JSNumber>(
            'getLat'.toJS,
            const [],
          )).toDartDouble;
          widget.onSelected(
            '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
          );
        }).toJS,
      ]);
      unawaited(_centerOnCurrentLocation());
    } on Object catch (value) {
      if (mounted) setState(() => error = value);
    }
  }

  Future<void> _centerOnCurrentLocation() async {
    final activeMap = map;
    if (activeMap == null) return;
    try {
      final amap = globalContext['AMap'] as JSObject;
      final geolocation = (amap['Geolocation'] as JSFunction)
          .callAsConstructor<JSObject>(
            JSObject()
              ..['enableHighAccuracy'] = true.toJS
              ..['timeout'] = 10000.toJS
              ..['zoomToAccuracy'] = true.toJS,
          );
      final result = await _amapPosition(geolocation);
      final location = result['position'] as JSObject?;
      if (location == null) {
        throw StateError('AMap did not return a precise position.');
      }
      final lng = (location.callMethodVarArgs<JSNumber>(
        'getLng'.toJS,
        const [],
      )).toDartDouble;
      final lat = (location.callMethodVarArgs<JSNumber>(
        'getLat'.toJS,
        const [],
      )).toDartDouble;
      _selectCoordinates(activeMap, lat, lng);
      if (mounted)
        setState(() => locationMessage = 'Using your current location');
    } on Object {
      try {
        final position = await _currentPosition();
        final lng = position.coords.longitude;
        final lat = position.coords.latitude;
        _selectCoordinates(activeMap, lat, lng);
        if (mounted)
          setState(() => locationMessage = 'Using your current location');
      } on Object {
        if (mounted) {
          setState(
            () => locationMessage =
                'Location unavailable. Search or tap the map to choose a place.',
          );
        }
      }
    }
  }

  Future<JSObject> _amapPosition(JSObject geolocation) {
    final completer = Completer<JSObject>();
    geolocation.callMethodVarArgs<JSAny?>('getCurrentPosition'.toJS, <JSAny?>[
      ((JSString status, JSObject result) {
        if (status.toDart == 'complete') {
          completer.complete(result);
        } else {
          completer.completeError(
            StateError(
              result['message']?.toString() ?? 'AMap location failed.',
            ),
          );
        }
      }).toJS,
    ]);
    return completer.future;
  }

  void _selectCoordinates(JSObject activeMap, double lat, double lng) {
    activeMap.callMethodVarArgs<JSAny?>('setCenter'.toJS, <JSAny?>[
      [lng.toJS, lat.toJS].toJS,
    ]);
    activeMap.callMethodVarArgs<JSAny?>('setZoom'.toJS, <JSAny?>[15.toJS]);
    widget.onSelected('${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}');
  }

  void _searchPlace() {
    final keyword = searchController.text.trim();
    final activeMap = map;
    if (keyword.isEmpty || activeMap == null) return;
    final amap = globalContext['AMap'] as JSObject;
    final placeSearch = (amap['PlaceSearch'] as JSFunction)
        .callAsConstructor<JSObject>(JSObject()..['pageSize'] = 5.toJS);
    placeSearch.callMethodVarArgs<JSAny?>('search'.toJS, <JSAny?>[
      keyword.toJS,
      ((JSString status, JSObject result) {
        if (status.toDart != 'complete') {
          if (mounted)
            setState(() => locationMessage = 'No matching place found');
          return;
        }
        final poiList = result['poiList'] as JSObject?;
        final pois = poiList?['pois'] as JSArray?;
        final first = pois?[0] as JSObject?;
        final location = first?['location'] as JSObject?;
        if (location == null) {
          if (mounted)
            setState(() => locationMessage = 'No matching place found');
          return;
        }
        final lng = (location.callMethodVarArgs<JSNumber>(
          'getLng'.toJS,
          const [],
        )).toDartDouble;
        final lat = (location.callMethodVarArgs<JSNumber>(
          'getLat'.toJS,
          const [],
        )).toDartDouble;
        activeMap.callMethodVarArgs<JSAny?>('setCenter'.toJS, <JSAny?>[
          [lng.toJS, lat.toJS].toJS,
        ]);
        activeMap.callMethodVarArgs<JSAny?>('setZoom'.toJS, <JSAny?>[15.toJS]);
        widget.onSelected(
          '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
        );
        if (mounted) setState(() => locationMessage = 'Place selected');
      }).toJS,
    ]);
  }

  Future<web.GeolocationPosition> _currentPosition() {
    final completer = Completer<web.GeolocationPosition>();
    web.window.navigator.geolocation.getCurrentPosition(
      ((web.GeolocationPosition position) {
        completer.complete(position);
      }).toJS,
      ((web.GeolocationPositionError error) {
        completer.completeError(StateError(error.message));
      }).toJS,
      web.PositionOptions(
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0,
      ),
    );
    return completer.future;
  }

  Future<void> _loadScript(String src) {
    final completer = Completer<void>();
    final script = web.document.createElement('script') as web.HTMLScriptElement
      ..src = src
      ..async = true;
    script.onload = ((web.Event _) => completer.complete()).toJS;
    script.onerror = ((web.Event _) {
      completer.completeError(StateError('AMap Web JS failed to load.'));
    }).toJS;
    web.document.head!.appendChild(script);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 380,
    width: double.infinity,
    child: error == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _searchPlace(),
                  decoration: InputDecoration(
                    hintText: 'Search a place',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Use current location',
                      onPressed: _centerOnCurrentLocation,
                      icon: const Icon(Icons.my_location),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: HtmlElementView(viewType: viewType)),
              if (locationMessage != null) ...[
                const SizedBox(height: 6),
                Text(
                  locationMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ],
          )
        : Center(child: Text('Unable to load AMap: $error')),
  );
}
