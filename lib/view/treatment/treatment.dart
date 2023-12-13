import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
import 'package:redlenshoescleaning/view/treatment/createtreatment.dart';
import 'package:redlenshoescleaning/view/treatment/updatetreatment.dart';

class Treatment extends StatefulWidget {
  const Treatment({Key? key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  var tc = TreatmentController();

  @override
  void initState() {
    tc.getTreatment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Daftar Treatment',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/LoginPage.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: tc.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<DocumentSnapshot> data = snapshot.data!;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 20.0,
                          ),
                          child: Card(
                            color: const Color(0xff8fd5a6),
                            elevation: 4,
                            child: ListTile(
                              title: Text(data[index]['treatment']),
                              subtitle:
                                  Text('Rp${data[index]['hargaTreatment']}'),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 'update',
                                      child: Text('Ubah'),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Hapus'),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 'update') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdateTreatment(
                                          treatmentID: data[index]
                                              ['treatmentID'],
                                          treatment: data[index]['treatment'],
                                          hargaTreatment: data[index]
                                              ['hargaTreatment'],
                                        ),
                                      ),
                                    ).then((value) {
                                      if (value == true) {
                                        setState(() {
                                          tc.getTreatment();
                                        });
                                      }
                                    });
                                  } else if (value == 'delete') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          title: const Text(
                                              'Konfirmasi Penghapusan'),
                                          content: const Text(
                                              'Yakin ingin menghapus Treatment ini?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text(
                                                'Batal',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                tc.removeTreatment(data[index]
                                                        ['treatmentID']
                                                    .toString());
                                                setState(() {
                                                  tc.getTreatment();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTreatment(),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                tc.getTreatment();
              });
            }
          });
        },
        backgroundColor: const Color(0xff329f5b),
        child: const Icon(Icons.add),
      ),
    );
  }
}
