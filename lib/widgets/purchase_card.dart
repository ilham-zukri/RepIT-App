import 'package:flutter/material.dart';
import 'package:repit_app/widgets/purchase_status_box_builder.dart';

class PurchaseCard extends StatelessWidget {
  const PurchaseCard({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 180,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: InkWell(
          onTap: () {},
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                width: size.width,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xff009199),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "28-08-28",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    Text(
                      "1",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CV Platinum Sinar Asia",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      "Bob Smith  ",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.22),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth(2.7)
                      },
                      children: [
                        TableRow(children: [
                          const Text('Total Harga'),
                          const Text(':'),
                          Text(
                          "2.000.000",
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    purchaseStatusBoxBuilder('In Progress', 'card')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
