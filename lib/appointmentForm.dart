import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Timestamp {
  DateTime dateTime;

  Timestamp(this.dateTime);

  String toIso8601String() {
    return dateTime.toIso8601String();
  }
}

class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String userId;
  final String date;
  final String time;
  final String status;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Appointment.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Appointment(
      id: snapshot.id,
      doctorId: data['doctorId'],
      doctorName: data['doctorName'],
      userId: data['userId'],
      date: (data['date'] as Timestamp).toIso8601String(),
      time: data['time'],
      status: data['status'],
    );
  }
}


class AppointmentForm extends StatefulWidget {
  final String doctorId;

  AppointmentForm({required this.doctorId});

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}
class _AppointmentFormState extends State<AppointmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }


  void _bookAppointment() async {
    if (_formKey.currentState!.validate()) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final doctorId = widget.doctorId;
      final date = _selectedDate;
      final time = _selectedTime;

      final appointmentsRef = FirebaseFirestore.instance.collection('appointments');
      final querySnapshot = await appointmentsRef
          .where('date', isEqualTo: date)
          .where('time', isEqualTo: '${time!.hour}:${time.minute}')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final conflictingAppointment = querySnapshot.docs.first;
        final conflictingDoctorId = conflictingAppointment['doctorId'];
        final conflictingUserId = conflictingAppointment['userId'];

        if (conflictingDoctorId != doctorId && conflictingUserId != userId) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('This date and time is already booked by another doctor and user. Please select another one.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }

      await appointmentsRef.add({
        'doctorId': doctorId,
        'doctorName': '',
        'userId': userId,
        'date': date,
        'time': '${time.hour}:${time.minute}',
        'status': 'pending',
      });

      Navigator.pop(context);
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = pickedDate.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final startTime = TimeOfDay(hour: 8, minute: 00);
    final interval = 30;

    final availableTimes = List.generate(
      (24 * 60) ~/ interval,
          (i) => TimeOfDay(
        hour: startTime.hour + (i * interval) ~/ 60,
        minute: startTime.minute + (i * interval) % 60,
      ),
    );

    final TimeOfDay? pickedTime = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TimeOfDay? _time = TimeOfDay.now();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select a time'),
              content: SingleChildScrollView(
                child: Column(
                  children: availableTimes.map((time) {
                    return ListTile(
                      title: Text('${time.format(context)}'),
                      onTap: () {
                        setState(() {
                          _time = time;
                        });
                        Navigator.of(context).pop(_time);
                      },
                      selected: _time == time,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = pickedTime.format(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff649f90),
        title: Text('Create Appointment'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Select a date and time:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today),
                  hintText: 'Select a date',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  icon: Icon(Icons.access_time),
                  hintText: 'Select a time',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectTime(context);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _bookAppointment();
                  }
                },
                child: Text('Create Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}