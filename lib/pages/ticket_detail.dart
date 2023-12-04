import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/ticket.dart';
import 'package:repit_app/pages/spare_part_replacement.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/flag_box_builder.dart';
import 'package:repit_app/widgets/image_viewer.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/ticket_status_box_builder.dart';

import '../widgets/priority_box_builder.dart';

class TicketDetail extends StatefulWidget {
  final Ticket ticket;
  final Map<String, dynamic> role;

  const TicketDetail({super.key, required this.ticket, required this.role});

  @override
  State<TicketDetail> createState() => _TicketDetailState();
}

class _TicketDetailState extends State<TicketDetail> {
  bool isLoading = false;
  late Ticket ticket;
  late Map<String, dynamic> role;
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const EdgeInsets tableContentMarginTop = EdgeInsets.only(top: 8);
  late List images = [];
  TextEditingController resolveNoteEc = TextEditingController();
  TextEditingController handlerNoteEc = TextEditingController();

  @override
  void initState() {
    super.initState();
    ticket = widget.ticket;
    role = widget.role;
    if (ticket.images != null) {
      setState(() {
        images = ticket.images!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: appBarBuilder(context, title: "Ticket Detail"),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ticket.id.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Row(children: [
                          priorityBoxBuilder(ticket.priority!, "detail"),
                          const SizedBox(
                            width: 8,
                          ),
                          ticketStatusBoxBuilder(ticket.status!, "detail")
                        ])
                      ]),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Text(
                          ticket.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      (ticket.status == "In Progress" && role['asset_management'] == 1)
                          ? SizedBox(
                              width: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SparePartReplacement(
                                        assetId: ticket.assetId!,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff009199),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  elevation: 5,
                                ),
                                child: const Text("Ganti Sparepart"),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    ticket.description,
                    textAlign: TextAlign.justify,
                    maxLines: 10,
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
                            'Pemilik Tiket',
                            style: tableContentStyle,
                          ),
                          const Text(':', style: tableContentStyle),
                          Text(ticket.createdBy!, style: tableContentStyle)
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Kategori',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              ticket.category!,
                              style: tableContentStyle,
                            ),
                          )
                        ],
                      ),
                      if(ticket.assetId != null)
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Asset ID',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              (ticket.assetId != null)
                                  ? ticket.assetId.toString()
                                  : '#N/A',
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Lokasi',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              ticket.location!,
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      if(ticket.handler != null)
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Ditangani Oleh',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              (ticket.handler != null)
                                  ? ticket.handler!
                                  : '#N/A',
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Dibuat Pada',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              ticket.createdAt!,
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      if(ticket.respondedAt != null)
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Direspon Pada',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              (ticket.respondedAt != null)
                                  ? ticket.respondedAt!
                                  : '#N/A',
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      if(ticket.resolvedAt != null)
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'Ditutup Pada',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              ':',
                              style: tableContentStyle,
                            ),
                          ),
                          Container(
                            margin: tableContentMarginTop,
                            child: Text(
                              (ticket.resolvedAt != null)
                                  ? ticket.respondedAt!
                                  : '#N/A',
                              style: tableContentStyle,
                            ),
                          ),
                        ],
                      ),
                      if (ticket.note != null)
                        (ticket.note!['resolution_note'] != null)
                            ? TableRow(
                                children: [
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: const Text(
                                      'Note Penyelesaian',
                                      style: tableContentStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: const Text(
                                      ':',
                                      style: tableContentStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: Text(
                                      ticket.note!['resolution_note']
                                          .toString(),
                                      style: tableContentStyle,
                                    ),
                                  ),
                                ],
                              )
                            : TableRow(
                                children: [
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: const Text(
                                      'Note Teknisi',
                                      style: tableContentStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: const Text(
                                      ':',
                                      style: tableContentStyle,
                                    ),
                                  ),
                                  Container(
                                    margin: tableContentMarginTop,
                                    child: Text(
                                      ticket.note!['handler_note'].toString(),
                                      style: tableContentStyle,
                                    ),
                                  ),
                                ],
                              ),
                    ],
                  ),
                  (images.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              const SizedBox(
                                height: 24,
                              ),
                              const Text(
                                'Gambar',
                                style: tableContentStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: images.map((image) {
                                  String url =
                                      '${Services.url}/${image['path']}';
                                  return Row(children: [
                                    IconButton(
                                      iconSize: 50,
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageViewer(imageUrl: url),
                                            ));
                                      },
                                      icon: Image.network(
                                        url,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    (images.indexOf(image) == images.length - 1)
                                        ? const SizedBox.shrink()
                                        : const SizedBox(
                                            width: 8,
                                          )
                                  ]);
                                }).toList(),
                              )
                            ])
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 24,
                  ),
                  if(ticket.status != "Resolved")
                  buttonBuilder(context, ticket.status!),
                ],
              ),
            ),
          ),
          endDrawerEnableOpenDragGesture: true,
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  Widget buttonBuilder(BuildContext context, String status) {
    final Map<String, dynamic> statusMap = {
      "Created": {
        "backgroundColor": const Color(0xffA7E9B5),
        "textColor": const Color(0xff197517),
      },
      "Assigned": {
        "backgroundColor": const Color(0xffB8A7E9),
        "textColor": const Color(0xff58148E),
      },
      "On Hold": {
        "backgroundColor": const Color(0xffE9A7A7),
        "textColor": const Color(0xff852020),
      },
      "In Progress": {
        "backgroundColor": const Color(0xffE9DAA7),
        "textColor": const Color(0xff4E4121),
      },
      "In Review": {
        "backgroundColor": const Color(0xff98BFFA),
        "textColor": const Color(0xff12315F),
      },
      "Resolved": {
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
      case "Created":
        buttonText = "Ambil Tiket";
        action = () async {
          try {
            setState(() {
              isLoading = true;
            });
            var response = await Services.assignTicket(
              ticket.id!,
            );
            setState(() {
              isLoading = false;
              ticket.handler = response!['data']['handler'];
              ticket.status = response['data']['status'];
              ticket.respondedAt = response['data']['responded_at'];
            });
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) =>
                    alert(context, "Berhasil", response!['message']),
              );
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
        };
        break;
      case "Assigned":
        buttonText = "Kerjakan Tiket";
        action = () async {
          try {
            setState(() {
              isLoading = true;
            });
            var response = await Services.workingOnTicket(
              ticket.id!,
            );
            setState(() {
              isLoading = false;
              ticket.status = response!['data']['status'];
            });
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) =>
                    alert(context, "Berhasil", response!['message']),
              );
            }
          } catch (e) {
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
        };
        break;
      case "In Progress":
        buttonText = "Pengerjaan Selesai";
        action = () async {
          showResolveNoteDialog(context);
        };
        break;
      case "In Review":
        buttonText = "Selesaikan";
        action = () async {
          showConfirmationDialog(
            context,
            action: () async {
              try {
                setState(() {
                  isLoading = true;
                });
                var response = await Services.closeTicket(
                  ticket.id!,
                );
                setState(() {
                  ticket.status = response!['data']['status'];
                  isLoading = false;
                });
                if (mounted) {
                  Navigator.pop(context);
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
          );
        };
        break;
      case "On Hold":
        buttonText = "Lanjutkan";
        action = () async {
          try {
            setState(() {
              isLoading = true;
            });
            var response = await Services.workingOnTicket(
              ticket.id!,
            );
            setState(() {
              isLoading = false;
              ticket.status = response!['data']['status'];
            });
            if (mounted) {
              showDialog(
                context: context,
                builder: (context) =>
                    alert(context, "Berhasil", response!['message']),
              );
            }
          } catch (e) {
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
        };
        break;
    }

    if (status != "In Review" && role['asset_management'] != 1) {
      return const SizedBox.shrink();
    }

    if (status == "In Review" && role['asset_management'] == 1) {
      return const SizedBox.shrink();
    }

    if (status == "In Progress") {
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
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF05050),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 5),
              onPressed: () {
                showOnHoldNoteDialog(context);
              },
              child: const Text(
                "Tunda Pengerjaan",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 5),
        onPressed: action,
        child: Text(
          buttonText,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  PreferredSizeWidget appBarBuilder(BuildContext context, {String? title}) {
    return AppBar(
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff00ABB3)),
      ),
      titleSpacing: 0,
      backgroundColor: Colors.white,
      leading: BackButton(
        color: const Color(0xff00ABB3),
        onPressed: Navigator.of(context).pop,
      ),
      actions: [
        if(ticket.flag != null)
        Padding(
          padding: const EdgeInsets.all(10),
          child: flagBoxBuilder(ticket.flag!, 'detail'),
        )
      ],
    );
  }

  void showConfirmationDialog(BuildContext context, {VoidCallback? action}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Konfirmasi"),
            content: const Text("Apakah Anda Yakin?"),
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
                onPressed: action,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff009199),
                ),
                child: const Text("Setujui"),
              ),
            ],
          );
        });
  }

  void showResolveNoteDialog(BuildContext context, {VoidCallback? action}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: const Text("Catatan Penyelesaian"),
              content: Column(
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Catatan*",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    height: 82,
                    child: TextField(
                      maxLines: 5,
                      controller: resolveNoteEc,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
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
                      var response = await Services.toBeReviewTicket(
                          ticket.id!, resolveNoteEc.text);
                      setState(() {
                        ticket.status = response!['data']['status'];
                        isLoading = false;
                      });
                      if (mounted) {
                        resolveNoteEc.clear();
                        Navigator.pop(context);
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
                                ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff009199),
                  ),
                  child: const Text("Selesaikan"),
                ),
              ]);
        });
  }

  void showOnHoldNoteDialog(BuildContext context, {VoidCallback? action}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              scrollable: true,
              title: const Text("Catatan Teknisi"),
              content: Column(
                children: [
                  descriptionTextFieldBuilder(
                      labelText: "Note*", controller: handlerNoteEc)
                ],
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
                      var response = await Services.holdTicket(
                          ticket.id!, handlerNoteEc.text);
                      setState(() {
                        ticket.status = response!['data']['status'];
                        isLoading = false;
                      });
                      if (mounted) {
                        handlerNoteEc.clear();
                        Navigator.pop(context);
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
                                ));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff009199),
                  ),
                  child: const Text("Selesaikan"),
                ),
              ]);
        });
  }
}
