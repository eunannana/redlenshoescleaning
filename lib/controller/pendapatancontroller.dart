import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';
import 'package:redlenshoescleaning/view/pendapatan/pendapatan.dart';

class PendapatanController {
  final pendapatanCollection =
      FirebaseFirestore.instance.collection('pendapatan');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPendapatan(PendapatanModel penmodel) async {
    final pendapatan = penmodel.toMap();

    final DocumentReference docRef = await pendapatanCollection.add(pendapatan);

    final String docID = docRef.id;

    final PendapatanModel pendapatanModel = PendapatanModel(
      pendapatanID: docID,
      namaCust: penmodel.namaCust,
      telpCust: penmodel.telpCust,
      alamatCust: penmodel.alamatCust,
      sepatuCust: penmodel.sepatuCust,
      treatment: penmodel.treatment,
      tglMasuk: penmodel.tglMasuk,
      tglKeluar: penmodel.tglKeluar,
      hargaTreatment: penmodel.hargaTreatment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
    );

    await docRef.update(pendapatanModel.toMap());
  }

  Future<void> updatePendapatan(PendapatanModel penmodel) async {
    final PendapatanModel pendapatanModel = PendapatanModel(
      namaCust: penmodel.namaCust,
      telpCust: penmodel.telpCust,
      alamatCust: penmodel.alamatCust,
      sepatuCust: penmodel.sepatuCust,
      treatment: penmodel.treatment,
      tglMasuk: penmodel.tglMasuk,
      tglKeluar: penmodel.tglKeluar,
      hargaTreatment: penmodel.hargaTreatment,
      pendapatanID: penmodel.pendapatanID,
      createdAt: penmodel.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: penmodel.deletedAt,
    );

    await pendapatanCollection
        .doc(penmodel.pendapatanID)
        .update(pendapatanModel.toMap());
  }

  Future<void> removePendapatan(String pendapatanID) async {
    await pendapatanCollection.doc(pendapatanID).delete();
  }

  Future<List<DocumentSnapshot>> getPendapatan() async {
    final pendapatan = await pendapatanCollection.get();
    streamController.sink.add(pendapatan.docs);
    return pendapatan.docs;
  }

  Future<String> getTotalPendapatan() async {
    try {
      final pendapatan = await pendapatanCollection.get();
      double total = 0;
      pendapatan.docs.forEach((doc) {
        PendapatanModel pendapatanModel =
            PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
        double hargaTreatment =
            double.tryParse(pendapatanModel.hargaTreatment) ?? 0;
        total += hargaTreatment;
      });
      return total.toStringAsFixed(2);
    } catch (e) {
      print('Error while getting total pendapatan: $e');
      return '0';
    }
  }

  Future<List<PendapatanModel>> getPendapatanByDate(
      DateTime startDate, DateTime endDate) async {
    final pendapatan = await pendapatanCollection.get();
    final filteredPendapatan = <PendapatanModel>[];

    pendapatan.docs.forEach((doc) {
      final pendapatanModel =
          PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
      final tglMasuk = DateFormat("dd-MM-yyyy").parse(pendapatanModel.tglMasuk);

      if (tglMasuk.isAfter(startDate) && tglMasuk.isBefore(endDate)) {
        filteredPendapatan.add(pendapatanModel);
      }
    });

    return filteredPendapatan;
  }
}
