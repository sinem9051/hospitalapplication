import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppointmentsPage extends StatefulWidget {
  @override
  _MyAppointmentsPageState createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  late QuerySnapshot<Map<String, dynamic>> _appointmentsSnapshot;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final appointmentsRef = FirebaseFirestore.instance.collection('appointments');
      final querySnapshot = await appointmentsRef.where('userId', isEqualTo: userId).get();

      setState(() {
        _appointmentsSnapshot = querySnapshot;
      });
    }
  }

  void _cancelAppointment(String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                final appointmentRef = FirebaseFirestore.instance.collection('appointments').doc(appointmentId);
                appointmentRef.delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff649f90),
        title: Text('My Appointments'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('appointments')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error occurred'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.size == 0) {
            return Center(
              child: Text('No appointments found'),
            );
          }

          _appointmentsSnapshot = snapshot.data!;

          return ListView.builder(
            itemCount: _appointmentsSnapshot.size,
            itemBuilder: (context, index) {
              final appointmentData = _appointmentsSnapshot.docs[index].data();
              final appointment = Appointment.fromMap(appointmentData);

              return ListTile(
                title: Text(appointment.doctorName),
                subtitle: Text('Time: ${appointment.formattedTime}, Date: ${appointment.formattedDate}'),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () => _cancelAppointment(_appointmentsSnapshot.docs[index].id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Appointment {
  final String doctorName;
  final String time;
  final Timestamp date;

  Appointment({
    required this.doctorName,
    required this.time,
    required this.date,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      doctorName: map['doctorId'],
      time: map['time'],
      date: map['date'],
    );
  }

  String get formattedTime {
    final timeParts = time.split(':');
    final hours = timeParts[0].padLeft(2, '0');
    final minutes = timeParts[1].padLeft(2, '0');
    return '$hours:$minutes';
  }

  String get formattedDate {
    final dateTime = date.toDate();
    final formatted = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return formatted;
  }
}
