// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PengeluaranModel {
  String? pengeluaranId;
  final String keterangan;
  final String harga;
  final String createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  PengeluaranModel({
    this.pengeluaranId,
    required this.keterangan,
    required this.harga,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  PengeluaranModel copyWith({
    String? pengeluaranId,
    String? keterangan,
    String? harga,
    String? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return PengeluaranModel(
      pengeluaranId: pengeluaranId ?? this.pengeluaranId,
      keterangan: keterangan ?? this.keterangan,
      harga: harga ?? this.harga,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pengeluaranId': pengeluaranId,
      'keterangan': keterangan,
      'harga': harga,
      'createdAt': createdAt,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'deletedAt': deletedAt.millisecondsSinceEpoch,
    };
  }

  factory PengeluaranModel.fromMap(Map<String, dynamic> map) {
    return PengeluaranModel(
      pengeluaranId: map['pengeluaranId'] != null ? map['pengeluaranId'] as String : null,
      keterangan: map['keterangan'] as String,
      harga: map['harga'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      deletedAt: DateTime.fromMillisecondsSinceEpoch(map['deletedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory PengeluaranModel.fromJson(String source) =>
      PengeluaranModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PengeluaranModel(pengeluaranId: $pengeluaranId, keterangan: $keterangan, harga: $harga, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant PengeluaranModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.pengeluaranId == pengeluaranId &&
      other.keterangan == keterangan &&
      other.harga == harga &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return pengeluaranId.hashCode ^
      keterangan.hashCode ^
      harga.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
