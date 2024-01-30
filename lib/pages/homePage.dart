import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalappnew/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hospitalappnew/clinic_widget.dart';
import 'package:hospitalappnew/pages/appointmentPage.dart';
import 'package:hospitalappnew/pages/contactPage.dart';
import 'package:hospitalappnew/pages/doctorStaffPage.dart';
import 'package:hospitalappnew/pages/myAppointments.dart';
import 'package:hospitalappnew/pages/profilePage.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? "User email");
  }

  Widget signOutButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        padding: EdgeInsets.all(0),
        minimumSize: Size(200, 50), // burada minimum boyutu belirliyoruz
      ),
      onPressed: signOut,
      child: Text('SIGN OUT'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff649f90),
          title: const Text('HOSPITAL APP'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff649f90),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('HOME'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
              ),
              ListTile(
                title: const Text('MY PROFILE'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('ONLINE APPOINTMENT'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ClinicListScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('MY APPOINTMENTS'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAppointmentsPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('OBESITY CALCULATOR'),
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ObesityCalculatorPage()),
                );

                },
              ),
              ListTile(
                title: const Text('CONTACT'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactPage()),
                  );
                },
              ),
              ListTile(
                title: const Text('Sign Out'),
                onTap: () {
                  signOut();
                  // sign out the user
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Image.network(
                  'https://thumbs.dreamstime.com/b/hospital-building-modern-parking-lot-59693686.jpg',
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                ),
                SizedBox(height: 20),
                Text(
                  'All medical services of Beykoz uni hospital are equipped with modern medical devices, following the latest technological developments, in order to provide better health care to their patients.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Icon(Icons.local_hospital, size: 40),
                        SizedBox(height: 10),
                        Text('25 Bed Capacity'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.add_to_queue, size: 40),
                        SizedBox(height: 10),
                        Text('3 Operating Rooms'),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.accessibility_new, size: 40),
                        SizedBox(height: 10),
                        Text('24/7 Pediatric Polyclinic'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Our hospital has 50 employees and is equipped with 4 adult intensive care units, 5 newborn intensive care units, 2 modern delivery rooms, biochemistry and microbiology laboratories, Medical Aesthetics Unit, and Radiology Unit. We provide 24-hour emergency and ambulance services.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'images/medical-equipment.jpg',
                  fit: BoxFit.fitHeight,
                  height: 200,
                  width: double.infinity,
                ),
                SizedBox(height: 20),
                Text(
                  'Our hospital provides a wide range of medical examinations, including Bone Densitometry, Encoscopy, Colonoscopy, EEG, EMG, Digital Mammography, Digital X-ray, Ultrasonography, 3D color Doppler, GE 1.5 Tesla MR device, and computerized tomography (with coronary angiography feature).',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      )
    );
  }
}





