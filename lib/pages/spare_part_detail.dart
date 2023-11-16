import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repit_app/data_classes/spare_part.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../services.dart';
import '../widgets/spare_part_status_box_builder.dart';

class SparePartDetail extends StatefulWidget {
  final SparePart sparePart;

  const SparePartDetail({super.key, required this.sparePart});

  @override
  State<SparePartDetail> createState() => _SparePartDetailState();
}

class _SparePartDetailState extends State<SparePartDetail> {
  late SparePart sparePart;
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const EdgeInsets tableContentMargin = EdgeInsets.only(top: 8);

  @override
  void initState() {
    sparePart = widget.sparePart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Detail Spare Part",
        'qr',
        () {
          showQr(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sparePart.id.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                sparePartStatusBoxBuilder(sparePart.status ?? " ", "detail")
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              sparePart.type,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(0.2),
                2: FlexColumnWidth(3)
              },
              children: [
                TableRow(children: [
                  const Text(
                    'Brand',
                  ),
                  const Text(':', style: tableContentStyle),
                  Text(sparePart.brand)
                ]),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        'Model',
                      ),
                    ),
                    Container(
                        margin: tableContentMargin,
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                      margin: tableContentMargin,
                      child: Text(sparePart.model, style: tableContentStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        'Serial Number',
                      ),
                    ),
                    Container(
                        margin: tableContentMargin,
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                      margin: tableContentMargin,
                      child: Text(sparePart.serialNumber,
                          style: tableContentStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        'Nomor Pembelian',
                      ),
                    ),
                    Container(
                        margin: tableContentMargin,
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                      margin: tableContentMargin,
                      child: Text(sparePart.purchaseId!.toString(),
                          style: tableContentStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        'Ditambahkan Pada',
                      ),
                    ),
                    Container(
                        margin: tableContentMargin,
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                      margin: tableContentMargin,
                      child:
                          Text(sparePart.createdAt!, style: tableContentStyle),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        'Digunakan Pada',
                      ),
                    ),
                    Container(
                        margin: tableContentMargin,
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                      margin: tableContentMargin,
                      child: Text(
                          (sparePart.assetId != null)
                              ? sparePart.assetId!.toString()
                              : "#N/A",
                          style: tableContentStyle),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showQr(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('QR Code'),
          content: Image(
            image: NetworkImage(Services.url + (sparePart.qrPath as String)),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF05050),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5),
              child: const Text("Tutup"),
            ),
            SizedBox(
              width: 95,
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(
                      text: Services.url + (sparePart.qrPath as String)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Link"),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
