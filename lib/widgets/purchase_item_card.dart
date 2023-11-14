import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase_item.dart';

class PurchaseItemCard extends StatelessWidget {
  final PurchaseItem purchaseItem;
  final VoidCallback? onDelete;
  final VoidCallback? onAdd;

  const PurchaseItemCard(
      {super.key, required this.purchaseItem, this.onDelete, this.onAdd});

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
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  width: size.width,
                  height: 45,
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
                        purchaseItem.type,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      if (onDelete != null)
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(
                            Icons.remove,
                            color: Colors.red,
                          ),
                        ),
                      if (onAdd != null)
                        IconButton(
                          alignment: Alignment.topCenter,
                          onPressed: onAdd,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        )
                    ],
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
