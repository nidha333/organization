import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_councile_form_dialog.dart';

class MonthlyCouncilPage extends ConsumerStatefulWidget {
  const MonthlyCouncilPage({super.key});

  @override
  ConsumerState<MonthlyCouncilPage> createState() => _MonthlyCouncilPageState();
}

class _MonthlyCouncilPageState extends ConsumerState<MonthlyCouncilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddMonthlyCouncilDialog(context);
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Row of Title and filter buttons
          Row(
            children: [
              Text('Monthly Council', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text('Add Council')),
            ],
          ),
          // Row of Datatable , Pie Chart and Bar chart
        ],
      ),
    );
  }

  void showAddMonthlyCouncilDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MonthlyCouncilFormDialog();
      },
    );
  }
}
