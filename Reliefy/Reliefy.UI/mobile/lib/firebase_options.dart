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
    apiKey: 'AIzaSyBAbI6Xo2fWIo9whbwWj3n61XQua7A_EdE',
    appId: '1:310126194761:web:8ae0272f547969bed60f98',
    messagingSenderId: '310126194761',
    projectId: 'reliefy-2023',
    authDomain: 'reliefy-2023.firebaseapp.com',
    storageBucket: 'reliefy-2023.appspot.com',
    measurementId: 'G-GWZBS542BV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2-BOtsgMJhPBJS2EYzpCzAajYetfv_ZI',
    appId: '1:310126194761:android:447414d9527c626cd60f98',
    messagingSenderId: '310126194761',
    projectId: 'reliefy-2023',
    storageBucket: 'reliefy-2023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBAZtLNbo8HgwkzEapMbkfxOovPunmlU0E',
    appId: '1:310126194761:ios:e368b289b01832aed60f98',
    messagingSenderId: '310126194761',
    projectId: 'reliefy-2023',
    storageBucket: 'reliefy-2023.appspot.com',
    iosClientId: '310126194761-p886lh45fln57dht48ptsjlt5vgf3cme.apps.googleusercontent.com',
    iosBundleId: 'com.sechula.reliefy.mobile',
  );
}
