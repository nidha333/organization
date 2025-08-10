import 'package:organization/features/online_registration/domain/models/online_reg_model.dart';

List<OnlineRegModel> onlineData = [];

class SupabaseOnlineRegRepo {
  // final SupabaseClient _client = Supabase.instance.client;

  Future<List<OnlineRegModel>> getOnlineRegPrograms() async {
    return [
      OnlineRegModel(
        id: '1',
        programName: 'Doctors meet',
        programDate: DateTime.now(),
        regStartDate: DateTime.now(),
        regEndDate: DateTime.now(),
        dataByHand: 'Yes',
        registeredCount: 10,
        confirmedCount: 5,
        messaged: 3,
        reminded: 2,
        notSure: 1,
        notComing: 0,
        remarks: 'Remarks 1',
      ),
      OnlineRegModel(
        id: '1',
        programName: 'Tea Party @ Manjeri',
        programDate: DateTime.now(),
        regStartDate: DateTime.now(),
        regEndDate: DateTime.now(),
        dataByHand: 'Yes',
        registeredCount: 10,
        confirmedCount: 5,
        messaged: 3,
        reminded: 2,
        notSure: 1,
        notComing: 0,
        remarks: 'Remarks 1',
      ),
    ];
  }

  Future<bool> createOnlineReg(OnlineRegModel model) async {
    try {
      onlineData.add(model);
      return true;
    } catch (e) {
      throw Exception('Failed to create online registration: $e');
    }
  }

  Future<bool> updateOnlineReg(OnlineRegModel model) async {
    try {
      onlineData = onlineData.map((e) => e.id == model.id ? model : e).toList();
      return true;
    } catch (e) {
      throw Exception('Failed to update online registration: $e');
    }
  }

  Future<bool> deleteOnlineReg(String id) async {
    try {
      onlineData = onlineData.where((e) => e.id != id).toList();
      return true;
    } catch (e) {
      throw Exception('Failed to delete online registration: $e');
    }
  }
}
