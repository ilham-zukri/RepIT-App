import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/spare_part.dart';
import 'package:repit_app/widgets/spare_part_status_box_builder.dart';

import '../pages/spare_part_detail.dart';

class SparePartCard extends StatelessWidget {
  final SparePart sparePart;
  final bool withDetail;
  final VoidCallback? additionalAction;

  const SparePartCard(
      {super.key,
      required this.sparePart,
      required this.withDetail,
      this.additionalAction});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 165,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        elevation: 5,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          onTap: (additionalAction == null)
              ? () {
                  if (!withDetail) {
                    return;
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SparePartDetail(sparePart: sparePart),
                      ),
                    );
                  }
                }
              : additionalAction,
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xff009199),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (sparePart.id != null)
                            ? sparePart.id.toString()
                            : "#N/A",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      sparePartStatusBoxBuilder(sparePart.status ?? " ", "card")
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 16, right: 16),
                child: Text(
                  sparePart.type,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, bottom: 8),
                child: Table(columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(0.2),
                  2: FlexColumnWidth(2.7)
                }, children: [
                  TableRow(
                    children: [
                      const Text('Brand'),
                      const Text(':'),
                      Text(sparePart.brand)
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
                        child: Text(sparePart.model))
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
                          child: Text(sparePart.serialNumber,
                              maxLines: 1, overflow: TextOverflow.ellipsis))
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
