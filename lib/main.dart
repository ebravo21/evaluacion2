// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:evaluacion_n2/auth/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyB6JqvQvL4xrHqA8mw0pXMHCKE1H2kZDrY',
              appId: '1:585130662668:android:245b2250ecb72ecd7cc729',
              messagingSenderId: '585130662668',
              projectId: 'evaluacion02app-eca76',
              storageBucket: 'gs://evaluacion02app-eca76.appspot.com'))
      : await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
