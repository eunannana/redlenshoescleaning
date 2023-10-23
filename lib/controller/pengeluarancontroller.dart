import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redlenshoescleaning/model/pengeluaranmodel.dart';

class PengeluaranController {
  final pengeluaranCollection =
      FirebaseFirestore.instance.collection('pengeluaran');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPengeluaran(PengeluaranModel pmodel) async {
    final pengeluaran = pmodel.toMap();

    final DocumentReference docRef =
        await pengeluaranCollection.add(pengeluaran);

    final String docID = docRef.id;

    final PengeluaranModel pengeluaranModel = PengeluaranModel(
        pengeluaranId: docID,
        harga: pmodel.harga,
        keterangan: pmodel.keterangan,
        createdAt: pmodel.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: DateTime.now(),);

    await docRef.update(pengeluaranModel.toMap());
  }

  Future<void> updatePengeluaran(PengeluaranModel pmodel) async {
    final PengeluaranModel pengeluaranModel = PengeluaranModel(
        pengeluaranId: pmodel.pengeluaranId,
        keterangan: pmodel.keterangan,
        harga: pmodel.harga,
        createdAt: pmodel.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: pmodel.deletedAt,);

    await pengeluaranCollection
        .doc(pmodel.pengeluaranId)
        .update(pengeluaranModel.toMap());
  }

  Future<void> removePengeluaran(String pengeluaranId) async {
    await pengeluaranCollection.doc(pengeluaranId).delete();
  }

  Future getPengeluaran() async {
    final pengeluaran = await pengeluaranCollection.get();
    streamController.sink.add(pengeluaran.docs);
    return pengeluaran.docs;
  }

  Future<String> getTotalPengeluaran() async {
    try {
      final pengeluaran = await pengeluaranCollection.get();
      double total = 0;
      pengeluaran.docs.forEach((doc) {
        PengeluaranModel pengeluaranModel =
            PengeluaranModel.fromMap(doc.data() as Map<String, dynamic>);
        double harga = double.tryParse(pengeluaranModel.harga) ?? 0;
        total += harga;
      });
      return total.toStringAsFixed(2);
    } catch (e) {
      print('Error while getting total pengeluaran: $e');
      return '0';
    }
  }
}
