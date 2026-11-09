import 'package:flutter/material.dart';

Widget buildAmapWebPicker({required ValueChanged<String> onSelected}) =>
    const SizedBox(
      height: 300,
      child: Center(
        child: Text('Web map is available when AMAP_WEB_KEY is configured.'),
      ),
    );
