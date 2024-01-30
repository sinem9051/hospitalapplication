import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospitalappnew/pages/forgotPasswordPage.dart';
import 'package:hospitalappnew/pages/homePage.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = "";
  bool isRememberMe = false;
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


  @override
  void initState() {
    super.initState();
    _controllerEmail.text = "";
    _controllerPassword.text = "";
  }


  Future<void> handleAuthentication() async {
    try {
      if (isLogin) {
        await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      } else {
        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _title() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://thumbs.dreamstime.com/b/hospital-building-modern-parking-lot-59693686.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: null,
    );
  }

  Widget _entryField(String title, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
      ),
      obscureText: title == 'Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $title';
        }
        return null;
      },
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage == ""
          ? ""
          : "Please enter your email and password.. $errorMessage",
      style: TextStyle(
        color: Colors.black,
      ),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        padding: EdgeInsets.all(0),
      ),
      onPressed: handleAuthentication,
      child: Text(isLogin ? "LOGIN" : "REGISTER"),
    );
  }

  Widget _loginOrRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.black, padding: EdgeInsets.only()),
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'REGISTER' : 'LOGIN'),
    );
  }

  Widget _forgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgotPasswordPage(),
                ),
              );
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                      colors: [
                      Color(0xffe8f5e9),
                  Color(0xffc8e6c9),
                  Color(0xffa5d6a7),
                  Color(0xff81c784),
                  ],
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _title(),
                    SizedBox(height: 1.0),
                    _entryField('Email', _controllerEmail),
                    SizedBox(height: 10.0),
                    _entryField('Password', _controllerPassword),
                    SizedBox(height: 2.0),
                    _errorMessage(),
                    SizedBox(height: 2.0),
                    _forgotPasswordButton(),
                    SizedBox(height: 10.0),
                    _submitButton(),
                    SizedBox(height: 20.0),
                    _loginOrRegisterButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}