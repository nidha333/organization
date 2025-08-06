// ignore_for_file: avoid_print

import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseWeeklyDataRepo {
  final _client = Supabase.instance.client;

  Future<bool> saveWeeklyData(List<WeeklyData> weeklyDataList) async {
    try {
      for (var i = 0; i < weeklyDataList.length; i++) {
        await _client.from('weekly_council').insert({
          weeklyDataList[i].toMap(),
        });
      }
      // ignore: use_build_context_synchronously

      return true;
    } catch (e) {
      print("Error inserting to Supabase: $e");
    }
    throw Error;
  }
}
