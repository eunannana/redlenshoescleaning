import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/controller/authcontroller.dart';
import 'package:redlenshoescleaning/view/laporan.dart';
import 'package:redlenshoescleaning/view/login.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final authCtrl = AuthController();

  bool isLogin = false;

  Future<void> silentLogin() async {
    try {
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
    } catch (e) {
      print("Error during silent login: $e");
    }
  }

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Call silentLogin to check for silent login on page load
    silentLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return const Laporan();
    } else {
      return const Login();
    }
  }
}
