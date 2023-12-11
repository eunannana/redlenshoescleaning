import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redlenshoescleaning/model/treatmentmodel.dart';

class TreatmentController {
  final treatmentCollection =
      FirebaseFirestore.instance.collection('treatments');

  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addTreatment(TreatmentModel tmodel) async {
    final treatment = tmodel.toMap();

    final DocumentReference docRef = await treatmentCollection.add(treatment);

    final String docID = docRef.id;

    final TreatmentModel treatmentModel = TreatmentModel(
      treatmentID: docID,
      treatment: tmodel.treatment,
      hargaTreatment: tmodel.hargaTreatment,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deletedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );

    await docRef.update(treatmentModel.toMap());
  }

  Future<void> updateTreatment(TreatmentModel tmodel) async {
    final TreatmentModel treatmentModel = TreatmentModel(
      treatment: tmodel.treatment,
      hargaTreatment: tmodel.hargaTreatment,
      treatmentID: tmodel.treatmentID,
      createdAt: tmodel.createdAt,
      updatedAt: DateTime.now(),
      deletedAt: tmodel.deletedAt,
    );

    await treatmentCollection
        .doc(tmodel.treatmentID)
        .update(treatmentModel.toMap());
  }

  // Future<void> removeTreatment(String treatmentID) async {
  //   try {
  //     final DocumentReference docRef = treatmentCollection.doc(treatmentID);

  //     final TreatmentModel existingData = TreatmentModel.fromMap(
  //         (await docRef.get()).data() as Map<String, dynamic>);

  //     final TreatmentModel treatmentModel = TreatmentModel(
  //       treatment: existingData.treatment,
  //       hargaTreatment: existingData.hargaTreatment,
  //       treatmentID: existingData.treatmentID,
  //       createdAt: existingData.createdAt,
  //       updatedAt: DateTime.now(),
  //       deletedAt: DateTime.now(), // Set deletedAt to current date and time
  //     );

  //     await docRef.update(treatmentModel.toMap());
  //   } catch (e) {
  //     print('Error while soft deleting treatment: $e');
  //   }
  // }

  Future<void> removeTreatment(String treatmentID) async {
    await treatmentCollection.doc(treatmentID).delete();
  }

  // Future getTreatment() async {
  //   final treatment =
  //       await treatmentCollection.where('deletedAt', isEqualTo: 0).get();
  //   streamController.sink.add(treatment.docs);
  //   return treatment.docs;
  // }

  Future getTreatment() async {
    final treatment = await treatmentCollection.get();
    streamController.sink.add(treatment.docs);
    return treatment.docs;
  }
}
