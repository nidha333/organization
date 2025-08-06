import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/data/areas.dart';
import 'package:organization/common/data/months.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';

// ignore: must_be_immutable
class WeeklyFormWidget extends ConsumerWidget {
  WeeklyFormWidget({super.key});

  final List<String> statusOptions = ['Done', 'Not Done', 'No Response'];
  int selectedYear = 2025;
  String selectedMonth = '';
  String selectedWeek = '';

  final List<String> weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];

  @override
  Widget build(BuildContext context, ref) {
    List<String> selectedStatusList = List.generate(
      areaList.length,
      (_) => statusOptions[0],
    );
    List<TextEditingController> percentageControllers = List.generate(
      areaList.length,
      (_) => TextEditingController(),
    );
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "Weekly Council Entry",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  children: [
                    DropdownButton<int>(
                      value: selectedYear,
                      items: [2024, 2025, 2026]
                          .map(
                            (y) =>
                                DropdownMenuItem(value: y, child: Text('$y')),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() {
                            selectedYear = val;
                          });
                        }
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedMonth.isEmpty ? null : selectedMonth,
                      hint: const Text('Select Month'),
                      items: months
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() {
                            selectedMonth = val;
                          });
                        }
                      },
                    ),
                    DropdownButton<String>(
                      value: selectedWeek.isEmpty ? null : selectedWeek,
                      hint: const Text('Select Week'),
                      items: weeks
                          .map(
                            (w) => DropdownMenuItem(value: w, child: Text(w)),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setSheetState(() {
                            selectedWeek = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  color: const Color(0xFFE2E8F0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Area",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          "Status",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "%",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.black26),
                Expanded(
                  child: ListView.separated(
                    itemCount: areaList.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Colors.black12),
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(areaList[i])),
                            Expanded(
                              flex: 4,
                              child: DropdownButtonFormField<String>(
                                value: selectedStatusList[i],
                                items: statusOptions
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setSheetState(() {
                                    selectedStatusList[i] = val!;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: percentageControllers[i],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 1, color: Colors.black26),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      final List<WeeklyData> weekListData = [];
                      // for (var i = 0; areaList.length; i++) {
                      //   final w = WeeklyData(
                      //     area: areaList[i],
                      //     status: statusOptions[i],
                      //   );
                      // }
                      ref.read(saveWeeklyCouncilProvider(weekListData));
                    },
                    child: const Text('Insert'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
