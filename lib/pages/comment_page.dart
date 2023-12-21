// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables

import 'package:evaluacion_n2/pages/themes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentPage extends StatefulWidget {
  final String documentId;
  final String sector;

  CommentPage({Key? key, required this.documentId, required this.sector})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        _isButtonDisabled = _commentController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _postComment() async {
    String userEmail =
        FirebaseAuth.instance.currentUser?.email ?? 'anonymous@example.com';
    FirebaseFirestore.instance
        .collection('wakalas')
        .doc(widget.documentId)
        .update({
      'comentarios': FieldValue.arrayUnion([
        {'email': userEmail, 'comentario': _commentController.text}
      ]),
    }).then((_) {
      _showSuccessMessage();
      Navigator.pop(context, true);
    });
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Comentario enviado exitosamente.'),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar comentario',
            style: TextStyle(
                color: AppThemes.textColor2, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppThemes.buttonColor,
        iconTheme: IconThemeData(color: AppThemes.textColor2),
      ),
      backgroundColor: AppThemes.backgroundColor,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(11.0),
              child: Text('Sector: ${widget.sector}',
                  style: TextStyle(fontSize: 18, color: AppThemes.textColor1)),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Escribe tu comentario aquí',
                  hintStyle:
                      TextStyle(color: AppThemes.textColor1, fontSize: 18),
                  contentPadding: EdgeInsets.all(20),
                ),
                style: TextStyle(color: AppThemes.textColor1, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: _isButtonDisabled ? null : _postComment,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppThemes.buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'ENVIAR COMENTARIO',
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
