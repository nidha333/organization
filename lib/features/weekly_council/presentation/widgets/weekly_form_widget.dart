import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/data/areas.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_enum.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';

// ignore: must_be_immutable
class WeeklyFormWidget extends ConsumerWidget {
  WeeklyFormWidget({super.key});

  final int selectedYear = 2025;
  MonthsEnum selectedMonth = MonthsEnum.january;
  MonthlyWeeks selectedWeek = MonthlyWeeks.week1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<MeetingStatus> selectedStatusList = List.generate(
      areaList.length,
      (_) => MeetingStatus.done,
    );

    List<TextEditingController> percentageControllers = List.generate(
      areaList.length,
      (_) => TextEditingController(text: '0'),
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
                        // Year is final; not changeable here
                      },
                    ),
                    DropdownButton<MonthsEnum>(
                      value: selectedMonth,
                      items: MonthsEnum.values
                          .map(
                            (m) =>
                                DropdownMenuItem(value: m, child: Text(m.name)),
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
                    DropdownButton<MonthlyWeeks>(
                      value: selectedWeek,
                      items: MonthlyWeeks.values
                          .map(
                            (w) =>
                                DropdownMenuItem(value: w, child: Text(w.name)),
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
                  child: const Row(
                    children: [
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
                              child: DropdownButtonFormField<MeetingStatus>(
                                value: selectedStatusList[i],
                                items: MeetingStatus.values
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status.value),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setSheetState(() {
                                      selectedStatusList[i] = val;
                                    });
                                  }
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
                    onPressed: () {
                      final List<WeeklyData> weekListData = [];

                      for (var i = 0; i < areaList.length; i++) {
                        final percentText = percentageControllers[i].text;
                        if (percentText.isEmpty) continue;

                        final percentage = int.tryParse(percentText);
                        if (percentage == null) continue;

                        final data = WeeklyData(
                          area: areaList[i],
                          status: selectedStatusList[i],
                          percentage: percentage,
                          month: selectedMonth,
                          week: selectedWeek,
                          year: selectedYear,
                        );

                        weekListData.add(data);
                      }

                      ref.read(saveWeeklyCouncilProvider(weekListData));
                      Navigator.pop(context);
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
