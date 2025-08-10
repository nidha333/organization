import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:organization/features/invitations/application/providers/invitation_providers.dart';

class InvitationsListWidget extends ConsumerStatefulWidget {
  const InvitationsListWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InvitationsListWidgetState();
}

class _InvitationsListWidgetState extends ConsumerState<InvitationsListWidget> {
  @override
  Widget build(BuildContext context) {
    final invitationList = ref.watch(getInvitationProvider);

    return invitationList.when(
      data: (data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                border: Border.all(color: Colors.yellow.withValues(alpha: .5)),
              ),
              child: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: [
                      Text(
                        '${data[index].programName} ',
                        style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: Colors.yellow.withValues(alpha: .5), borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          DateFormat('dd MMMM yyyy').format(data[index].programDate),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: [
                    Column(
                      children: [
                        Text('Visited'),
                        Text(data[index].visitedCount.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Confirmed'),
                        Text(data[index].confirmed.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Not Sure'),
                        Text(data[index].notSure.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Not Reachable'),
                        Text(data[index].notReachable.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Not Coming'),
                        Text(data[index].notComing.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('Error')),
    );
  }
}
