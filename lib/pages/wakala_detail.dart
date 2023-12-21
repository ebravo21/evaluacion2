// ignore_for_file: use_super_parameters, prefer_const_constructors, library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:evaluacion_n2/pages/comment_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluacion_n2/pages/themes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WakalaDetail extends StatefulWidget {
  final String documentId;

  WakalaDetail({Key? key, required this.documentId}) : super(key: key);

  @override
  _WakalaDetailState createState() => _WakalaDetailState();
}

class _WakalaDetailState extends State<WakalaDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Wakala',
            style: TextStyle(
                color: AppThemes.textColor2, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppThemes.buttonColor,
        iconTheme: IconThemeData(color: AppThemes.textColor2),
      ),
      backgroundColor: AppThemes.backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('wakalas')
            .doc(widget.documentId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Text('No se encontró el detalle del Wakala');
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          DateTime reportDate = (data['reportDate'] as Timestamp).toDate();
          String formattedDate = DateFormat('dd/MM/yyyy').format(reportDate);

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 1,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sector: ${data['sector']}',
                                style: TextStyle(
                                    fontSize: 18, color: AppThemes.textColor1)),
                            SizedBox(height: 10),
                            Text('Descripción: ${data['descripcion']}',
                                style: TextStyle(
                                    fontSize: 18, color: AppThemes.textColor1)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Reportado por: ${data['reporterEmail']}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppThemes.textColor1)),
                                  Text('Fecha: $formattedDate',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppThemes.textColor1)),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Wrap(
                    spacing: 20,
                    alignment: WrapAlignment.spaceEvenly,
                    children: [
                      if (data['foto1'] != null)
                        _buildImageContainer(data['foto1'], context),
                      if (data['foto2'] != null)
                        _buildImageContainer(data['foto2'], context),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      'Sigue ahí (${data['siCount']})',
                      AppThemes.buttonColor,
                      Icons.thumb_up,
                      context,
                      widget.documentId,
                      true, // Voto "Sí"
                    ),
                    _buildActionButton(
                      'Ya no está (${data['noCount']})',
                      AppThemes.buttonColor,
                      Icons.thumb_down,
                      context,
                      widget.documentId,
                      false, // Voto "No"
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: GestureDetector(
                    onTap: () async {
                      bool? result =
                          await Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CommentPage(
                            documentId: widget.documentId,
                            sector: data['sector']),
                      ));
                      if (result == true) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: AppThemes.buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'COMENTAR',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (data['comentarios'] != null &&
                    data['comentarios'].isNotEmpty) ...[
                  Text('Comentarios',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.buttonColor)),
                  _buildCommentsSection(data['comentarios'])
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageContainer(String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text('Detalle foto Wuakala',
                style: TextStyle(
                    color: AppThemes.textColor2, fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: AppThemes.buttonColor,
            iconTheme: IconThemeData(color: AppThemes.textColor2),
          ),
          backgroundColor: AppThemes.backgroundColor,
          body: Center(
            child: Image.network(imageUrl),
          ),
        ),
      )),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection(List<dynamic> comentarios) {
    return SizedBox(
      height: 400,
      child: ListView.separated(
        itemCount: comentarios.length,
        separatorBuilder: (context, index) =>
            Divider(color: AppThemes.buttonColor),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comentarios[index]['comentario'],
                  style: TextStyle(fontSize: 16, color: AppThemes.buttonColor),
                ),
                SizedBox(height: 10),
                Text(
                  'Enviado por: ${comentarios[index]['email']}',
                  style: TextStyle(fontSize: 16, color: AppThemes.buttonColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> votar(
      BuildContext context, String documentId, bool votoSi) async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    FirebaseFirestore.instance
        .collection('wakalas')
        .doc(documentId)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        List<dynamic> votosSi = data['votosSi'] ?? [];
        List<dynamic> votosNo = data['votosNo'] ?? [];

        if (votoSi) {
          if (votosNo.contains(userId)) {
            // El usuario cambia su voto de no a sí
            FirebaseFirestore.instance
                .collection('wakalas')
                .doc(documentId)
                .update({
              'votosNo': FieldValue.arrayRemove([userId]),
              'votosSi': FieldValue.arrayUnion([userId]),
              'noCount': FieldValue.increment(-1),
              'siCount': FieldValue.increment(1),
            });
          } else if (!votosSi.contains(userId)) {
            // El usuario vota sí por primera vez
            FirebaseFirestore.instance
                .collection('wakalas')
                .doc(documentId)
                .update({
              'votosSi': FieldValue.arrayUnion([userId]),
              'siCount': FieldValue.increment(1),
            });
          }
        } else {
          if (votosSi.contains(userId)) {
            // El usuario cambia su voto de sí a no
            FirebaseFirestore.instance
                .collection('wakalas')
                .doc(documentId)
                .update({
              'votosSi': FieldValue.arrayRemove([userId]),
              'votosNo': FieldValue.arrayUnion([userId]),
              'siCount': FieldValue.increment(-1),
              'noCount': FieldValue.increment(1),
            });
          } else if (!votosNo.contains(userId)) {
            // El usuario vota no por primera vez
            FirebaseFirestore.instance
                .collection('wakalas')
                .doc(documentId)
                .update({
              'votosNo': FieldValue.arrayUnion([userId]),
              'noCount': FieldValue.increment(1),
            });
          }
        }
      }
    });
  }

  void _showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildActionButton(String label, Color color, IconData icon,
      BuildContext context, String documentId, bool votoSi) {
    return GestureDetector(
      onTap: () {
        votar(context, documentId, votoSi);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppThemes.textColor2),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: AppThemes.textColor2,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
