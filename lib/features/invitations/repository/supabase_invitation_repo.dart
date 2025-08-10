import 'package:organization/features/invitations/domain/invitation_model.dart';

var invitations = [
  InvitationModel(
    id: '1',
    programName: 'Program 1',
    programDate: DateTime.now(),
    dataByHand: 'Data by hand',
    visitedCount: 34,
    confirmed: 20,
    notSure: 5,
    notReachable: 20,
    notComing: 10,
    remarks: 'Sqaud work needs more people',
  ),
];

class SupabaseInvitationRepo {
  Future<List<InvitationModel>> getInvitations() async {
    return invitations;
  }

  Future<bool> addInvitation(InvitationModel invitation) async {
    invitations.add(invitation);
    return true;
  }

  Future<bool> updateInvitation(InvitationModel invitation) async {
    invitations.removeWhere((element) => element.id == invitation.id);
    invitations.add(invitation);
    return true;
  }

  Future<bool> deleteInvitation(String id) async {
    invitations.removeWhere((element) => element.id == id);
    return true;
  }
}
