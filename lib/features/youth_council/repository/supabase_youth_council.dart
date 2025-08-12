import 'dart:developer';
import 'package:organization/features/youth_council/domain/models/youth_council_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseYouthCouncilRepo {
  final _client = Supabase.instance.client;
  Future<bool> saveYouthData(List<YouthCouncil> youthDataList) async {
    try {
      for (var i = 0; i < youthDataList.length; i++) {
        await _client.from('youth_council').insert(youthDataList[i].toMap());
      }
      return true;
    } catch (e) {
      log("Error inserting to Supabase: $e");
      return false;
    }
  }

  Future<List<YouthCouncil>> getYouthData() async {
    try {
      log('function calling');
      final response = await Supabase.instance.client
          .from('youth_council')
          .select()
          .order('id', ascending: false);

      log("Fetched rows: ${response.length}");

      return (response as List<dynamic>)
          .map((e) => YouthCouncil.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      log("Error fetching monthly data: $e");
      log("Stacktrace: $st");
      return [];
    }
  }
}
