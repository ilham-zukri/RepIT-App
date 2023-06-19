import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  final String utilization;
  final String assetType;
  final String ram;
  final String cpu;
  final String location;
  final String serialNumber;

  const AssetCard(
      {super.key,
      required this.utilization,
      required this.assetType,
      required this.ram,
      required this.cpu,
      required this.serialNumber,
      required this.location});

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
              margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
              child: Text(
                utilization,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 8),
              child: Table(
                columnWidths: const {
                  0:FlexColumnWidth(1.22),
                  1:FlexColumnWidth(0.2),
                  2:FlexColumnWidth(2.7)
                },
                children: [
                  TableRow(children: [
                    const Text('CPU'),
                    const Text(':'),
                    Text(cpu)
                  ],),
                  TableRow(children: [
                    Container(child: const Text('RAM'), margin: EdgeInsets.only(top: 8),),
                    Container(child: const Text(':'), margin: EdgeInsets.only(top: 8)),
                    Container(child: Text(ram),  margin: EdgeInsets.only(top: 8))
                  ]),
                  TableRow(children: [
                    Container(child: const Text('Serial Number'), margin: EdgeInsets.only(top: 8)),
                    Container(child: const Text(':'), margin: EdgeInsets.only(top: 8)),
                    Container(child: Text(serialNumber),  margin: EdgeInsets.only(top: 8))
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
