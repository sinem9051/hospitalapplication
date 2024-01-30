import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = 'mailto:info@gmail.com?subject=Contact Form Submission&body=${Uri.encodeComponent(_messageController.text)}';
      if (await canLaunch(email)) {
        await launch(email);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to open email application.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff649f90),
        title: const Text('Contact Us'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Address'),
              subtitle: const Text('123 Main St, City, State, Zip Code'),
              leading: const Icon(Icons.location_on),
            ),
            ListTile(
              title: const Text('Phone'),
              subtitle: const Text('(123) 456-7890'),
              leading: const Icon(Icons.phone),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: const Text('info@hospital.com'),
              leading: const Icon(Icons.email),
            ),
            ListTile(
              title: const Text('Facebook'),
              subtitle: const Text('facebook.com/hospital'),
              leading: const Icon(Icons.facebook),
            ),
            ListTile(
              title: const Text('Twitter'),
              subtitle: const Text('@hospital'),
              leading: const Icon(Icons.wb_twilight),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _submitForm,
                    child: const Text('SEND US AN EMAIL'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
