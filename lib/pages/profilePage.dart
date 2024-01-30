import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;

  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _boyController = TextEditingController();
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _kanGrubuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }
  Future<void> _uploadImage(File file) async {
    try {
      // StorageReference nesnesi oluşturun
      final reference = FirebaseStorage.instance
          .ref()
          .child('users')
          .child(_currentUser!.uid)
          .child('profile.jpg');

      // StorageReference'e dosyayı yükleyin
      final uploadTask = reference.putFile(file);

      // Yükleme işlemi tamamlanana kadar bekleyin
      await uploadTask.whenComplete(() => null);

      // Dosya URL'sini alın ve Firestore'da saklayın
      final url = await reference.getDownloadURL();
      await _firestore.collection('users').doc(_currentUser!.uid).update({
        'profileImageUrl': url,
      });

      // Kullanıcıya yükleme işleminin tamamlandığına dair bir mesaj gösterin
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile photography has saved')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      await _firestore.collection('users').doc(_currentUser!.uid).set({
        'tc': _tcController.text,
        'boy': _boyController.text,
        'kilo': _kiloController.text,
        'kanGrubu': _kanGrubuController.text,
      }, SetOptions(merge: true));
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User info updated')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _getCurrentUser() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('users').doc(user.uid).get();

      final data = snapshot.data();

      setState(() {
        _currentUser = user;
        _tcController.text = data?['tc'] ?? '';
        _boyController.text = data?['boy'] ?? '';
        _kiloController.text = data?['kilo'] ?? '';
        _kanGrubuController.text = data?['kanGrubu'] ?? '';
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _openUpdateUserInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update User Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Turkish Identity Number'),
                TextField(
                  controller: _tcController,
                  maxLength: 11,
                  onChanged: (value) {
                    String text = _tcController.text;
                    String filteredText = '';

                    for (int i = 0; i < text.length; i++) {
                      if (RegExp(r'[0-9]').hasMatch(text[i])) {
                        filteredText += text[i];
                      }
                    }

                    if (filteredText.length > 11) {
                      filteredText = filteredText.substring(0, 11);
                    }

                    _tcController.value = _tcController.value.copyWith(
                      text: filteredText,
                      selection: TextSelection(
                        baseOffset: filteredText.length,
                        extentOffset: filteredText.length,
                      ),
                      composing: TextRange.empty,
                    );

                    setState(() {});
                  },
                ),

                SizedBox(height: 5),
                Text('Height'),
                TextField(
                  controller: _boyController,
                  onChanged: (value) {
                    String text = _boyController.text;
                    String filteredText = '';

                    if (text.length <= 3) {
                      for (int i = 0; i < text.length; i++) {
                        if (RegExp(r'[0-9]').hasMatch(text[i])) {
                          filteredText += text[i];
                        }
                      }
                    } else {
                      filteredText = text.substring(0, 3);
                    }

                    _boyController.value = _boyController.value.copyWith(
                      text: filteredText,
                      selection: TextSelection(
                        baseOffset: filteredText.length,
                        extentOffset: filteredText.length,
                      ),
                      composing: TextRange.empty,
                    );

                    setState(() {});
                  },
                ),

                SizedBox(height: 5),

                Text('Weight'),
                TextField(
                  controller: _kiloController,
                  onChanged: (value) {
                    String text = _kiloController.text;
                    String filteredText = '';

                    for (int i = 0; i < text.length; i++) {
                      if (RegExp(r'[0-9]').hasMatch(text[i])) {
                        filteredText += text[i];
                      }
                    }

                    _kiloController.value = _kiloController.value.copyWith(
                      text: filteredText,
                      selection: TextSelection(
                        baseOffset: filteredText.length,
                        extentOffset: filteredText.length,
                      ),
                      composing: TextRange.empty,
                    );

                    setState(() {});
                  },
                ),
                SizedBox(height: 5),
                Text('Blood Group'),
                TextField(
                  controller: _kanGrubuController,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),


              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateUserInfo();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  File? imageFile; // Seçilen resmi saklayacağımız değişken

  void pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: const Color(0xff649f90),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://img.freepik.com/free-icon/black-male-user-symbol_318-60703.jpg'),
              child: IconButton(
                onPressed: () {
                  pickImage();
                },
                icon: Icon(Icons.camera_alt),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Personel Informations',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentUser?.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.email, size: 28, color: Color(0xff649f90)),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turkish Identity Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _tcController.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.perm_identity, size: 28, color: Color(0xff649f90)),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Height',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _boyController.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.height, size: 28, color: Color(0xff649f90)),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _kiloController.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.fitness_center, size: 28, color: Color(0xff649f90)),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blood Group',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _kanGrubuController.text,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(Icons.favorite_border, size: 28, color: Color(0xff649f90)),
              ],
            ),

            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _openUpdateUserInfo,
              child: Text('Add/Update User Info'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff649f90),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff649f90),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

