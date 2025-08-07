import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/weekly_council/domain/enums/week_enum.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:organization/features/weekly_council/infrastructure/repositories/supabase_weekly_council_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final weeklyCouncilResultProvider = FutureProvider<List<WeeklyData>>((
  ref,
) async {
  final response = await Supabase.instance.client
      .from('weekly_council')
      .select()
      .order('id', ascending: false);

  return (response as List<dynamic>)
      .map((e) => WeeklyData.fromMap(e as Map<String, dynamic>))
      .toList();
});

final selectedWeekFilterProvider = StateProvider<MonthlyWeeks?>((ref) => null);

final saveWeeklyCouncilProvider = FutureProvider.family<bool, List<WeeklyData>>(
  (ref, weeklyDataList) async {
    final repo = SupabaseWeeklyDataRepo();
    return await repo.saveWeeklyData(weeklyDataList);
  },
);
