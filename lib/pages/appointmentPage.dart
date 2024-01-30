import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospitalappnew/appointmentForm.dart';

class DoctorListScreen extends StatelessWidget {
  final String clinicName;

  DoctorListScreen({required this.clinicName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
        backgroundColor: Color(0xff649f90),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('clinics')
            .doc(clinicName)
            .collection('doctors')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doctor = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final name = doctor['name'] ?? '';
              final lastName = doctor['lastName'] ?? '';
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(doctor['name'] + ' ' + doctor['lastName']),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AppointmentForm(doctorId: snapshot.data!.docs[index].id),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(height: 10),
          );
        },
      ),
    );
  }
}