import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
      });
    }
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
              // Add StartDate selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Start Date: ${DateFormat('yyyy-MM-dd').format(startDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectStartDate(context),
                  ),
                ],
              ),
              // Add EndDate selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('End Date: ${DateFormat('yyyy-MM-dd').format(endDate)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectEndDate(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<String>>(
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

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:redlenshoescleaning/controller/authcontroller.dart';
// import 'package:redlenshoescleaning/controller/pendapatancontroller.dart';
// import 'package:redlenshoescleaning/controller/pengeluarancontroller.dart';
// import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
// import 'package:intl/intl.dart';
// import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';
// import 'package:redlenshoescleaning/view/pengeluaran/pengeluaran.dart';

// class DataLaporan extends StatefulWidget {
//   const DataLaporan({Key? key}) : super(key: key);

//   @override
//   State<DataLaporan> createState() => _DataLaporanState();
// }

// class _DataLaporanState extends State<DataLaporan> {
//   final AuthController authController = AuthController();
//   final PendapatanController pendapatanController = PendapatanController();
//   final PengeluaranController pengeluaranController = PengeluaranController();
//   DateTime? startDate;
//   DateTime? endDate;

//   List<Pendapatan> filteredPendapatan = [];
//   List<Pengeluaran> filteredPengeluaran = [];

//   String totalPendapatan = '';
//   String totalPengeluaran = '';
//   String labaRugi = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     if (mounted) {
//       totalPendapatan = await pendapatanController.getTotalPendapatan();
//       totalPengeluaran = await pengeluaranController.getTotalPengeluaran();
//       labaRugi = calculateLabaRugi();
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }

//   String calculateLabaRugi() {
//     if (totalPendapatan.isNotEmpty && totalPengeluaran.isNotEmpty) {
//       double pendapatan = double.parse(totalPendapatan);
//       double pengeluaran = double.parse(totalPengeluaran);
//       double laba = pendapatan - pengeluaran;
//       return laba.toStringAsFixed(2);
//     } else {
//       return '0.00';
//     }
//   }

//   Future<void> filterData() async {
//     if (startDate != null && endDate != null) {
//       filteredPendapatan = (await pendapatanController.getPendapatanByDate(
//         startDate!,
//         endDate!,
//       ))
//           .cast<Pendapatan>();

//       filteredPengeluaran = (await pengeluaranController.getPengeluaranByDate(
//         startDate!,
//         endDate!,
//       ))
//           .cast<Pengeluaran>();

//       labaRugi = calculateLabaRugi();
//       setState(() {});
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               authController.signOut();
//             },
//           ),
//         ],
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF0C8346),
//         centerTitle: true,
//         title: Text(
//           'REDLEN APPS',
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               DateTimeField(
//                 format: DateFormat("dd-MM-yyyy"),
//                 style: const TextStyle(color: Colors.black),
//                 onShowPicker: (context, currentValue) async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: startDate ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (selectedDate != null) {
//                     setState(() {
//                       startDate = selectedDate;
//                     });
//                   }
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Start Date',
//                   // Customize the decoration as needed
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DateTimeField(
//                 format: DateFormat("dd-MM-yyyy"),
//                 style: const TextStyle(color: Colors.black),
//                 onShowPicker: (context, currentValue) async {
//                   final selectedDate = await showDatePicker(
//                     context: context,
//                     initialDate: endDate ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (selectedDate != null) {
//                     setState(() {
//                       endDate = selectedDate;
//                     });
//                   }
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'End Date',
//                   // Customize the decoration as needed
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: filterData,
//                 child: const Text("Filter Data"),
//               ),
//               if (totalPendapatan.isNotEmpty && totalPengeluaran.isNotEmpty)
//                 Column(
//                   children: [
//                     Text("Total Pendapatan: $totalPendapatan"),
//                     Text("Total Pengeluaran: $totalPengeluaran"),
//                     Text("Laba/Rugi: $labaRugi"),
//                     if (filteredPendapatan.isNotEmpty ||
//                         filteredPengeluaran.isNotEmpty)
//                       Column(
//                         children: [
//                           const Text("Data Pendapatan:"),
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: filteredPendapatan.length,
//                               itemBuilder: (context, index) {
//                                 final pendapatan = filteredPendapatan[index];
//                                 return ListTile(
//                                   title:
//                                       Text("Pendapatan: ${pendapatan.harga}"),
//                                   // Tampilkan detail pendapatan sesuai kebutuhan
//                                 );
//                               },
//                             ),
//                           ),
//                           const Text("Data Pengeluaran:"),
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: filteredPengeluaran.length,
//                               itemBuilder: (context, index) {
//                                 final pengeluaran = filteredPengeluaran[index];
//                                 return ListTile(
//                                   title:
//                                       Text("Pengeluaran: ${pengeluaran.harga}"),
//                                   // Tampilkan detail pengeluaran sesuai kebutuhan
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }