// File generated manually by ChatGPT for your project.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS is not configured.');
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError('This platform is not yet configured.');
      default:
        throw UnsupportedError('Unknown platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxKDBZFSinPVQJX1Z-8QO98hS1Y28uig0',
    appId: '1:776591201459:android:68fff076bbd07db62c0cc6',
    messagingSenderId: '776591201459',
    projectId: 'biodata-ku-4d1b3',
    storageBucket: 'biodata-ku-4d1b3.firebasestorage.app',
  );
}
