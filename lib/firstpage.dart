import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/controller/authcontroller.dart';
import 'package:redlenshoescleaning/view/laporan.dart';
import 'package:redlenshoescleaning/view/login.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final authctrl = AuthController();

  bool isLogin = false;

  Future<void> silentLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null && user.uid.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          isLogin = true;
        });
      }
    }
  }

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    authctrl.getCurrentUser();

    silentLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin == true) {
      return Laporan();
    } else {
      return Login();
    }
  }
}
