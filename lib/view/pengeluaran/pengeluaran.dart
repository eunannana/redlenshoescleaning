import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';
import 'package:redlenshoescleaning/view/pengeluaran/createpengeluaran.dart';
import 'package:redlenshoescleaning/view/pengeluaran/updatepengeluaran.dart';

class Pengeluaran extends StatefulWidget {
  const Pengeluaran({Key? key});

  get harga => null;

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  var pc = PengeluaranController();
  String keyword = "";
  bool isSearching = false;

  @override
  void initState() {
    pc.getPengeluaran();
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
          'Daftar Pengeluaran',
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
                  hintText: 'Cari Pengeluaran...',
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
              stream: pc.stream,
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
                  Map<String, dynamic> pengeluaran =
                      document.data() as Map<String, dynamic>;
                  String searchField = pengeluaran['tanggal'] +
                      pengeluaran['keterangan'] +
                      pengeluaran['harga'].toString();
                  return searchField
                      .toLowerCase()
                      .contains(keyword.toLowerCase());
                }).toList();

                return ListView.builder(
                  itemCount: filteredDocuments.length,
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
                          title: Text(filteredDocuments[index]['tanggal']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(filteredDocuments[index]['keterangan']),
                              Text(filteredDocuments[index]['harga']),
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
                                    builder: (context) => UpdatePengeluaran(
                                      pengeluaranId: filteredDocuments[index]
                                          ['pengeluaranId'],
                                      tanggal: filteredDocuments[index]
                                          ['tanggal'],
                                      keterangan: filteredDocuments[index]
                                          ['keterangan'],
                                      harga: filteredDocuments[index]['harga'],
                                    ),
                                  ),
                                ).then((value) {
                                  if (value == true) {
                                    setState(() {
                                      pc.getPengeluaran();
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
                                            pc.removePengeluaran(
                                                filteredDocuments[index]
                                                        ['pengeluaranId']
                                                    .toString());
                                            setState(() {
                                              pc.getPengeluaran();
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
              builder: (context) => const CreatePengeluaran(),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                pc.getPengeluaran();
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
