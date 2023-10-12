import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/pages/purchase_form.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/priority_box_builder.dart';
import 'package:repit_app/widgets/req_status_box_builder.dart';

import '../data_classes/asset_request.dart';

class AssetRequestDetail extends StatefulWidget {
  final AssetRequest? request;
  final Map<String, dynamic> role;

  const AssetRequestDetail(
      {super.key, required this.request, required this.role});

  @override
  State<AssetRequestDetail> createState() => _AssetRequestDetailState();
}

class _AssetRequestDetailState extends State<AssetRequestDetail> {
  AssetRequest? request;
  late Map<String, dynamic> role;

  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  void initState() {
    super.initState();
    request = widget.request;
    role = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Detail Request"),
      body: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request!.id.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    priorityBoxBuilder(request!.priority, "detail"),
                    const SizedBox(
                      width: 8,
                    ),
                    reqStatusBoxBuilder(request!.status, "detail")
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              request!.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              request!.description,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 24,
            ),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(0.2),
                2: FlexColumnWidth(3)
              },
              children: [
                TableRow(
                  children: [
                    const Text(
                      'Ditujukan Untuk',
                      style: tableContentStyle,
                    ),
                    const Text(':', style: tableContentStyle),
                    Text(request!.forUser)
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Pemohon',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(request!.requester))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Lokasi',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(request!.location))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Dibuat Pada',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(request!.createdAt))
                  ],
                ),
                TableRow(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: const Text(
                        'Disetujui Pada',
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: const Text(':', style: tableContentStyle)),
                    Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Text(request!.approvedAt ?? "#N/A"))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            buttonBuilder(role, context),
          ],
        ),
      ),
    );
  }

  Widget buttonBuilder(Map<String, dynamic> role, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (role['asset_approval'] == 1 && request!.status == "Requested") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: size.width / 2.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff009199),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                elevation: 5,
              ),
              onPressed: () async {
                try {
                  Response? response;
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Konfirmasi"),
                        content: const Text("Setujui Request?"),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF05050),
                            ),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: () async{
                              response = await Services.approveRequest(request!.id, true);
                              if (mounted) {
                                setState(() {
                                  request!.status = response!.data['status'];
                                });
                                Navigator.of(context).pop();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff009199),
                            ),
                            child: const Text("Setujui"),
                          )
                        ],
                      );
                    },
                  );
                  if(mounted){
                    showDialog(
                      context: context,
                      builder: (context) =>
                          alert(context, "Berhasil", response!.data['message']),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            alert(context, "Error", e.toString()));
                  }
                }
              },
              child: const Text(
                "Setujui",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            width: size.width / 2.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF05050),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                elevation: 5,
              ),
              onPressed: () async{
                try {
                  Response? response;
                  await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Tolak Request?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF05050),
                          ),
                          child: const Text("Batal"),
                        ),
                        ElevatedButton(
                          onPressed: () async{
                            response = await Services.approveRequest(request!.id, false);
                            if (mounted) {
                              setState(() {
                                request!.status = response!.data['status'];
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff009199),
                          ),
                          child: const Text("Tolak"),
                        )
                      ],
                    );
                  },
                  );
                  if(mounted){
                    showDialog(
                      context: context,
                      builder: (context) =>
                          alert(context, "Berhasil", response!.data['message']),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            alert(context, "Error", e.toString()));
                  }
                }
              },
              child: const Text(
                "Tolak",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    } else if (role['asset_purchasing'] == 1 && request!.status == "Approved") {
      return SizedBox(
        width: size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff009199),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 5,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseForm(requestId: request!.id)));
          },
          child: const Text(
            "Ajukan Pembelian",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
