import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';

class CreatePendapatan extends StatefulWidget {
  const CreatePendapatan({Key? key}) : super(key: key);

  @override
  State<CreatePendapatan> createState() => _CreatePendapatanState();
}

class _CreatePendapatanState extends State<CreatePendapatan> {
  final _formKey = GlobalKey<FormState>();
  final pendapatanController = PendapatanController();

  String? tglMasuk;
  String? tglKeluar;
  String? namaCust;
  String? telpCust;
  String? alamatCust;
  String? sepatuCust;
  String? hargaTreatment;
  String? treatment;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  final TextEditingController hargaController = TextEditingController();
  final TextEditingController _tglMasukController = TextEditingController();
  final TextEditingController _tglKeluarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Tambahkan Pendapatan',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Expanded(
              child: Container(
                width: 350,
                // height: 900,
                decoration: BoxDecoration(
                  color: const Color(0xff8fd5a6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tanggal Masuk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: _tglMasukController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: const Color.fromRGBO(255, 255, 255, 1),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime? tanggalm = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2025),
                                  );

                                  if (tanggalm != null) {
                                    tglMasuk = DateFormat('dd-MM-yyyy')
                                        .format(tanggalm);

                                    setState(() {
                                      _tglMasukController.text =
                                          tglMasuk.toString();
                                    });
                                  }
                                },
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal tidak boleh kosong!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Tanggal Keluar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: _tglKeluarController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime? tanggalk = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2025),
                                  );

                                  if (tanggalk != null) {
                                    tglKeluar = DateFormat('dd-MM-yyyy')
                                        .format(tanggalk);

                                    setState(() {
                                      _tglKeluarController.text =
                                          tglKeluar.toString();
                                    });
                                  }
                                },
                              ),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tanggal tidak boleh kosong!';
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Nama Customer',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Nama Customer',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama customer tidak boleh kosong!';
                              } else if (value.length > 30) {
                                return 'Nama Customer maksimal 30 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Nama Customer harus berisi huruf alphabet saja.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              namaCust = value;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No. Telepon',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'No. Telepon',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType
                                .number, // Set the keyboard type to number
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly // Allow only digits
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'No. Telepon tidak boleh kosong!';
                              } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                                return 'No. Telepon harus berisi angka saja.';
                              } else if (value.length < 10 ||
                                  value.length > 13) {
                                return 'No. Telepon harus terdiri dari 10 hingga 13 karakter!';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              telpCust = value;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Alamat',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Alamat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong!';
                              } else if (value.length > 50) {
                                return 'Alamat maksimal 50 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                  .hasMatch(value)) {
                                return 'Alamat hanya boleh berisi huruf alfabet dan angka.';
                              }

                              return null;
                            },
                            onChanged: (value) {
                              alamatCust = value;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sepatu',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Sepatu',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Sepatu tidak boleh kosong!';
                              } else if (value.length > 30) {
                                return 'Sepatu maksimal 30 karakter!';
                              } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                  .hasMatch(value)) {
                                return 'Sepatu hanya boleh berisi huruf alfabet dan angka.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              sepatuCust = value;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Jenis Treatment',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('treatments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else {
                              List<DropdownMenuItem<String>> dropdownItems = [];
                              final items = snapshot.data!.docs.where((element) {
                                return element['deletedAt'] == 0;
                              }).toList();
                              for (var item in items) {
                                // Assuming the 'jenistreatment' field exists in each document
                                String itemName = item['treatment'];
                                dropdownItems.add(
                                  DropdownMenuItem(
                                    value: itemName,
                                    child: Text(itemName),
                                  ),
                                );
                              }
                              return Container(
                                width: 300,
                                child: DropdownButtonFormField<String>(
                                  borderRadius: BorderRadius.circular(10.0),
                                  icon: const Icon(
                                      Icons.arrow_drop_down_circle_rounded),
                                  value: treatment,
                                  items: dropdownItems,
                                  onChanged: (item) async {
                                    setState(() {
                                      treatment = item;
                                    });
                                    hargaTreatment = await getHargaByItem(
                                        item!); // Fetch the harga for the selected item
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Pilih Jenis Treatment',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Jenis treatment tidak boleh kosong!';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 30.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Harga',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 300,
                          child: FutureBuilder<String?>(
                            future: treatment != null
                                ? getHargaByItem(treatment!)
                                : null,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                String harga = snapshot.data ?? '';
                                return TextFormField(
                                  initialValue: harga,
                                  decoration: InputDecoration(
                                    hintText: 'Harga',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  readOnly: true,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              PendapatanModel penmodel = PendapatanModel(
                                namaCust: namaCust!,
                                telpCust: telpCust!,
                                alamatCust: alamatCust!,
                                sepatuCust: sepatuCust!,
                                treatment: treatment!,
                                tglMasuk: tglMasuk!,
                                tglKeluar: tglKeluar!,
                                hargaTreatment: hargaTreatment!,
                                // Adding timestamp fields
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                deletedAt: DateTime.now(),
                              );
                              pendapatanController.addPendapatan(penmodel);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pendapatan Ditambahkan'),
                                ),
                              );
                              Navigator.pop(context, true);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff329f5b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            minimumSize: const Size(150, 50),
                          ),
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String?> getHargaByItem(String selectedItem) async {
  try {
    // Perform a query to get the harga from Firestore based on the selected item
    var snapshot = await FirebaseFirestore.instance
        .collection('treatments')
        .where('treatment', isEqualTo: selectedItem)
        .limit(1)
        .get();

    // Assuming the 'harga' field exists in each document
    if (snapshot.docs.isNotEmpty) {
      var document = snapshot.docs.first;
      if (document.data().containsKey('hargaTreatment')) {
        return document.data()['hargaTreatment'].toString();
      }
    }
  } catch (e) {
    print('Error fetching hargaTreatment: $e');
  }

  return null;
}
