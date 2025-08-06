import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:organization/features/weekly_council/infrastructure/repositories/supabase_weekly_council_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final weeklyCouncilProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final response = await Supabase.instance.client
      .from('weekly_council')
      .select()
      .order('id', ascending: false);
  return List<Map<String, dynamic>>.from(response);
});

final selectedWeekFilterProvider = StateProvider<String?>((ref) => null);

final saveWeeklyCouncilProvider = FutureProvider.family<bool, List<WeeklyData>>(
  (ref, weeklyDataList) async {
    final repo = SupabaseWeeklyDataRepo();
    return await repo.saveWeeklyData(weeklyDataList);
  },
);
