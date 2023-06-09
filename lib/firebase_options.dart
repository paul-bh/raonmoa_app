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
        return macos;
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
    apiKey: 'AIzaSyDgPNHhH2ALjUnqPJAEhslLbRCFMLSq1hc',
    appId: '1:189776097790:web:613e77c04ed3015b4710af',
    messagingSenderId: '189776097790',
    projectId: 'esp-firebase-web-test',
    authDomain: 'esp-firebase-web-test.firebaseapp.com',
    databaseURL: 'https://esp-firebase-web-test-default-rtdb.firebaseio.com',
    storageBucket: 'esp-firebase-web-test.appspot.com',
    measurementId: 'G-YNCLQFWQ7V',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9NctfQaBoe2wEfsBFo9I9T5HOLGqyYDU',
    appId: '1:189776097790:android:e870795a8e7e45b74710af',
    messagingSenderId: '189776097790',
    projectId: 'esp-firebase-web-test',
    databaseURL: 'https://esp-firebase-web-test-default-rtdb.firebaseio.com',
    storageBucket: 'esp-firebase-web-test.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBxKod4exPSKmnw5EOQDkgNxlmg4zlGQzk',
    appId: '1:189776097790:ios:a79fcf89f66f1df44710af',
    messagingSenderId: '189776097790',
    projectId: 'esp-firebase-web-test',
    databaseURL: 'https://esp-firebase-web-test-default-rtdb.firebaseio.com',
    storageBucket: 'esp-firebase-web-test.appspot.com',
    iosClientId: '189776097790-5mvriicavsqlrrilts3t44li1gv9l37c.apps.googleusercontent.com',
    iosBundleId: 'com.example.raonmoaApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBxKod4exPSKmnw5EOQDkgNxlmg4zlGQzk',
    appId: '1:189776097790:ios:a79fcf89f66f1df44710af',
    messagingSenderId: '189776097790',
    projectId: 'esp-firebase-web-test',
    databaseURL: 'https://esp-firebase-web-test-default-rtdb.firebaseio.com',
    storageBucket: 'esp-firebase-web-test.appspot.com',
    iosClientId: '189776097790-5mvriicavsqlrrilts3t44li1gv9l37c.apps.googleusercontent.com',
    iosBundleId: 'com.example.raonmoaApp',
  );
}
