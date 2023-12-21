// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors, library_private_types_in_public_api, use_super_parameters, library_prefixes

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:evaluacion_n2/pages/themes.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';

class NewWakala extends StatefulWidget {
  const NewWakala({Key? key}) : super(key: key);

  @override
  _NewWakalaState createState() => _NewWakalaState();
}

class _NewWakalaState extends State<NewWakala> {
  bool _isLoading = false;
  final _sectorController = TextEditingController();
  final _descripcionController = TextEditingController();
  File? image1;
  File? image2;

  Future<void> pickMedia(int cameraIndex) async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (file != null) {
      setState(() {
        if (cameraIndex == 1) {
          image1 = File(file.path);
        } else {
          image2 = File(file.path);
        }
      });
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileName = Path.basename(file.path);
      Reference storageReference =
          FirebaseStorage.instance.ref().child('wakalas/$fileName');

      // print('Storage Reference: ${storageReference.fullPath}');

      UploadTask uploadTask = storageReference.putFile(file);

      // print('Upload Task started for file: $fileName');

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // print('Upload successful. URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      // print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> reportWakala() async {
    if (_sectorController.text.isEmpty) {
      _showSnackBar("El campo sector es obligatorio.");
      return;
    }

    if (_descripcionController.text.length < 15) {
      _showSnackBar("La descripción debe tener al menos 15 caracteres.");
      return;
    }

    if (image1 == null && image2 == null) {
      _showSnackBar("Se debe cargar al menos una foto.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl1;
      String? imageUrl2;

      if (image1 != null) {
        imageUrl1 = await uploadFile(image1!);
      }
      if (image2 != null) {
        imageUrl2 = await uploadFile(image2!);
      }

      String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'Unknown';
      DateTime reportDate = DateTime.now();
      FirebaseFirestore.instance.collection('wakalas').add({
        'sector': _sectorController.text.trim(),
        'descripcion': _descripcionController.text.trim(),
        'foto1': imageUrl1,
        'foto2': imageUrl2,
        'reporterEmail': userEmail,
        'reportDate': reportDate,
        'siCount': 0,
        'noCount': 0,
        'votosSi': [],
        'votosNo': [],
        'comentarios': []
      }).then((_) {
        _showSnackBar("Wakala denunciado con éxito.",
            backgroundColor: Colors.green);
        _sectorController.clear();
        _descripcionController.clear();
        setState(() {
          image1 = null;
          image2 = null;
        });
      });
    } catch (e) {
      _showSnackBar("Error reportando Wakala: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildPhotoSection(String label, int cameraIndex, File? image) {
    return Column(
      children: [
        _buildPhotoButton(label, () => pickMedia(cameraIndex), image),
        if (image != null)
          _buildDeleteButton(
            'Borrar ' + label,
            () => setState(
                () => cameraIndex == 1 ? image1 = null : image2 = null),
          ),
      ],
    );
  }

  Widget _buildPhotoButton(String label, VoidCallback onPressed, File? image) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
            border: Border.all(color: Colors.white),
          ),
          child: image == null
              ? Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: AppThemes.textColor1,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        IconButton(
          icon: const Icon(Icons.photo_camera),
          onPressed: onPressed,
          color: AppThemes.textColor3,
          iconSize: 40,
        ),
      ],
    );
  }

  Widget _buildDeleteButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 21.0),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            hintStyle: TextStyle(color: AppThemes.textColor1, fontSize: 18),
          ),
          style: TextStyle(color: AppThemes.textColor1, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avisar por nuevo Wakala',
            style: TextStyle(
                color: AppThemes.textColor2, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppThemes.buttonColor,
        iconTheme: IconThemeData(
          color: AppThemes.textColor2,
        ),
      ),
      backgroundColor: AppThemes.backgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildTextField('Sector', _sectorController),
                  const SizedBox(height: 20),
                  _buildTextField('Descripción', _descripcionController,
                      maxLines: 6),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPhotoSection('Foto 1', 1, image1),
                      _buildPhotoSection('Foto 2', 2, image2),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: GestureDetector(
                      onTap: reportWakala,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppThemes.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'DENUNCIAR WAKALA',
                            style: TextStyle(
                              color: AppThemes.textColor2,
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
    );
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
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
