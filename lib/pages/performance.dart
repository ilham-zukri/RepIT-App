import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Performance"),
    );
  }
}
