// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evaluacion_n2/pages/themes.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      _showSnackBarLogin("Por favor, ingrese su correo.");
      return;
    }

    if (password.isEmpty) {
      _showSnackBarLogin("Por favor, ingrese su contraseña.");
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        final errorMessage = e.message;
        if (errorMessage != null &&
            errorMessage.contains('INVALID_LOGIN_CREDENTIALS')) {
          _showSnackBarLogin(
              "Usuario no encontrado o contraseña incorrecta. Por favor, inténtelo de nuevo.");
        } else {
          _showSnackBarLogin(
              "Error de inicio de sesión: ${errorMessage ?? 'Error desconocido'}");
        }
      } else {
        _showSnackBarLogin("Error inesperado: ${e.toString()}");
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'WAKALA 1.0',
                  style: TextStyle(
                    color: AppThemes.textColor3,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'By Elizabeth Bravo',
                  style: TextStyle(
                    color: AppThemes.textColor2,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                // Unicornio
                Image.asset(
                  'lib/images/unicornio.png',
                  height: 350,
                ),

                // Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Login',
                          hintStyle: TextStyle(color: AppThemes.textColor1),
                        ),
                        style: TextStyle(color: AppThemes.textColor1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppThemes.textColor1),
                        ),
                        style: TextStyle(color: AppThemes.textColor1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // ACCEDER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signIn,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppThemes.buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'ACCEDER',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Registrar Usuario
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: Text(
                    'Registrar Usuario',
                    style: TextStyle(
                      color: AppThemes.textColor2,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBarLogin(String message,
      {Color backgroundColor = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: backgroundColor,
      duration: Duration(milliseconds: 1300),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
