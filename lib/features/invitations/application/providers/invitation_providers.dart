import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/invitations/domain/invitation_model.dart';
import 'package:organization/features/invitations/repository/supabase_invitation_repo.dart';

final invitationRepoProvider = Provider<SupabaseInvitationRepo>((ref) => SupabaseInvitationRepo());

final getInvitationProvider = FutureProvider<List<InvitationModel>>((ref) async {
  final invitationRepo = ref.read(invitationRepoProvider);
  return invitationRepo.getInvitations();
});

final createInvitationProvider = FutureProvider.family<bool, InvitationModel>((ref, invitation) async {
  final invitationRepo = ref.read(invitationRepoProvider);
  return invitationRepo.addInvitation(invitation);
});

final updateInvitationProvider = FutureProvider.family<bool, InvitationModel>((ref, invitation) async {
  final invitationRepo = ref.read(invitationRepoProvider);
  return invitationRepo.updateInvitation(invitation);
});

final deleteInvitationProvider = FutureProvider.family<bool, String>((ref, id) async {
  final invitationRepo = ref.read(invitationRepoProvider);
  return invitationRepo.deleteInvitation(id);
});
