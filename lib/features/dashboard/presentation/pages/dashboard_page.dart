import 'package:flutter/material.dart';
import 'package:organization/features/dashboard/presentation/widgets/appbar_info_widget.dart';
import 'package:organization/features/dashboard/presentation/widgets/meeting_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side - Statistics
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          AppBarInfoWidget(label: 'Areas', value: '30'),
                          const SizedBox(width: 24),
                          AppBarInfoWidget(label: 'Members', value: '350'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          AppBarInfoWidget(label: 'Units', value: '250'),
                          SizedBox(width: 24),
                          AppBarInfoWidget(label: 'Workers', value: '1000'),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Organization Name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.white70,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'District: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'Calicut',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
