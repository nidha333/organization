// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvitationModel {
  final String id;
  final String programName;
  final DateTime programDate;
  final String dataByHand;
  final int visitedCount;
  final int confirmed;
  final int notSure;
  final int notReachable;
  final int notComing;
  final String remarks;
  InvitationModel({
    required this.id,
    required this.programName,
    required this.programDate,
    required this.dataByHand,
    required this.visitedCount,
    required this.confirmed,
    required this.notSure,
    required this.notReachable,
    required this.notComing,
    required this.remarks,
  });

  InvitationModel copyWith({
    String? id,
    String? programName,
    DateTime? programDate,
    String? dataByHand,
    int? visitedCount,
    int? confirmed,
    int? notSure,
    int? notReachable,
    int? notComing,
    String? remarks,
  }) {
    return InvitationModel(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      programDate: programDate ?? this.programDate,
      dataByHand: dataByHand ?? this.dataByHand,
      visitedCount: visitedCount ?? this.visitedCount,
      confirmed: confirmed ?? this.confirmed,
      notSure: notSure ?? this.notSure,
      notReachable: notReachable ?? this.notReachable,
      notComing: notComing ?? this.notComing,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'programName': programName,
      'programDate': programDate.millisecondsSinceEpoch,
      'dataByHand': dataByHand,
      'visitedCount': visitedCount,
      'confirmed': confirmed,
      'notSure': notSure,
      'notReachable': notReachable,
      'notComing': notComing,
      'remarks': remarks,
    };
  }

  factory InvitationModel.fromMap(Map<String, dynamic> map) {
    return InvitationModel(
      id: map['id'] as String,
      programName: map['programName'] as String,
      programDate: DateTime.fromMillisecondsSinceEpoch(map['programDate'] as int),
      dataByHand: map['dataByHand'] as String,
      visitedCount: map['visitedCount'] as int,
      confirmed: map['confirmed'] as int,
      notSure: map['notSure'] as int,
      notReachable: map['notReachable'] as int,
      notComing: map['notComing'] as int,
      remarks: map['remarks'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvitationModel.fromJson(String source) => InvitationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvitationModel(id: $id, programName: $programName, programDate: $programDate, dataByHand: $dataByHand, visitedCount: $visitedCount, confirmed: $confirmed, notSure: $notSure, notReachable: $notReachable, notComing: $notComing, remarks: $remarks)';
  }

  @override
  bool operator ==(covariant InvitationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.programName == programName &&
        other.programDate == programDate &&
        other.dataByHand == dataByHand &&
        other.visitedCount == visitedCount &&
        other.confirmed == confirmed &&
        other.notSure == notSure &&
        other.notReachable == notReachable &&
        other.notComing == notComing &&
        other.remarks == remarks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        programName.hashCode ^
        programDate.hashCode ^
        dataByHand.hashCode ^
        visitedCount.hashCode ^
        confirmed.hashCode ^
        notSure.hashCode ^
        notReachable.hashCode ^
        notComing.hashCode ^
        remarks.hashCode;
  }
}
