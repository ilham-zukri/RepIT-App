import 'package:flutter/material.dart';
import 'package:repit_app/pages/asset_detail.dart';
import 'package:repit_app/widgets/status_box_builder.dart';

import 'data_classes/asset.dart';

class AssetCard extends StatelessWidget {
  final Asset asset;
  late bool withDetail;

  AssetCard({super.key, required this.asset, required this.withDetail});

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
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: () {
            if(withDetail){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetDetail(asset: asset),
                ),
              );
            }
          },
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
                        asset.assetType,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        asset.location ?? '#N/A',
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
                margin: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      asset.utilization,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    (asset.status!=null) ? statusBoxBuilder(asset.status!, "card") : const SizedBox.shrink(),
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
                  children: (asset.cpu != "#N/A")
                      ? [
                          TableRow(
                            children: [
                              const Text('CPU'),
                              const Text(':'),
                              Text(asset.cpu)
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
                                child: Text(asset.ram))
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
                                  child: Text(asset.serialNumber))
                            ],
                          ),
                        ]
                      : [
                          TableRow(
                            children: [
                              const Text('Brand'),
                              const Text(':'),
                              Text(asset.brand ?? ' ')
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
                                child: Text(asset.model ?? ' '))
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
                                  child: Text(asset.serialNumber))
                            ],
                          ),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
