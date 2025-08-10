// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OnlineRegModel {
  final String id;
  final String programName;
  final DateTime programDate;
  final DateTime? regStartDate;
  final DateTime? regEndDate;
  final String dataByHand;
  final int targetCount;
  final int registeredCount;
  final int confirmedCount;
  final int messaged;
  final int reminded;
  final int notSure;
  final int notComing;
  final String remarks;
  OnlineRegModel({
    required this.id,
    required this.programName,
    required this.programDate,
    this.regStartDate,
    this.regEndDate,
    required this.dataByHand,
    required this.targetCount,
    required this.registeredCount,
    required this.confirmedCount,
    required this.messaged,
    required this.reminded,
    required this.notSure,
    required this.notComing,
    required this.remarks,
  });

  OnlineRegModel copyWith({
    String? id,
    String? programName,
    DateTime? programDate,
    DateTime? regStartDate,
    DateTime? regEndDate,
    String? dataByHand,
    int? targetCount,
    int? registeredCount,
    int? confirmedCount,
    int? messaged,
    int? reminded,
    int? notSure,
    int? notComing,
    String? remarks,
  }) {
    return OnlineRegModel(
      id: id ?? this.id,
      programName: programName ?? this.programName,
      programDate: programDate ?? this.programDate,
      regStartDate: regStartDate ?? this.regStartDate,
      regEndDate: regEndDate ?? this.regEndDate,
      dataByHand: dataByHand ?? this.dataByHand,
      targetCount: targetCount ?? this.targetCount,
      registeredCount: registeredCount ?? this.registeredCount,
      confirmedCount: confirmedCount ?? this.confirmedCount,
      messaged: messaged ?? this.messaged,
      reminded: reminded ?? this.reminded,
      notSure: notSure ?? this.notSure,
      notComing: notComing ?? this.notComing,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'programName': programName,
      'programDate': programDate.millisecondsSinceEpoch,
      'regStartDate': regStartDate?.millisecondsSinceEpoch,
      'regEndDate': regEndDate?.millisecondsSinceEpoch,
      'dataByHand': dataByHand,
      'targetCount': targetCount,
      'registeredCount': registeredCount,
      'confirmedCount': confirmedCount,
      'messaged': messaged,
      'reminded': reminded,
      'notSure': notSure,
      'notComing': notComing,
      'remarks': remarks,
    };
  }

  factory OnlineRegModel.fromMap(Map<String, dynamic> map) {
    return OnlineRegModel(
      id: map['id'] as String,
      programName: map['programName'] as String,
      programDate: DateTime.fromMillisecondsSinceEpoch(map['programDate'] as int),
      regStartDate: map['regStartDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['regStartDate'] as int) : null,
      regEndDate: map['regEndDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['regEndDate'] as int) : null,
      dataByHand: map['dataByHand'] as String,
      targetCount: map['targetCount'] as int,
      registeredCount: map['registeredCount'] as int,
      confirmedCount: map['confirmedCount'] as int,
      messaged: map['messaged'] as int,
      reminded: map['reminded'] as int,
      notSure: map['notSure'] as int,
      notComing: map['notComing'] as int,
      remarks: map['remarks'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnlineRegModel.fromJson(String source) => OnlineRegModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OnlineRegModel(id: $id, programName: $programName, programDate: $programDate, regStartDate: $regStartDate, regEndDate: $regEndDate, dataByHand: $dataByHand, registeredCount: $registeredCount, confirmedCount: $confirmedCount, messaged: $messaged, reminded: $reminded, notSure: $notSure, notComing: $notComing, remarks: $remarks)';
  }

  @override
  bool operator ==(covariant OnlineRegModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.programName == programName &&
        other.programDate == programDate &&
        other.regStartDate == regStartDate &&
        other.regEndDate == regEndDate &&
        other.dataByHand == dataByHand &&
        other.targetCount == targetCount &&
        other.registeredCount == registeredCount &&
        other.confirmedCount == confirmedCount &&
        other.messaged == messaged &&
        other.reminded == reminded &&
        other.notSure == notSure &&
        other.notComing == notComing &&
        other.remarks == remarks;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        programName.hashCode ^
        programDate.hashCode ^
        regStartDate.hashCode ^
        regEndDate.hashCode ^
        dataByHand.hashCode ^
        targetCount.hashCode ^
        registeredCount.hashCode ^
        confirmedCount.hashCode ^
        messaged.hashCode ^
        reminded.hashCode ^
        notSure.hashCode ^
        notComing.hashCode ^
        remarks.hashCode;
  }
}
