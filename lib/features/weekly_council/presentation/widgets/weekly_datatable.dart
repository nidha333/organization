import 'package:flutter/material.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/common/data/months.dart';
import 'package:organization/common/extentions/date_time_extention.dart';
import 'package:organization/features/weekly_council/domain/enums/week_filtertype.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';

Widget buildDataTable(List filteredData, FilteringWeekModel filter) {
  if (filteredData.isEmpty) {
    return const Text(
      "No records for this week",
      style: TextStyle(color: Colors.white70),
    );
  }

  return SizedBox(
    width: double.infinity,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          SizedBox(
            width: 500,
            child: Row(
              children: [
                Text('${filter.year} ${filter.month} ${filter.week}'),
                Spacer(),
                ElevatedButton(onPressed: () {}, child: Text('edit')),
              ],
            ),
          ),
          SizedBox(height: 20),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
              (_) => Colors.blue.shade800,
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
            dataRowColor: MaterialStateColor.resolveWith(
              (states) => Colors.transparent,
            ),
            columns: const [
              DataColumn(label: Text(AppStrings.area)),
              DataColumn(label: Text(AppStrings.status)),
              DataColumn(label: Text(AppStrings.percentage)),
              DataColumn(label: Text(AppStrings.year)),
              DataColumn(label: Text(AppStrings.month)),
              DataColumn(label: Text(AppStrings.week)),
            ],
            rows: filteredData.map<DataRow>((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      item.area,
                      style: const TextStyle(color: Colors.white70),
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
                      item.percentage.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.year.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.month.value,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  DataCell(
                    Text(
                      (item.week.index + 1).toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
