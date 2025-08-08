import 'package:flutter/material.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/dashboard/presentation/widgets/appbar_info_widget.dart';
import 'package:organization/features/dashboard/presentation/widgets/meeting_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: NavBar,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meeting Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
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
                  child: MeetingContainer(
                    title: 'Youth Meet',
                    subtitle: 'January',
                    attendance: '35/30',
                    color: Color(0xFF8B5CF6),
                    icon: Icons.group,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
