// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PendapatanModel {
  String? pendapatanID;
  final String namaCust;
  final String telpCust;
  final String alamatCust;
  final String sepatuCust;
  final String treatment;
  final String tglMasuk;
  final String tglKeluar;
  final String hargaTreatment;
  // final String createdAt;
  // final String updatedAt;
  // final String deletedAt;
  PendapatanModel({
    this.pendapatanID,
    required this.namaCust,
    required this.telpCust,
    required this.alamatCust,
    required this.sepatuCust,
    required this.treatment,
    required this.tglMasuk,
    required this.tglKeluar,
    required this.hargaTreatment,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.deletedAt,
  });

  PendapatanModel copyWith({
    String? pendapatanID,
    String? namaCust,
    String? telpCust,
    String? alamatCust,
    String? sepatuCust,
    String? treatment,
    String? tglMasuk,
    String? tglKeluar,
    String? hargaTreatment,
    // String? createdAt,
    // String? updatedAt,
    // String? deletedAt,
  }) {
    return PendapatanModel(
      pendapatanID: pendapatanID ?? this.pendapatanID,
      namaCust: namaCust ?? this.namaCust,
      telpCust: telpCust ?? this.telpCust,
      alamatCust: alamatCust ?? this.alamatCust,
      sepatuCust: sepatuCust ?? this.sepatuCust,
      treatment: treatment ?? this.treatment,
      tglMasuk: tglMasuk ?? this.tglMasuk,
      tglKeluar: tglKeluar ?? this.tglKeluar,
      hargaTreatment: hargaTreatment ?? this.hargaTreatment,
      // createdAt: createdAt ?? this.createdAt,
      // updatedAt: updatedAt ?? this.updatedAt,
      // deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pendapatanID': pendapatanID,
      'namaCust': namaCust,
      'telpCust': telpCust,
      'alamatCust': alamatCust,
      'sepatuCust': sepatuCust,
      'treatment': treatment,
      'tglMasuk': tglMasuk,
      'tglKeluar': tglKeluar,
      'hargaTreatment': hargaTreatment,
      // 'createdAt': createdAt,
      // 'updatedAt': updatedAt,
      // 'deletedAt': deletedAt,
    };
  }

  factory PendapatanModel.fromMap(Map<String, dynamic> map) {
    return PendapatanModel(
      pendapatanID: map['pendapatanID'] as String,
      namaCust: map['namaCust'] as String,
      telpCust: map['telpCust'] as String,
      alamatCust: map['alamatCust'] as String,
      sepatuCust: map['sepatuCust'] as String,
      treatment: map['treatment'] as String,
      tglMasuk: map['tglMasuk'] as String,
      tglKeluar: map['tglKeluar'] as String,
      hargaTreatment: map['hargaTreatment'] as String,
      // createdAt: map['createdAt'] as String,
      // updatedAt: map['updatedAt'] as String,
      // deletedAt: map['deletedAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PendapatanModel.fromJson(String source) =>
      PendapatanModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PendapatanModel(pendapatanID: $pendapatanID, namaCust: $namaCust, telpCust: $telpCust, alamatCust: $alamatCust, sepatuCust: $sepatuCust, treatment: $treatment, tglMasuk: $tglMasuk, tglKeluar: $tglKeluar, hargaTreatment: $hargaTreatment)';
  }

  @override
  bool operator ==(covariant PendapatanModel other) {
    if (identical(this, other)) return true;

    return other.pendapatanID == pendapatanID &&
        other.namaCust == namaCust &&
        other.telpCust == telpCust &&
        other.alamatCust == alamatCust &&
        other.sepatuCust == sepatuCust &&
        other.treatment == treatment &&
        other.tglMasuk == tglMasuk &&
        other.tglKeluar == tglKeluar &&
        other.hargaTreatment == hargaTreatment;
    // other.createdAt == createdAt;
    // other.updatedAt == updatedAt &&
    // other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return pendapatanID.hashCode ^
        namaCust.hashCode ^
        telpCust.hashCode ^
        alamatCust.hashCode ^
        sepatuCust.hashCode ^
        treatment.hashCode ^
        tglMasuk.hashCode ^
        tglKeluar.hashCode ^
        hargaTreatment.hashCode;
    // createdAt.hashCode;
    // updatedAt.hashCode ^
    // deletedAt.hashCode;
  }
}
