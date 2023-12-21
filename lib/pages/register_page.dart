// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:evaluacion_n2/pages/themes.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirPasswordControllerswordController = TextEditingController();
  final _firstNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirPasswordControllerswordController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword =
        _confirPasswordControllerswordController.text.trim();
    final firstName = _firstNameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        firstName.isEmpty) {
      _showSnackBarRegister("Por favor, complete todos los campos.");
    } else if (password != confirmPassword) {
      _showSnackBarRegister("Las contraseñas no coinciden.");
    } else {
      try {
        final emailExists = await checkIfEmailExists(email);
        if (emailExists) {
          _showSnackBarRegister(
              "El correo ya está registrado. Inicie sesión en su lugar.");
        } else {
          final authResult =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          if (authResult.user != null) {
            addUserDetails(
              authResult.user!.uid,
              firstName,
              email,
            );
            _showSnackBarRegister("¡Registro exitoso!",
                backgroundColor: Colors.green);
          } else {
            _showSnackBarRegister("Error en la creación de usuario.");
          }
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            _showSnackBarRegister(
                "El correo ya está registrado. Inicie sesión en su lugar.");
          } else {
            _showSnackBarRegister("Error: ${e.message}");
          }
        } else {
          _showSnackBarRegister("Error inesperado: $e");
        }
      }
    }
  }

  Future<bool> checkIfEmailExists(String email) async {
    final result =
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    return result.isNotEmpty;
  }

  Future addUserDetails(String uid, String firstName, String email) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'nombre': firstName,
      'email': email,
    });
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirPasswordControllerswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppThemes.backgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
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

                // Repetir Password
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
                        controller: _confirPasswordControllerswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Repetir Password',
                          hintStyle: TextStyle(color: AppThemes.textColor1),
                        ),
                        style: TextStyle(color: AppThemes.textColor1),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Nombre
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
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nombre',
                          hintStyle: TextStyle(color: AppThemes.textColor1),
                        ),
                        style: TextStyle(color: AppThemes.textColor1),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // GUARDAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppThemes.buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'GUARDAR',
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

                // VOLVER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppThemes.buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'VOLVER',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBarRegister(String message,
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
