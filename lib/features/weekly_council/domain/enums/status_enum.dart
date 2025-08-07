import 'package:flutter/material.dart';
import 'package:organization/common/constants/app_colors.dart';

enum MeetingStatus {
  done('Done', AppColors.greenColors),
  notDone('Not Done', AppColors.redColors),
  noRsponse('No Response', AppColors.hashColors);

  const MeetingStatus(this.value, this.color);
  final String value;
  final Color color;

  @override
  String toString() {
    return value;
  }

  String toMap() {
    return value;
  }

  static MeetingStatus fromMap(String str) {
    return MeetingStatus.values.firstWhere(
      (status) => status.value.toLowerCase() == str.toLowerCase(),
      orElse: () => MeetingStatus.noRsponse,
    );
  }
}
