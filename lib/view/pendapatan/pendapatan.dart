import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/view/pendapatan/creatependapatan.dart';
import 'package:redlenshoescleaning/view/pendapatan/detailpendapatan.dart';
import 'package:redlenshoescleaning/view/pendapatan/updatependapatan.dart';

class Pendapatan extends StatefulWidget {
  const Pendapatan({Key? key});

  @override
  State<Pendapatan> createState() => _PendapatanState();
}

class _PendapatanState extends State<Pendapatan> {
  var penc = PendapatanController();
  String keyword = "";
  bool isSearching = false;

  @override
  void initState() {
    penc.getPendapatan();
    super.initState();
  }

  // @override
  // void dispose() {
  //   penc.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Daftar Pendapatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching; // Toggle kotak pencarian
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isSearching)
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari Pendapatan...',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (newKeyword) {
                  setState(() {
                    keyword = newKeyword;
                  });
                },
              ),
            ),
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

                // Implementasi logika pencarian
                List<DocumentSnapshot> filteredDocuments =
                    data.where((document) {
                  Map<String, dynamic> pendapatan =
                      document.data() as Map<String, dynamic>;
                  String searchField = pendapatan['namaCust'] +
                      pendapatan['sepatuCust'] +
                      pendapatan['treatment'] +
                      pendapatan['tglMasuk'] +
                      pendapatan['hargaTreatment'].toString();
                  return searchField
                      .toLowerCase()
                      .contains(keyword.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
                  itemBuilder: (context, index) {
                    final pendapatan =
                        filteredDocuments[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 20.0,
                      ),
                      child: Card(
                        color: const Color(0xff8fd5a6),
                        elevation: 4,
                        child: ListTile(
                          title: Text(pendapatan['tglMasuk']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pendapatan['namaCust']),
                              Text(pendapatan['sepatuCust']),
                              Text(pendapatan['treatment']),
                              Text(pendapatan['hargaTreatment'].toString()),
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
                              } else if (value == 'viewdetail') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPendapatan(
                                      tglMasuk: pendapatan['tglMasuk'],
                                      tglKeluar: pendapatan['tglKeluar'],
                                      namaCust: pendapatan['namaCust'],
                                      telpCust: pendapatan['telpCust'],
                                      alamatCust: pendapatan['alamatCust'],
                                      sepatuCust: pendapatan['sepatuCust'],
                                      treatment: pendapatan['treatment'],
                                      hargaTreatment:
                                          pendapatan['hargaTreatment'],
                                    ),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Ubah'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Hapus'),
                              ),
                              const PopupMenuItem(
                                value: 'viewdetail',
                                child: Text('Lihat Data'),
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
        backgroundColor: const Color(0xFF0C8346),
        child: const Icon(Icons.add),
      ),
    );
  }
}
