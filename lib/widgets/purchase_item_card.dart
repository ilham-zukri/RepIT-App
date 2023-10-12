import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase_item.dart';

class PurchaseItemCard extends StatelessWidget {
  final PurchaseItem purchaseItem;

  const PurchaseItemCard({super.key, required this.purchaseItem});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
        width: size.width,
        height: 190,
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          elevation: 5,
          child: InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 45,
                  decoration: const BoxDecoration(
                    color: Color(0xff009199),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 12,
                      bottom: 12,
                    ),
                    child: Text(
                      purchaseItem.assetType,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          purchaseItem.brand,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
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
                          TableRow(
                            children: [
                              const Text('Model'),
                              const Text(':'),
                              Text(purchaseItem.model)
                            ],
                          ),
                          TableRow(children: [
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: const Text('Jumlah Item'),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: const Text(':')),
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              child: Text(
                                purchaseItem.amount.toString(),
                              ),
                            )
                          ]),
                          TableRow(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  child: const Text('Harga Satuan')),
                              Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  child: const Text(':')),
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: Text(
                                  purchaseItem.priceEa.toString(),
                                ),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  child: const Text('Total Harga')),
                              Container(
                                  margin: const EdgeInsets.only(top: 6),
                                  child: const Text(':')),
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                child: Text(
                                  purchaseItem.priceTotal.toString(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
