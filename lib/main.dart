import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redlenshoescleaning/view/laporan.dart';
import 'package:redlenshoescleaning/view/login.dart';
import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';
import 'package:redlenshoescleaning/view/treatment/treatment.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Laporan(),
    );
  }
}
