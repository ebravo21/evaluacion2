import 'package:evaluacion_n2/pages/auth_page.dart';
import 'package:evaluacion_n2/pages/wakala_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return WakalaList();
              } else {
                return AuthPage();
              }
            }));
  }
}
