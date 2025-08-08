import 'package:organization/features/weekly_council/domain/enums/week_filtertype.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseWeeklyDataRepo {
  final _client = Supabase.instance.client;

  Future<bool> saveWeeklyData(List<WeeklyData> weeklyDataList) async {
    try {
      for (var i = 0; i < weeklyDataList.length; i++) {
        await _client.from('weekly_council').insert(weeklyDataList[i].toMap());
      }
      return true;
    } catch (e) {
      print("Error inserting to Supabase: $e");
      return false;
    }
  }

  Future<List<WeeklyData>> getFiterData() async {
    final response = await Supabase.instance.client
        .from('weekly_council')
        .select()
        .order('id', ascending: false);

    return (response as List<dynamic>)
        .map((e) => WeeklyData.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}
