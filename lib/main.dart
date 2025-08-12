import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_council.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_page.dart';
import 'package:organization/features/youth_council/presentation/pages/youth_council.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zsjiisbhuyojylybvayu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpzamlpc2JodXlvanlseWJ2YXl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQzMjYxMjQsImV4cCI6MjA2OTkwMjEyNH0.OIse_D0uQGGi_XATw8a-ELOMzPni_jRH644Pmm1RDPo',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardPage(),
      theme: ThemeData(
        brightness: Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
