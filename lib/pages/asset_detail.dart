import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repit_app/data_classes/asset.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/status_box_builder.dart';

class AssetDetail extends StatefulWidget {
  final Asset asset;

  const AssetDetail({Key? key, required this.asset}) : super(key: key);

  @override
  State<AssetDetail> createState() => _AssetDetailState();
}

class _AssetDetailState extends State<AssetDetail> {
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static late Asset asset;
  static late String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asset = widget.asset;
    status = asset.status!;
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(
        context,
        'Detail Aset',
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
                  asset.id.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                statusBoxBuilder(status, 'detail')
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              child: Text(
                asset.assetType,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.3),
                1: FlexColumnWidth(0.2),
                2: FlexColumnWidth(3)
              },
              children: [
                TableRow(
                  children: [
                    const Text(
                      'Peruntukan',
                      style: tableContentStyle,
                    ),
                    const Text(':', style: tableContentStyle),
                    Text(asset.utilization)
                  ],
                ),
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text('Pemilik', style: tableContentStyle),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(':', style: tableContentStyle)),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text((asset.ownerId as String), style: tableContentStyle))
                ]),
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text('CPU', style: tableContentStyle),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(':', style: tableContentStyle)),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(asset.cpu, style: tableContentStyle))
                ]),
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text('RAM', style: tableContentStyle),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(':', style: tableContentStyle)),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(asset.ram, style: tableContentStyle))
                ]),
                TableRow(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Serial Number',
                            style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child:
                            Text(asset.serialNumber, style: tableContentStyle))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Brand', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(asset.brand.toString(),
                            style: tableContentStyle))
                  ],
                ),
                TableRow(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: const Text('Model', style: tableContentStyle),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(':', style: tableContentStyle)),
                  Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(asset.model.toString(),
                          style: tableContentStyle))
                ]),
                TableRow(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text('Lokasi', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(asset.location ?? '#N/A', style: tableContentStyle))
                  ],
                ),
              ],
            ),
            (status == 'Ready')
                ? Container(
                    margin: const EdgeInsets.only(top: 32),
                    height: 41,
                    width: size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00ABB3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 5),
                      onPressed: () async {
                        try {
                          Response? response =
                              await Services.acceptAsset(asset.id!);
                          if (mounted) {
                            setState(() {
                              status = response?.data['status'] as String;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => alert(
                                  context,
                                  response!.data['message'],
                                  "Aset berhasil diterima"),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => alert(
                                context,
                                'Error',
                                e.toString(),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Terima",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                : const SizedBox(height: 0)
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
            image: NetworkImage(Services.url + (asset.qrPath as String)),
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
                onPressed: () async{
                  await Clipboard.setData(ClipboardData(text: Services.url + (asset.qrPath as String)));
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
