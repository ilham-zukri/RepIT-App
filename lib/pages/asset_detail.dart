import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
    status = asset.status;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context, 'Detail Aset'),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  asset.assetType,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20),
                ),
                statusBoxBuilder(status, 'detail')
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 32),
              width: size.width,
              height: 180,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 32),
                child: Text(
                  asset.utilization,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
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
                      'CPU',
                      style: tableContentStyle,
                    ),
                    const Text(':', style: tableContentStyle),
                    Text(asset.cpu)
                  ],
                ),
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
                        child: Text(asset.location, style: tableContentStyle))
                  ],
                ),
              ],
            ),
            (asset.status == 'Ready')
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
                              await Services.acceptAsset(asset.id as int);
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
                          showDialog(
                            context: context,
                            builder: (context) => alert(
                              context,
                              'Error',
                              e.toString(),
                            ),
                          );
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
}
