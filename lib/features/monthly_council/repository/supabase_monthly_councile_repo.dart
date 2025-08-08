import 'package:organization/features/monthly_council/domain/models/monthly_council.dart';

class SupabaseMonthlyCouncilRepo {
  Future<bool> saveMonthlyData(List<MonthlyCouncil> monthlyDataList) async {
    try {
      // TODO

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<MonthlyCouncil>> getMonthlyData() async {
    try {
      // TODO

      return [];
    } catch (e) {
      return [];
    }
  }
}
