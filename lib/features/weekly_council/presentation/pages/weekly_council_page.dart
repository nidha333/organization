import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council.groupbarsheet.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_barchart.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_flchart.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_form_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WeeklyCouncilPage extends ConsumerWidget {
  const WeeklyCouncilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(selectedWeekFilterProvider);
    final weeklyCouncilAsync = ref.watch(weeklyCouncilProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly Council"),
        backgroundColor: const Color(0xFF2563EB),
        actions: [
          DropdownButton<String>(
            value: selectedWeek,
            hint: const Text("Filter Week"),
            items: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'All'].map((week) {
              return DropdownMenuItem(value: week, child: Text(week));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(selectedWeekFilterProvider.notifier).state = value;
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWeeklyBottomSheet(context, ref),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
      body: weeklyCouncilAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("No records yet."));
          }

          // Filter by selected week if not "All"
          final filteredData = selectedWeek != "All"
              ? data.where((e) => e['week'] == selectedWeek).toList()
              : data;

          int doneCount = filteredData
              .where((e) => e['status']?.toLowerCase() == 'done')
              .length;
          int notDoneCount = filteredData
              .where((e) => e['status']?.toLowerCase() == 'not done')
              .length;
          int noResponseCount = filteredData
              .where((e) => e['status']?.toLowerCase() == 'no response')
              .length;

          final validData = filteredData
              .where((e) => e['area'] != null && e['persentage'] != null)
              .toList();

          // Prepare grouped bar chart data
          final groupedByWeek = <String, Map<String, int>>{};

          for (var e in data) {
            final weekLabel =
                "${e['month']?.toString().substring(0, 3)} ${e['week'] ?? ''}";
            final status = e['status']?.toString().toLowerCase();
            if (!groupedByWeek.containsKey(weekLabel)) {
              groupedByWeek[weekLabel] = {
                'done': 0,
                'not done': 0,
                'no response': 0,
              };
            }
            if (groupedByWeek[weekLabel] != null &&
                groupedByWeek[weekLabel]!.containsKey(status)) {
              groupedByWeek[weekLabel]![status!] =
                  groupedByWeek[weekLabel]![status]! + 1;
            }
          }

          final weekLabels = groupedByWeek.keys.toList();
          final doneCounts = weekLabels
              .map((e) => groupedByWeek[e]!['done']!)
              .toList();
          final notDoneCounts = weekLabels
              .map((e) => groupedByWeek[e]!['not done']!)
              .toList();
          final noResponseCounts = weekLabels
              .map((e) => groupedByWeek[e]!['no response']!)
              .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. Grouped Weekly Bar Chart
                  GroupedWeeklyBarChart(
                    weekLabels: weekLabels,
                    doneCounts: doneCounts,
                    notDoneCounts: notDoneCounts,
                    noResponseCounts: noResponseCounts,
                  ),

                  const SizedBox(height: 20),

                  /// 2. DataTable
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateColor.resolveWith(
                              (_) => Colors.blue.shade100,
                            ),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            columns: const [
                              DataColumn(label: Text('Area')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('%')),
                              DataColumn(label: Text('Year')),
                              DataColumn(label: Text('Month')),
                              DataColumn(label: Text('Week')),
                            ],
                            rows: filteredData.map((item) {
                              final status =
                                  item['status']?.toString().toLowerCase() ??
                                  '';
                              Color rowColor;

                              switch (status) {
                                case 'done':
                                  rowColor = const Color(0xFF9BEC9D);
                                  break;
                                case 'not done':
                                  rowColor = const Color(0xFFFB9E98);
                                  break;
                                case 'no response':
                                  rowColor = Colors.white;
                                  break;
                                default:
                                  rowColor = Colors.white;
                              }

                              return DataRow(
                                color: WidgetStateProperty.all(rowColor),
                                cells: [
                                  DataCell(Text(item['area'] ?? '')),
                                  DataCell(Text(item['status'] ?? '')),
                                  DataCell(Text(item['persentage'].toString())),
                                  DataCell(Text(item['year'].toString())),
                                  DataCell(Text(item['month'] ?? '')),
                                  DataCell(Text(item['week'] ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 3. Pie Chart
                  PieChartSample3(
                    doneCount: doneCount,
                    notDoneCount: notDoneCount,
                    noResponseCount: noResponseCount,
                  ),

                  const SizedBox(height: 20),

                  /// 4. Simple Bar Chart
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SimpleBarChart(
                        areas: validData
                            .map<String>((e) => e['area']?.toString() ?? '')
                            .toList(),
                        percentages: validData
                            .map<double>(
                              (e) =>
                                  double.tryParse(e['persentage'].toString()) ??
                                  0.0,
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  void _showWeeklyBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return WeeklyFormWidget();
      },
    );
  }
}
