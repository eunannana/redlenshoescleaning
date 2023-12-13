import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:redlenshoescleaning/model/pendapatanmodel.dart';

class PendapatanController {
  final pendapatanCollection =
      FirebaseFirestore.instance.collection('pendapatan');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  List<DocumentSnapshot> currentData = [];

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
      deletedAt: DateTime.fromMillisecondsSinceEpoch(0),
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

  // Future<void> removePendapatan(String pendapatanID) async {
  //   try {
  //     final DocumentReference docRef = pendapatanCollection.doc(pendapatanID);

  //     final PendapatanModel existingData = PendapatanModel.fromMap(
  //         (await docRef.get()).data() as Map<String, dynamic>);

  //     final PendapatanModel pendapatanModel = PendapatanModel(
  //       namaCust: existingData.namaCust,
  //       telpCust: existingData.telpCust,
  //       alamatCust: existingData.alamatCust,
  //       sepatuCust: existingData.sepatuCust,
  //       treatment: existingData.treatment,
  //       tglMasuk: existingData.tglMasuk,
  //       tglKeluar: existingData.tglKeluar,
  //       hargaTreatment: existingData.hargaTreatment,
  //       pendapatanID: existingData.pendapatanID,
  //       createdAt: existingData.createdAt,
  //       updatedAt: existingData.updatedAt,
  //       deletedAt: DateTime.now(), // Set deletedAt to current date and time
  //     );

  //     await docRef.update(pendapatanModel.toMap());
  //   } catch (e) {
  //     print('Error while soft deleting pendapatan: $e');
  //   }
  // }

  Future<void> removePendapatan(String pendapatanID) async {
    await pendapatanCollection.doc(pendapatanID).delete();
  }

  Future getPendapatan() async {
    final pendapatan = await pendapatanCollection.get();
    streamController.sink.add(pendapatan.docs);
    return pendapatan.docs;
  }

  // Future<List<DocumentSnapshot>> getPendapatan() async {
  //   try {
  //     final pendapatan = await pendapatanCollection
  //         .where('deletedAt', isEqualTo: 0)
  //         .orderBy('tglMasuk', descending: true)
  //         // .limit(7)
  //         .get();

  //     pendapatan.docs.forEach((doc) {
  //       final pendapatanModel =
  //           PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
  //       print('tglMasuk: ${pendapatanModel.tglMasuk}');
  //     });

  //     // Convert the data to DateTime for sorting
  //     final sortedData = pendapatan.docs.map((doc) {
  //       final pendapatanModel =
  //           PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
  //       final tglMasuk =
  //           DateFormat("dd-MM-yyyy").parse(pendapatanModel.tglMasuk);
  //       return {'doc': doc, 'tglMasuk': tglMasuk};
  //     }).toList();

  //     // Sort the data by tglMasuk in descending order
  //     sortedData.sort((a, b) =>
  //         (b['tglMasuk'] as Comparable).compareTo(a['tglMasuk'] as Comparable));

  //     // Update the stream with the sorted data
  //     streamController.sink.add(
  //         sortedData.map((item) => (item['doc'] as DocumentSnapshot)).toList());

  //     return pendapatan.docs;
  //   } catch (e) {
  //     print('Error while getting pendapatan: $e');
  //     return [];
  //   }
  // }

  Future<String> getTotalPendapatan() async {
    try {
      final pendapatan = await pendapatanCollection
          //.where('deletedAt', isEqualTo: 0)
          .get();
      double total = 0;
      pendapatan.docs.forEach((doc) {
        PendapatanModel pendapatanModel =
            PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
        double hargaTreatment =
            double.tryParse(pendapatanModel.hargaTreatment) ?? 0;
        total += hargaTreatment;
      });
      return total.toStringAsFixed(3);
    } catch (e) {
      print('Error while getting total pendapatan: $e');
      return '0';
    }
  }

  Future<List<PendapatanModel>> getPendapatanByDate(
      DateTime startDate, DateTime endDate) async {
    final pendapatan = await pendapatanCollection
        // .where('deletedAt', isEqualTo: 0)
        .get();
    final filteredPendapatan = <PendapatanModel>[];

    pendapatan.docs.forEach((doc) {
      final pendapatanModel =
          PendapatanModel.fromMap(doc.data() as Map<String, dynamic>);
      final tglMasuk = DateFormat("dd-MM-yyyy").parse(pendapatanModel.tglMasuk);

      if (tglMasuk.isAfter(startDate) && tglMasuk.isBefore(endDate)) {
        filteredPendapatan.add(pendapatanModel);
      } else if (tglMasuk.isAtSameMomentAs(startDate) ||
          tglMasuk.isAtSameMomentAs(endDate)) {
        filteredPendapatan.add(pendapatanModel);
      }
    });

    return filteredPendapatan;
  }

  void dispose() {
    streamController.close();
  }
}
