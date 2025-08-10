import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:organization/features/online_registration/application/providers/online_reg_providers.dart';

class SeasonalProgramsListPage extends ConsumerStatefulWidget {
  const SeasonalProgramsListPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SeasonalProgramsListPageState();
}

class SeasonalProgramsListPageState extends ConsumerState<SeasonalProgramsListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onlinePrograms = ref.watch(getOnlineRegProvider);
    return onlinePrograms.when(
      data: (data) {
        return Column(
          children: data.map((program) {
            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                border: Border.all(color: Colors.yellow.withValues(alpha: .5)),
              ),
              child: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(bottom: 26),
                  child: Row(
                    children: [
                      Text(
                        '${program.programName} ',
                        style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

                        decoration: BoxDecoration(color: Colors.yellow.withValues(alpha: .5), borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          DateFormat('dd MMMM yyyy').format(program.programDate),
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Row(
                  children: [
                    Column(
                      children: [
                        Text('Registered'),
                        Text(program.registeredCount.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Confirmed'),
                        Text(program.confirmedCount.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Messaged'),
                        Text(program.messaged.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Reminded'),
                        Text(program.reminded.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Not Sure'),
                        Text(program.notSure.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Text('Not Coming'),
                        Text(program.notComing.toString(), style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
