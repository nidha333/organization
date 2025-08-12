import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_councile_form_dialog.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class MonthlyCouncilPage extends ConsumerStatefulWidget {
  const MonthlyCouncilPage({super.key});

  @override
  ConsumerState<MonthlyCouncilPage> createState() => _MonthlyCouncilPageState();
}

class _MonthlyCouncilPageState extends ConsumerState<MonthlyCouncilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar, // ✅ If NavBar is a widget, call it as a constructor
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMonthlyCouncilDialog(context); // ✅ Call the method
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Row of Title and filter buttons
          Row(
            children: [
              const Text(
                'Monthly Council',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  showAddMonthlyCouncilDialog(context); // ✅ Also open from here
                },
                child: const Text('Add Council'),
              ),
            ],
          ),
          // Row of Datatable , Pie Chart and Bar chart
        ],
      ),
    );
  }

  void showAddMonthlyCouncilDialog(BuildContext context) {
    final now = DateTime.now();
    showDialog(
      context: context,
      builder: (context) {
        return MonthlyCouncilFormDialog(
          initialYear: now.year,
          initialMonth: MonthsEnum.values[now.month - 1],
          day: now,
        );
      },
    );
  }
}
