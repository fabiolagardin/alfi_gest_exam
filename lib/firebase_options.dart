// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDD0Xy_YDXJ-8KZ8qQSWrNdAuvrbD-9ffI',
    appId: '1:672732676920:web:52f5678d6f0571bf2737cd',
    messagingSenderId: '672732676920',
    projectId: 'alfi-gestionale',
    authDomain: 'alfi-gestionale.firebaseapp.com',
    storageBucket: 'alfi-gestionale.appspot.com',
    measurementId: 'G-QTT9P7TEC1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHwVvQDv3gGnTnm9OlohtlzTLFucOuWw4',
    appId: '1:672732676920:android:b6387c51abcfe4542737cd',
    messagingSenderId: '672732676920',
    projectId: 'alfi-gestionale',
    storageBucket: 'alfi-gestionale.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0i0QOWpV_C6ns9YdDw-4x8GOQeZtmqIc',
    appId: '1:672732676920:ios:c6b3523d9d51152d2737cd',
    messagingSenderId: '672732676920',
    projectId: 'alfi-gestionale',
    storageBucket: 'alfi-gestionale.appspot.com',
    iosBundleId: 'com.example.alfiGest',
  );
}