import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:organization/features/weekly_council/infrastructure/repositories/supabase_weekly_council_repo.dart';

final weeklyCouncilResultProvider = FutureProvider<List<WeeklyData>>((
  ref,
) async {
  final repo = SupabaseWeeklyDataRepo();
  return await repo.getFiterData();
});

final saveWeeklyCouncilProvider = FutureProvider.family<bool, List<WeeklyData>>(
  (ref, weeklyDataList) async {
    final repo = SupabaseWeeklyDataRepo();
    return await repo.saveWeeklyData(weeklyDataList);
  },
);
