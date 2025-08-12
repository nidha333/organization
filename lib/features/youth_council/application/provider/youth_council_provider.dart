import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/youth_council/domain/models/youth_council_model.dart';
import 'package:organization/features/youth_council/repository/supabase_youth_council.dart';

final saveYouthCouncilProvider =
    FutureProvider.family<bool, List<YouthCouncil>>((ref, youthDataList) async {
      final repo = SupabaseYouthCouncilRepo();
      return await repo.saveYouthData(youthDataList);
    });

final getYouthCouncilProvider = FutureProvider<List<YouthCouncil>>((ref) async {
  final repo = SupabaseYouthCouncilRepo();
  print('Provider: get monthlycouncil()');
  final response = await repo.getYouthData();
  print("Response: ${response.length}");
  return response;
});
