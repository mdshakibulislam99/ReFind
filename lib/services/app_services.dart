import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class AppServices {
  AppServices._();

  static final instance = AppServices._();
  final picker = ImagePicker();
  bool firebaseReady = false;

  Future<void> initialize() async {
    if (const String.fromEnvironment('FIREBASE_API_KEY').isEmpty) return;
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
        appId: String.fromEnvironment('FIREBASE_APP_ID'),
        messagingSenderId: String.fromEnvironment(
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
        storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      ),
    );
    firebaseReady = true;
    await _configureNotifications();
  }

  Future<UserCredential> signIn(String email, String password) {
    _requireFirebase();
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
    String email,
    String password,
    String name,
  ) async {
    _requireFirebase();
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    return credential;
  }

  Future<String> createReport({
    required Map<String, Object?> report,
    List<XFile> photos = const [],
  }) async {
    _requireFirebase();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Sign in before publishing a report.');
    }
    final document = FirebaseFirestore.instance.collection('reports').doc();
    var payload = <String, Object?>{
      ...report,
      'ownerId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'open',
    };
    if (photos.isNotEmpty) {
      final photoUrls = <String>[];
      for (var index = 0; index < photos.length; index++) {
        final ref = FirebaseStorage.instance.ref(
          'reports/${document.id}/photo_$index',
        );
        await ref.putData(await photos[index].readAsBytes());
        photoUrls.add(await ref.getDownloadURL());
      }
      payload = {...payload, 'photoUrls': photoUrls};
    }
    await document.set(payload);
    return document.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> reports() {
    _requireFirebase();
    return FirebaseFirestore.instance
        .collection('reports')
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<Position> currentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw StateError(
        'Turn on location services to select your current place.',
      );
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw StateError('Location permission was not granted.');
    }
    return Geolocator.getCurrentPosition();
  }

  Future<XFile?> choosePhoto(ImageSource source) {
    return picker.pickImage(source: source, imageQuality: 85);
  }

  Future<List<XFile>> choosePhotos() {
    return picker.pickMultiImage(imageQuality: 85, limit: 6);
  }

  void _requireFirebase() {
    if (!firebaseReady) {
      throw StateError(
        'Firebase is not configured. Run flutterfire configure or provide FIREBASE_* dart defines.',
      );
    }
  }

  Future<void> _configureNotifications() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  }
}
