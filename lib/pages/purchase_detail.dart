import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';
import 'package:repit_app/widgets/purchase_status_box_builder.dart';

class PurchaseDetail extends StatefulWidget {
  final Purchase purchase;

  const PurchaseDetail({super.key, required this.purchase});

  @override
  State<PurchaseDetail> createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  late Purchase purchase;

  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    purchase = widget.purchase;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context, "Purchase Detail"),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  purchase.id.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                purchaseStatusBoxBuilder(purchase.status, 'detail'),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              purchase.vendorName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2.3),
                1: FlexColumnWidth(0.2),
                2: FlexColumnWidth(3)
              },
              children: [
                TableRow(
                  children: [
                    const Text(
                      'Pemohon',
                      style: tableContentStyle,
                    ),
                    const Text(':', style: tableContentStyle),
                    Text(purchase.requester)
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Text(
                        'Pembuat Pembelian',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(purchase.purchasedBy))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Text(
                        'Dibuat Pada',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: Text(purchase.createdAt))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Text(
                        'Total Harga',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 4),
                        child: const Text(':',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15))),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Text(
                        purchase.totalPrice.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              height: size.height / 1.8,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black26),
                  bottom: BorderSide(color: Colors.black26),
                ),
              ),
              child: Expanded(
                child: ListView.builder(
                  itemCount: purchase.items.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        PurchaseItemCard(
                            purchaseItem: purchase.items[index],
                            onDelete: null),
                        (index < purchase.items.length - 1)
                            ? const SizedBox.shrink()
                            : const SizedBox(
                                height: 8,
                              ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xffF05050),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(50)),
                      elevation: 5,
                    ),
                    onPressed: () {

                    },
                    child: const Text('Batal'),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xff009199),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(50)),
                      elevation: 5,
                    ),
                    onPressed: () {

                    },
                    child: const Text('Terima Barang'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
