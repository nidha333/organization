import 'package:flutter/material.dart';

class WeeklyCouncilScreen extends StatefulWidget {
  @override
  _WeeklyCouncilScreenState createState() => _WeeklyCouncilScreenState();
}

class _WeeklyCouncilScreenState extends State<WeeklyCouncilScreen> {
  String selectedPeriod = 'This Week';

  final List<AreaData> areaData = [
    AreaData('Area 5', 'Done', 44, '2025', 'Apr'),
    AreaData('Area 4', 'Done', 33, '2025', 'Apr'),
    AreaData('Area 3', 'Not Done', 0, '2025', 'Apr'),
    AreaData('Area 2', 'Not Done', 0, '2025', 'Apr'),
    AreaData('Area 1', 'Done', 22, '2025', 'Apr'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF111827),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildMainContent()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF3B82F6),
        child: Icon(Icons.add, color: Colors.white),
        elevation: 8,
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 80,
      color: Color(0xFF1F2937),
      child: Column(
        children: [
          SizedBox(height: 24),
          Icon(Icons.bar_chart, color: Color(0xFF3B82F6), size: 32),
          SizedBox(height: 32),
          Expanded(
            child: Column(
              children: [
                _buildSidebarIcon(Icons.home),
                SizedBox(height: 32),
                _buildSidebarIcon(Icons.folder),
                SizedBox(height: 32),
                _buildSidebarIcon(Icons.settings),
                SizedBox(height: 32),
                _buildSidebarIcon(Icons.person),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: _buildSidebarIcon(Icons.logout),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarIcon(IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(12),
        child: Icon(icon, color: Color(0xFF9CA3AF), size: 24),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 72,
      color: Color(0xFF1F2937),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF374151), width: 1),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Icon(Icons.arrow_back, color: Color(0xFF9CA3AF)),
            SizedBox(width: 16),
            Text(
              'Weekly Council',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF9FAFB),
              ),
            ),
            Spacer(),
            _buildPeriodButton('This Week', true),
            SizedBox(width: 8),
            _buildPeriodButton('Last Week', false),
            SizedBox(width: 8),
            _buildPeriodButton('Custom', false),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedPeriod = text;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF3B82F6) : Color(0xFF374151),
        foregroundColor: Color(0xFFF9FAFB),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(text),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 1024;

          if (isWideScreen) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildDataTable()),
                SizedBox(width: 32),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildProgressCard()),
                          SizedBox(width: 32),
                          Expanded(child: _buildBarChart()),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                _buildDataTable(),
                SizedBox(height: 32),
                _buildProgressCard(),
                SizedBox(height: 32),
                _buildBarChart(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDataTable() {
    return Card(
      color: Color(0xFF1F2937),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    _buildTableHeader('Area'),
                    _buildTableHeader('Status'),
                    _buildTableHeader('%'),
                    _buildTableHeader('Year'),
                    _buildTableHeader('Month'),
                  ],
                ),
                ...areaData.map((data) => _buildTableRow(data)).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9CA3AF),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  TableRow _buildTableRow(AreaData data) {
    bool isNotDone = data.status == 'Not Done';

    return TableRow(
      decoration: isNotDone
          ? BoxDecoration(color: Colors.red.withOpacity(0.1))
          : null,
      children: [
        _buildTableCell(data.area),
        _buildTableCell(
          data.status,
          color: data.status == 'Done' ? Color(0xFF10B981) : Color(0xFFEF4444),
        ),
        _buildTableCell(data.percentage.toString()),
        _buildTableCell(data.year),
        _buildTableCell(data.month),
      ],
    );
  }

  Widget _buildTableCell(String text, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        text,
        style: TextStyle(color: color ?? Color(0xFFF9FAFB), fontSize: 14),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      color: Color(0xFF1F2937),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Current Week Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF9FAFB),
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: 0.6,
                    strokeWidth: 12,
                    backgroundColor: Color(0xFF374151),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF10B981),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '60.0%',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF9FAFB),
                          ),
                        ),
                        Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildLegendItem('Done (3)', Color(0xFF10B981)),
                _buildLegendItem('Not Done (2)', Color(0xFFEF4444)),
                _buildLegendItem('No Response (0)', Color(0xFF374151)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(text, style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
      ],
    );
  }

  Widget _buildBarChart() {
    final List<double> values = [0.95, 0.75, 0.01, 0.01, 0.40];
    final List<String> labels = [
      'Area 5',
      'Area 4',
      'Area 3',
      'Area 2',
      'Area 1',
    ];
    final List<Color> colors = [
      Color(0xFF3B82F6),
      Color(0xFF3B82F6),
      Color(0xFF374151),
      Color(0xFF374151),
      Color(0xFF3B82F6),
    ];

    return Card(
      color: Color(0xFF1F2937),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Area Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF9FAFB),
              ),
            ),
            SizedBox(height: 24),
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.easeOut,
                            height: 160 * values[index],
                            decoration: BoxDecoration(
                              color: colors[index],
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AreaData {
  final String area;
  final String status;
  final int percentage;
  final String year;
  final String month;

  AreaData(this.area, this.status, this.percentage, this.year, this.month);
}
