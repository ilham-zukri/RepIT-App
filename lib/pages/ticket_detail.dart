import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/ticket.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
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
          appBar: customAppBar(context, "Ticket Detail"),
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
                  Text(
                    ticket.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
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
                      TableRow(
                        children: [
                          Container(
                            margin: tableContentMarginTop,
                            child: const Text(
                              'asset ID',
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
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  (images.isNotEmpty)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }
}
