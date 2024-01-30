import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalappnew/pages/appointmentPage.dart';

class ClinicListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff649f90),
          title: Text('Clinics'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('clinics').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final clinics = snapshot.data!.docs;
            return ListView.separated(
              itemCount: clinics.length,
              itemBuilder: (context, index) {
                final clinic = clinics[index].data() as Map<String, dynamic>;
                if (clinic != null) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            DoctorListScreen(clinicName: clinics[index].id)),
                      );
                    },
                    child: Text(
                      clinic['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20, // Yazı boyutunu 20 olarak ayarladık
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFC8E6C9),
                      fixedSize: Size(200,100), // Buton boyutunu 200x50 olarak ayarladık
                    ),
                  );
                }
                return SizedBox.shrink();
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
            );
          },
        )
    );
  }
}