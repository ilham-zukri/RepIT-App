import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final String utilization;
  final String status;
  final String assetType;
  final String ram;
  final String cpu;
  final String location;
  final String serialNumber;
  final String? brand;
  final String? model;

  const AssetCard(
      {super.key,
      required this.utilization,
      required this.assetType,
      required this.ram,
      required this.cpu,
      required this.status,
      required this.serialNumber,
      required this.location,
      this.brand,
      this.model});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 170,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xff009199),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      assetType,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    utilization,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  _statusBoxBuilder(status)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1.22),
                  1: FlexColumnWidth(0.2),
                  2: FlexColumnWidth(2.7)
                },
                children: (cpu != "#N/A")
                    ? [
                        TableRow(
                          children: [
                            const Text('CPU'),
                            const Text(':'),
                            Text(cpu)
                          ],
                        ),
                        TableRow(children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: const Text('RAM'),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Text(':')),
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Text(ram))
                        ]),
                        TableRow(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: const Text('Serial Number')),
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: const Text(':')),
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: Text(serialNumber))
                          ],
                        ),
                      ]
                    : [
                  TableRow(
                    children: [
                      const Text('Brand'),
                      const Text(':'),
                      Text(brand ?? ' ')
                    ],
                  ),
                  TableRow(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text('Model'),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':')),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(model ?? ' '))
                  ]),
                  TableRow(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text('Serial Number')),
                      Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: const Text(':')),
                      Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(serialNumber))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusBoxBuilder(String status) {
    final Map<String, dynamic> statusMap = {
      "Ready": {
        "backgroundColor": const Color(0xff98BFFA),
        "textColor": const Color(0xff12315F),
      },
      "Deployed": {
        "backgroundColor": const Color(0xffAEE2AA),
        "textColor": const Color(0xff11410D),
      },
      "On Repair": {
        "backgroundColor": const Color(0xffFAD398),
        "textColor": const Color(0xff885B17),
      },
      "Sub": {
        "backgroundColor": const Color(0xffAADAE9),
        "textColor": const Color(0xff0C4B5F),
      },
      "Scrapped": {
        "backgroundColor": const Color(0xffEDA8A8),
        "textColor": const Color(0xff891F1F),
      },
    };
    if (statusMap.containsKey(status)) {
      final backgroundColor = statusMap[status]['backgroundColor'];
      final textColor = statusMap[status]['textColor'];
      return Container(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Text(
          status,
          style: TextStyle(color: textColor),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
