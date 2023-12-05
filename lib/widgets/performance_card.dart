import 'package:flutter/material.dart';

import '../data_classes/performance_data.dart';

class PerformanceCard extends StatelessWidget {
  final PerformanceData performance;
  static const TextStyle contentTextStyle = TextStyle(fontSize: 14);

  const PerformanceCard({super.key, required this.performance});

  @override
  Widget build(BuildContext context) {
    Color slaColor = Colors.green;
    if (performance.sla <= 80.0) {
      slaColor = Colors.red;
    }else if (performance.sla <= 90.0) {
      slaColor = Colors.yellow;
    }
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 145,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () {},
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xff009199),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        performance.period,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(2.7)
                  },
                  children: [
                    TableRow(
                      children: [
                        const Text(
                          'Total Tiket',
                          style: contentTextStyle,
                        ),
                        const Text(
                          ':',
                          style: contentTextStyle,
                        ),
                        Text(
                          performance.totalTickets.toString(),
                          style: contentTextStyle,
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text(
                            'Tiket Memenuhi Kriteria',
                            style: contentTextStyle,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text(':', style: contentTextStyle),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            performance.ticketsMeetingRequirement.toString(),
                            style: contentTextStyle,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${performance.sla.toString()}%',
                      style: TextStyle(
                        fontSize: 16,
                        color: slaColor,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
