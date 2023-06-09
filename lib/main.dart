// this is the main file of the app

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raonmoa_app/logics/design.dart';
import 'package:raonmoa_app/logics/settings.dart';
import 'package:raonmoa_app/ui/login/login.dart';
import 'package:raonmoa_app/ui/example.dart';
import 'package:raonmoa_app/ui/home.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

Future<void> main() async {
  // initialize settings
  Settings.init();

  // initialize firebase
  // make input controller
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FirebaseDatabase.instance.setPersistenceEnabled(false);

  // log in into firebase
  // await FirebaseAuth.instance.signInWithEmailAndPassword(email: "bungai2560@gmail.com", password: "hunter2560");

  runApp(const MyApp());
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return const BouncingScrollPhysics();
      case TargetPlatform.macOS:
        return const ClampingScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
      default:
        return const BouncingScrollPhysics();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('ko', 'KR'),
        const Locale('en', 'US'),
      ],
      title: '라온모아',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: LoginPage(),
      scrollBehavior: ScrollBehaviorModified(),
      // disable splash effect globally
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,

            // appbar text color is black
            appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              toolbarTextStyle: TextTheme(
                headline6: TextStyle(color: Colors.black, fontSize: 20),
              ).bodyText2,
              titleTextStyle: TextTheme(
                headline6: TextStyle(color: Colors.black, fontSize: 20),
              ).headline6,
            ),
            // tob bar background color is raonmoacolor
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: $raonmoaColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
