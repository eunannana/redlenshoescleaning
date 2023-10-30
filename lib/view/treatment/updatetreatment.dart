import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redlenshoescleaning/controller/treatmentcontroller.dart';
import 'package:redlenshoescleaning/model/treatmentmodel.dart';

class UpdateTreatment extends StatefulWidget {
  const UpdateTreatment({
    Key? key,
    this.treatmentID,
    this.treatment,
    this.hargaTreatment,
  }) : super(key: key);

  final String? treatmentID;
  final String? treatment;
  final String? hargaTreatment;

  @override
  State<UpdateTreatment> createState() => _UpdateTreatmentState();
}

class _UpdateTreatmentState extends State<UpdateTreatment> {
  var treatmentController = TreatmentController();
  final _formkey = GlobalKey<FormState>();

  String? newtreatment;
  String? newhargaTreatment;

  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _hargaTreatmentController =
      TextEditingController();

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 238, 241, 240),
          title: const Text('Konfirmasi Perubahan'),
          content: const Text('Yakin ingin mengubah Treatment?'),
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
                'Ubah',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _formkey.currentState!.save();
                  _updateTreatment();
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateTreatment() {
    final newTreatment = _treatmentController.text;
    final newHargaTreatment = _hargaTreatmentController.text;

    if (newTreatment != null && newHargaTreatment != null) {
      TreatmentModel tm = TreatmentModel(
        treatmentID: widget.treatmentID,
        treatment: newTreatment,
        hargaTreatment: newHargaTreatment,
        updatedAt: DateTime.now(),
      );
      treatmentController.updateTreatment(tm);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Treatment Berubah'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _treatmentController.text = widget.treatment ?? '';
    _hargaTreatmentController.text = widget.hargaTreatment ?? '';
    newtreatment = widget.treatment;
    newhargaTreatment = widget.hargaTreatment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C8346),
        centerTitle: true,
        title: Text(
          'Edit Treatment',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: 350,
              height: 400,
              decoration: BoxDecoration(
                color: const Color(0xff8fd5a6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formkey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: _treatmentController,
                          decoration: InputDecoration(
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
                        child: TextFormField(
                          controller: _hargaTreatmentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harga tidak boleh kosong!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(context);
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
                    ],
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
