import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/pages/spare_part_purchase_form.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../data_classes/spare_part_request.dart';
import '../widgets/alert.dart';
import '../widgets/req_status_box_builder.dart';

class SparePartRequestDetail extends StatefulWidget {
  final SparePartRequest sparePartRequest;
  final Map<String, dynamic> role;

  const SparePartRequestDetail(
      {super.key, required this.sparePartRequest, required this.role});

  @override
  State<SparePartRequestDetail> createState() => _SparePartRequestDetailState();
}

class _SparePartRequestDetailState extends State<SparePartRequestDetail> {
  late SparePartRequest sparePartRequest;
  late Map<String, dynamic> role;
  bool isLoading = false;
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const EdgeInsets tableContentMargin = EdgeInsets.only(top: 8);
  late EdgeInsets mainPadding;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.all(28) : const EdgeInsets.symmetric(horizontal: 600, vertical: 28);
    super.initState();
    sparePartRequest = widget.sparePartRequest;
    role = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Spare Part Request Detail"),
          body: Padding(
              padding: mainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sparePartRequest.id.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        reqStatusBoxBuilder(sparePartRequest.status, 'detail')
                      ]),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    sparePartRequest.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    sparePartRequest.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Table(columnWidths: const {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(0.2),
                    2: FlexColumnWidth(3)
                  }, children: [
                    TableRow(children: [
                      const Text(
                        'Pemohon',
                        style: tableContentStyle,
                      ),
                      const Text(':', style: tableContentStyle),
                      Text(sparePartRequest.requester)
                    ]),
                    TableRow(
                      children: [
                        Container(
                          margin: tableContentMargin,
                          child: const Text(
                            'Dibuat Pada',
                            style: tableContentStyle,
                          ),
                        ),
                        Container(
                          margin: tableContentMargin,
                          child: const Text(':', style: tableContentStyle),
                        ),
                        Container(
                          margin: tableContentMargin,
                          child: Text(sparePartRequest.createdAt),
                        )
                      ],
                    ),
                    TableRow(
                      children: [
                        Container(
                          margin: tableContentMargin,
                          child: const Text(
                            'Disetujui Pada',
                            style: tableContentStyle,
                          ),
                        ),
                        Container(
                          margin: tableContentMargin,
                          child: const Text(':', style: tableContentStyle),
                        ),
                        Container(
                          margin: tableContentMargin,
                          child: Text(sparePartRequest.approvedAt ?? "#N/A"),
                        )
                      ],
                    ),
                  ]),
                  const SizedBox(
                    height: 32,
                  ),
                  buttonBuilder(
                      status: sparePartRequest.status, context: context),
                ],
              )),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  Widget buttonBuilder(
      {required String status, required BuildContext context}) {
    final Map<String, dynamic> statusMap = {
      "Approved": {
        "backgroundColor": const Color(0xffA7E9B5),
        "textColor": const Color(0xff197517),
      },
      "Requested": {
        "backgroundColor": const Color(0xffB8A7E9),
        "textColor": const Color(0xff58148E),
      },
      "Declined": {
        "backgroundColor": const Color(0xffE9A7A7),
        "textColor": const Color(0xff852020),
      },
      "Preparation": {
        "backgroundColor": const Color(0xffE9DAA7),
        "textColor": const Color(0xff4E4121),
      },
      "Done": {
        "backgroundColor": const Color(0xffA7E9E9),
        "textColor": const Color(0xff2F546E),
      },
    };
    late Color backgroundColor;
    late Color textColor;
    late String buttonText;
    late VoidCallback action;
    if (statusMap.containsKey(status)) {
      backgroundColor = statusMap[status]['backgroundColor'];
      textColor = statusMap[status]['textColor'];
    }

    switch (status) {
      case "Requested":
        buttonText = "Setujui";
        action = () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Konfirmasi"),
                content: const Text(
                  "Apakah anda yakin ingin menyetujui permintaan ini?",
                ),
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
                    onPressed: () async {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        var response = await Services.approveSparePartRequest(sparePartRequest.id, true);
                        setState(() {
                          sparePartRequest.status = response!.data['data']['status'];
                          isLoading = false;
                        });
                        if(mounted){
                          Navigator.of(context).pop();
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => alert(
                              context,
                              "Error",
                              e.toString(),
                            ),
                          );
                        }
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
        };
        break;

      case "Approved":
        buttonText = "Ajukan Pembelian";
        action = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SparePartPurchaseForm(
                requestId: sparePartRequest.id,
              ),
            ),
          );
        };
        break;
    }
    if (status == "Requested" && role['asset_approval'] == 0) {
      return const SizedBox.shrink();
    }
    if (status == "Declined" || status == "Preparation" || status == "Done") {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                elevation: 5),
            onPressed: action,
            child: Text(
              buttonText,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        (status == "Requested")
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffF05050),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      elevation: 5),
                  onPressed: () async{
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi"),
                          content: const Text(
                            "Apakah anda yakin ingin menolak permintaan ini?",
                          ),
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
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  var response = await Services.approveSparePartRequest(sparePartRequest.id, false);
                                  setState(() {
                                    sparePartRequest.status = response!.data['data']['status'];
                                    isLoading = false;
                                  });
                                  if(mounted){
                                    Navigator.of(context).pop();
                                  }
                                } catch (e) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => alert(
                                        context,
                                        "Error",
                                        e.toString(),
                                      ),
                                    );
                                  }
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
                  },
                  child: const Text(
                    "Tolak Permintaan",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
