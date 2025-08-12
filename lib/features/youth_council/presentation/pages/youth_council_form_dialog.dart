import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/data/areas.dart';
import 'package:organization/features/monthly_council/application/providers/monthly_council_providers.dart';
import 'package:organization/features/monthly_council/domain/models/monthly_council.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class YouthCouncilFormDialog extends ConsumerStatefulWidget {
  final int initialYear;
  final MonthsEnum initialMonth;
  final DateTime day;

  const YouthCouncilFormDialog({
    super.key,
    required this.initialYear,
    required this.initialMonth,
    required this.day,
  });

  @override
  ConsumerState<YouthCouncilFormDialog> createState() =>
      _YouthCouncilFormDialogState();
}

class _YouthCouncilFormDialogState
    extends ConsumerState<YouthCouncilFormDialog> {
  late int selectedYear;
  late MonthsEnum selectedMonth;
  late DateTime selectedDate;

  late List<MeetingStatus> selectedStatusList;
  late List<TextEditingController> percentageControllers;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
    selectedDate = widget.day;

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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final idx = picked.month - 1;
      final safeMonth = idx >= 0 && idx < MonthsEnum.values.length
          ? MonthsEnum.values[idx]
          : MonthsEnum.january;
      setState(() {
        selectedDate = picked;
        selectedYear = picked.year;
        selectedMonth = safeMonth;
      });
    }
  }

  Future<void> _onSavePressed() async {
    final List<MonthlyCouncil> monthListData = [];

    for (var i = 0; i < areaList.length; i++) {
      final percentText = percentageControllers[i].text;
      if (percentText.isEmpty) continue;
      final participation = int.tryParse(percentText);
      if (participation == null) continue;

      monthListData.add(
        MonthlyCouncil(
          area: areaList[i],
          status: selectedStatusList[i],
          participation: participation,
          month: selectedMonth,
          year: selectedYear,
          day: selectedDate,
        ),
      );
    }

    if (monthListData.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No valid rows to insert')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await ref.read(
        saveMonthlyCouncilProvider(monthListData).future,
      );

      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to save')));
      }
    } catch (e, st) {
      debugPrint('Error saving monthly council: $e');
      debugPrintStack(stackTrace: st);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Monthly Council Entry",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Day selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Selected Day: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(color: Colors.blue),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text("Select Day"),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Table header
              Container(
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

              // Table rows
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
                                if (val != null) {
                                  setState(() => selectedStatusList[i] = val);
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

              // Save button
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
      ),
    );
  }
}
