import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/monthly_council/domain/models/monthly_council.dart';
import 'package:organization/features/monthly_council/repository/supabase_monthly_councile_repo.dart';

final saveMonthlyCouncilProvider = FutureProvider.family<bool, List<MonthlyCouncil>>((ref, monthlyDataList) async {
  final repo = SupabaseMonthlyCouncilRepo();
  return await repo.saveMonthlyData(monthlyDataList);
});

final getMonthlyCouncilProvider = FutureProvider<List<MonthlyCouncil>>((ref) async {
  final repo = SupabaseMonthlyCouncilRepo();
  return await repo.getMonthlyData();
});
