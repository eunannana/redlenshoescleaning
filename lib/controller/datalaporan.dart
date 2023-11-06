import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/authcontroller.dart';
import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';

class DataLaporan extends StatefulWidget {
  const DataLaporan({Key? key}) : super(key: key);

  @override
  State<DataLaporan> createState() => _DataLaporanState();
}

class _DataLaporanState extends State<DataLaporan> {
  final AuthController authController = AuthController();
  final PendapatanController pendapatanController = PendapatanController();
  final PengeluaranController pengeluaranController = PengeluaranController();
  // DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.signOut();
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
          child: FutureBuilder<List<String>>(
            future: Future.wait([
              getTotalPengeluaran(),
              getTotalPendapatan(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<String> data = snapshot.data!;
                final String totalPengeluaran = data[0];
                final String totalPendapatan = data[1];

                double laba = double.parse(totalPendapatan) -
                    double.parse(totalPengeluaran);

                return Container(
                  width: 350,
                  height: 300,
                  decoration: BoxDecoration(
                    color: const Color(0xff8fd5a6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                            _buildDecorationBox(double.parse(totalPendapatan)),
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
                            _buildDecorationBox(double.parse(totalPengeluaran)),
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

Widget _buildDecorationBox(double value) {
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
        value.toStringAsFixed(2),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
