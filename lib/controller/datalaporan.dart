import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/controller/authcontroller.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';
import 'package:redlenshoescleaning/model/pengeluaranmodel.dart';
import 'package:redlenshoescleaning/view/login.dart';

class DataLaporan extends StatefulWidget {
  const DataLaporan({Key? key}) : super(key: key);

  @override
  State<DataLaporan> createState() => _DataLaporanState();
}

class _DataLaporanState extends State<DataLaporan> {
  final AuthController authController = AuthController();
  final PendapatanController pendapatanController = PendapatanController();
  final PengeluaranController pengeluaranController = PengeluaranController();

  // Add a flag to check if it's the first page load
  bool isFirstLoad = true;

  // Add DateTime variables for StartDate and EndDate
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  // Function to show date picker for StartDate
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != startDate) {
      setState(() {
        startDate = picked;
        isFirstLoad = false;
      });
    }
  }

  // Function to show date picker for EndDate
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != endDate) {
      setState(() {
        endDate = picked;
        isFirstLoad = false;
      });
    }
  }

  // Function to fetch filtered data based on date range
  Future<List<String>> getFilteredData(
      DateTime startDate, DateTime endDate) async {
    final List<PendapatanModel> filteredPendapatan =
        await pendapatanController.getPendapatanByDate(startDate, endDate);
    final List<PengeluaranModel> filteredPengeluaran =
        await pengeluaranController.getPengeluaranByDate(startDate, endDate);

    double totalPendapatan = 0;
    double totalPengeluaran = 0;

    for (var pendapatan in filteredPendapatan) {
      totalPendapatan += double.tryParse(pendapatan.hargaTreatment) ?? 0;
    }

    for (var pengeluaran in filteredPengeluaran) {
      totalPengeluaran += double.tryParse(pengeluaran.harga) ?? 0;
    }

    return [
      totalPengeluaran.toStringAsFixed(2),
      totalPendapatan.toStringAsFixed(2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'REDLEN APPS',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 100),
              FutureBuilder<List<String>>(
                future: isFirstLoad
                    ? Future.wait([
                        getTotalPengeluaran(),
                        getTotalPendapatan()
                      ]) // Fetch all data for the first time
                    : getFilteredData(startDate, endDate),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<String> data = snapshot.data!;
                    final String totalPengeluaran = data[0];
                    final String totalPendapatan = data[1];

                    double laba = double.parse(totalPendapatan) -
                        double.parse(totalPengeluaran);

                    return Container(
                      width: 350,
                      height: 350,
                      decoration: BoxDecoration(
                        color: const Color(0xff8fd5a6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '   Dari Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  'Sampai Tanggal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Start Date
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width:
                                              75, // Adjust the width according to your preference
                                          height: 25,
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(startDate),
                                            ),
                                            onTap: () =>
                                                _selectStartDate(context),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            size: 20.0,
                                          ),
                                          onPressed: () =>
                                              _selectStartDate(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // End Date
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  padding: const EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width:
                                              75, // Adjust the width according to your preference
                                          height: 25,
                                          child: TextFormField(
                                            readOnly: true,
                                            controller: TextEditingController(
                                              text: DateFormat('dd-MM-yyyy')
                                                  .format(endDate),
                                            ),
                                            onTap: () =>
                                                _selectEndDate(context),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.calendar_today,
                                            size: 20.0,
                                          ),
                                          onPressed: () =>
                                              _selectEndDate(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pendapatan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                _buildDecorationBox(
                                    double.parse(totalPendapatan)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pengeluaran',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                _buildDecorationBox(
                                    double.parse(totalPengeluaran)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Laba/Rugi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 33,
                                ),
                                _buildDecorationBox(laba),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getTotalPengeluaran() async {
    final totalPengeluaran = await pengeluaranController.getTotalPengeluaran();
    return totalPengeluaran;
  }

  Future<String> getTotalPendapatan() async {
    final totalPendapatan = await pendapatanController.getTotalPendapatan();
    return totalPendapatan;
  }
}

// Widget _buildDecorationBox(double value) {
//   return Container(
//     width: 150,
//     height: 35,
//     decoration: BoxDecoration(
//       color: Colors.white,
//       border: Border.all(),
//       borderRadius: BorderRadius.circular(5),
//     ),
//     child: Center(
//       child: Text(
//         value.toStringAsFixed(2),
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }

Widget _buildDecorationBox(double value) {
  final currencyFormatter =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  String formattedValue = currencyFormatter.format(value);
  formattedValue = formattedValue.replaceAll(RegExp(r'(\.00)(?!.*\d)'), '');

  return Container(
    width: 150,
    height: 35,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Center(
      child: Text(
        formattedValue,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
