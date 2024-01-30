import 'package:hospitalappnew/auth.dart';
import 'package:hospitalappnew/pages/homePage.dart';
import 'package:hospitalappnew/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}): super(key: key);

  @override
  State<WidgetTree> createState()=>_WidgetTreeState();
}

class _WidgetTreeState  extends State<WidgetTree>{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(
      stream: Auth().authStateChanges,
        builder: (context, snapshot){
      if(snapshot.hasData){
        return MyApp();
    }else{
        return LoginPage();
    }
      },
    );
}
}