import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/view/pendapatan/creatependapatan.dart';
import 'package:redlenshoescleaning/view/pendapatan/updatependapatan.dart';

class Pendapatan extends StatefulWidget {
  const Pendapatan({Key? key});

  @override
  State<Pendapatan> createState() => _PendapatanState();
}

class _PendapatanState extends State<Pendapatan> {
  var penc = PendapatanController();

  @override
  void initState() {
    penc.getPendapatan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFD9D9D9),
        centerTitle: true,
        title: Text(
          'Daftar Pendapatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: penc.stream,
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
                        color: const Color(0xFFD9D9D9),
                        elevation: 4,
                        child: ListTile(
                          title: Text(data[index]['tglMasuk']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data[index]['namaCust']),
                              Text(data[index]['sepatuCust']),
                              Text(data[index]['treatment']),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              size: 25,
                            ),
                            onSelected: (value) {
                              if (value == 'edit') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdatePendapatan(
                                      pendapatanID: data[index]['pendapatanID'],
                                      namaCust: data[index]['namaCust'],
                                      telpCust: data[index]['telpCust'],
                                      alamatCust: data[index]['alamatCust'],
                                      sepatuCust: data[index]['sepatuCust'],
                                      treatment: data[index]['treatment'],
                                      tglMasuk: data[index]['tglMasuk'],
                                      tglKeluar: data[index]['tglKeluar'],
                                      hargaTreatment: data[index]
                                          ['hargaTreatment'],
                                    ),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      penc.getPendapatan();
                                    });
                                  }
                                });
                              } else if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,
                                      title:
                                          const Text('Konfirmasi Penghapusan'),
                                      content: const Text(
                                          'Yakin ingin menghapus pengeluaran ini?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text(
                                            'Batal',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'Hapus',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            penc.removePendapatan(data[index]
                                                    ['pendapatanID']
                                                .toString());
                                            setState(() {
                                              penc.getPendapatan();
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
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePendapatan(),
            ),
          );
        },
        backgroundColor: const Color(0xFFD9D9D9),
        child: const Icon(Icons.add),
      ),
    );
  }
}
