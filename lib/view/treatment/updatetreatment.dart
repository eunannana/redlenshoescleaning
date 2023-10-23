import 'package:flutter/material.dart';

class UpdateTreatment extends StatefulWidget {
  const UpdateTreatment({super.key});

  @override
  State<UpdateTreatment> createState() => _UpdateTreatmentState();
}

class _UpdateTreatmentState extends State<UpdateTreatment> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
// import 'package:redlenshoescleaning/model/treatmentmodel.dart';

// class UpdateTreatment extends StatefulWidget {
//   const UpdateTreatment({
//     Key? key,
//     this.treatmentID,
//     this.treatment,
//     this.hargaTreatment,
//   }) : super(key: key);

//   final String? treatmentID;
//   final String? treatment;
//   final String? hargaTreatment;

//   @override
//   State<UpdateTreatment> createState() => _UpdateTreatmentState();
// }

// class _UpdateTreatmentState extends State<UpdateTreatment> {
//   var treatmentController = TreatmentController();

//   final _formkey = GlobalKey<FormState>();

//   String? newtreatment;
//   String? newhargaTreatment;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFD9D9D9),
//         centerTitle: true,
//         title: Text(
//           'Edit Treatment',
//           style: GoogleFonts.inter(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Container(
//               width: 350,
//               height: 400,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFD9D9D9),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Form(
//                 key: _formkey,
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 30.0,
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Jenis Treatment',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.start,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 300,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Jenis treatment tidak boleh kosong!';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             newtreatment = value;
//                           },
//                           initialValue: widget.treatment,
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(
//                           vertical: 10.0,
//                           horizontal: 30.0,
//                         ),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'Harga',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.start,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: 300,
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Harga tidak boleh kosong!';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             newhargaTreatment = value;
//                           },
//                           initialValue: widget.hargaTreatment,
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 backgroundColor: Colors.white,
//                                 title: const Text('Konfirmasi Perubahan'),
//                                 content: const Text(
//                                     'Yakin ingin mengubah Treatment?'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     child: const Text(
//                                       'Batal',
//                                       style: TextStyle(color: Colors.red),
//                                     ),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   TextButton(
//                                     child: const Text(
//                                       'Ubah',
//                                       style: TextStyle(color: Colors.blue),
//                                     ),
//                                     onPressed: () {
//                                       if (_formkey.currentState!.validate()) {
//                                         _formkey.currentState!.save();
//                                         TreatmentModel tm = TreatmentModel(
//                                           treatmentID: widget.treatmentID,
//                                           treatment: newtreatment!.toString(),
//                                           hargaTreatment:
//                                               newhargaTreatment!.toString(),
//                                         );
//                                         treatmentController.updateTreatment(tm);
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text('Treatment Berubah'),
//                                           ),
//                                         );
//                                         Navigator.pop(context, true);
//                                         Navigator.pop(context, true);
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF454BE0),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           minimumSize: const Size(150, 50),
//                         ),
//                         child: const Text(
//                           'Simpan',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
