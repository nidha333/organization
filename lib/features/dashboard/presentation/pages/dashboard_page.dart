import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/dashboard/presentation/widgets/meeting_card.dart';
import 'package:organization/features/invitations/presentation/pages/widgets/invitations_list_widget.dart';
import 'package:organization/features/online_registration/application/providers/online_reg_providers.dart';
import 'package:organization/features/online_registration/presentation/pages/online_reg_form.dart';
import 'package:organization/features/online_registration/presentation/widgets/online_reg_list_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showAddNewProgramDialog(context).then((value) {
            ref.invalidate(getOnlineRegProvider);
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meeting Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: MeetingContainer(
                    title: 'Weekly Meet',
                    subtitle: 'Last Week',
                    attendance: '12/30',
                    color: Color(0xFF10B981),
                    icon: Icons.calendar_today,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: MeetingContainer(
                    title: 'Monthly Meet',
                    subtitle: 'January',
                    attendance: '5/30',
                    color: Color(0xFF3B82F6),
                    icon: Icons.event,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: MeetingContainer(title: 'Youth Meet', subtitle: 'January', attendance: '35/30', color: Color(0xFF8B5CF6), icon: Icons.group),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Seasonal Programs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(child: SeasonalProgramsListPage()),
                  Expanded(child: InvitationsListWidget()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAddNewProgramDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Program'),
          content: Column(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OnlineRegForm()));
                },
                child: Text('Online Registration'),
              ),
              TextButton(onPressed: () {}, child: Text('Offline Registration')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Add')),
          ],
        );
      },
    );
  }
}
