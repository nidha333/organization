import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/data/areas.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';
import 'package:organization/features/weekly_council/domain/model/weekly_council_model.dart';

class WeeklyFormWidget extends ConsumerStatefulWidget {
  final int initialYear;
  final MonthsEnum initialMonth;
  final MonthlyWeeks initialWeek;

  const WeeklyFormWidget({
    Key? key,
    required this.initialYear,
    required this.initialMonth,
    required this.initialWeek,
  }) : super(key: key);

  @override
  ConsumerState<WeeklyFormWidget> createState() => _WeeklyFormWidgetState();
}

class _WeeklyFormWidgetState extends ConsumerState<WeeklyFormWidget> {
  late int selectedYear;
  late MonthsEnum selectedMonth;
  late MonthlyWeeks selectedWeek;

  late List<MeetingStatus> selectedStatusList;
  late List<TextEditingController> percentageControllers;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
    selectedWeek = widget.initialWeek;

    selectedStatusList = List.generate(
      areaList.length,
      (_) => MeetingStatus.done,
    );
    percentageControllers = List.generate(
      areaList.length,
      (_) => TextEditingController(text: '0'),
    );
  }

  @override
  void dispose() {
    for (final c in percentageControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSavePressed() async {
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

    if (weekListData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No valid rows to insert')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await ref.read(
        saveWeeklyCouncilProvider(weekListData).future,
      );

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,

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
                      .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedYear = val);
                  },
                ),
                DropdownButton<MonthsEnum>(
                  value: selectedMonth,
                  items: MonthsEnum.values
                      .map(
                        (m) => DropdownMenuItem(value: m, child: Text(m.value)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedMonth = val);
                  },
                ),
                DropdownButton<MonthlyWeeks>(
                  value: selectedWeek,
                  items: MonthlyWeeks.values
                      .map(
                        (w) => DropdownMenuItem(value: w, child: Text(w.name)),
                      )
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => selectedWeek = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.value),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                setState(() => selectedStatusList[i] = val);
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
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _onSavePressed,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Insert'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
