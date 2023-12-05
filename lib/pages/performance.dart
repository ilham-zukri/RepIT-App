import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/performance_data.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/performance_card.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});
  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  PerformanceData performance = PerformanceData(
    period: "Januari 2024",
    totalTickets: 100,
    ticketsMeetingRequirement: 80,
    sla: 80.0
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Performance",
        'setting',
        () {

        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: PerformanceCard(performance: performance),
        )
      )
    );
  }
}
