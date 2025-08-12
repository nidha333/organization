import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/features/monthly_council/domain/models/monthly_council.dart';
import 'package:organization/features/youth_council/domain/models/youth_council_model.dart';

Widget buildYouthDataTable(List<YouthCouncil> storedData, DateTime filter) {
  if (storedData.isEmpty) {
    return const Center(
      child: Text(
        "No records for this month",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        Row(
          children: [
            Text(
              DateFormat('MMMM yyyy').format(filter),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ElevatedButton(onPressed: () {}, child: Text('edit')),
          ],
        ),

        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateColor.resolveWith(
                  (_) => Colors.blue.shade800,
                ),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                dataRowColor: WidgetStateColor.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? Colors.blue.shade100
                      : Colors.white,
                ),
                columns: const [
                  DataColumn(label: Text(AppStrings.area)),
                  DataColumn(label: Text(AppStrings.status)),
                  DataColumn(label: Text(AppStrings.participation)),
                  DataColumn(label: Text(AppStrings.year)),
                  DataColumn(label: Text(AppStrings.month)),
                  DataColumn(label: Text(AppStrings.day)),
                ],
                rows: storedData.map<DataRow>((YouthCouncil item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          item.area,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          item.status.value,
                          style: TextStyle(color: item.status.color),
                        ),
                      ),
                      DataCell(
                        Text(
                          item.participation.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          item.year.toString(),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          item.month.value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          DateFormat('yyyy-MM-dd').format(item.day),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
