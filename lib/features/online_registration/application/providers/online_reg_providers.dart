import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/online_registration/domain/models/online_reg_model.dart';
import 'package:organization/features/online_registration/repository/supabase_online_reg_repo.dart';

// Repository provider
final onlineRegRepositoryProvider = Provider<SupabaseOnlineRegRepo>((ref) {
  return SupabaseOnlineRegRepo();
});

final getOnlineRegProvider = FutureProvider((ref) {
  final repo = ref.read(onlineRegRepositoryProvider);
  return repo.getOnlineRegPrograms();
});

final createOnlineRegProvider = FutureProvider.family<bool, OnlineRegModel>((ref, model) async {
  final repo = ref.read(onlineRegRepositoryProvider);
  return repo.createOnlineReg(model);
});

final updateOnlineRegProvider = FutureProvider.family<bool, OnlineRegModel>((ref, model) async {
  final repo = ref.read(onlineRegRepositoryProvider);
  return repo.updateOnlineReg(model);
});

final deleteOnlineRegProvider = FutureProvider.family<bool, String>((ref, id) async {
  final repo = ref.read(onlineRegRepositoryProvider);
  return repo.deleteOnlineReg(id);
});
