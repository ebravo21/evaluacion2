// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evaluacion_n2/pages/themes.dart';
import 'package:evaluacion_n2/pages/new_wakala.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evaluacion_n2/pages/wakala_detail.dart';
import 'package:intl/intl.dart';

class WakalaList extends StatelessWidget {
  const WakalaList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundColor,
      appBar: AppBar(
        title: Text('Listado de Wakalas',
            style: TextStyle(
                color: AppThemes.textColor2, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppThemes.buttonColor,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: AppThemes.textColor2),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('wakalas').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              DateTime reportDate =
                  (document['reportDate'] as Timestamp).toDate();
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(reportDate);

              return Card(
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                child: ListTile(
                  title: Text(
                    document['sector'],
                    style: TextStyle(
                        color: AppThemes.textColor1,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Por ${document['reporterEmail']}',
                        style: TextStyle(color: AppThemes.textColor1),
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: AppThemes.textColor1, size: 16),
                          SizedBox(width: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(color: AppThemes.textColor1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppThemes.buttonColor,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WakalaDetail(documentId: document.id)),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewWakala()),
          );
        },
        backgroundColor: AppThemes.buttonColor,
        child: Icon(
          Icons.add,
          color: AppThemes.textColor2,
          size: 25,
        ),
      ),
    );
  }
}
