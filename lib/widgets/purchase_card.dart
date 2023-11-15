import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/pages/purchase_detail.dart';
import 'package:repit_app/widgets/purchase_status_box_builder.dart';

class PurchaseCard extends StatelessWidget {
  final Purchase purchase;
  final String usage;

  const PurchaseCard({super.key, required this.purchase, required this.usage});

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PurchaseDetail(purchase: purchase, usage: usage),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
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
                      purchase.createdAt,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    Text(
                      purchase.id.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 16, top: 15, bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchase.vendorName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      purchase.requester,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
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
                            purchase.totalPrice.toString(),
                          )
                        ]),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    purchaseStatusBoxBuilder(purchase.status, 'card')
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
