import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/pages/register_asset.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';
import 'package:repit_app/widgets/purchase_status_box_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseDetail extends StatefulWidget {
  final Purchase purchase;

  const PurchaseDetail({super.key, required this.purchase});

  @override
  State<PurchaseDetail> createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  late Purchase purchase;
  bool isButtonDisabled = false;
  bool isLoading = false;
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
    isButtonDisabled =
        purchase.status == 'Cancelled' || purchase.status == 'Received';
    return Stack(
      children: [
        Scaffold(
          appBar: customDownloadAppBar(context, "Purchase Detail"),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
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
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15))),
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
                  child: Column(
                    children: [
                      Expanded(
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                (purchase.status != 'Received')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF05050),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                elevation: 5,
                              ),
                              onPressed: !isButtonDisabled
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah anda yakin?'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffF05050),
                                                  elevation: 5,
                                                ),
                                                child: const Text("Tidak"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    var response =
                                                        await Services
                                                            .cancelPurchase(
                                                                purchase.id);
                                                    setState(() {
                                                      isLoading = false;
                                                    });

                                                    if (mounted) {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            alert(
                                                                context,
                                                                "Berhasil",
                                                                response!.data[
                                                                    'message']),
                                                      );
                                                      setState(() {
                                                        purchase.status =
                                                            'Cancelled';
                                                      });
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            alert(
                                                          context,
                                                          'Error',
                                                          e.toString(),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff009199),
                                                  elevation: 5,
                                                ),
                                                child: const Text("Ya"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text('Batal'),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff009199),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                elevation: 5,
                              ),
                              onPressed: !isButtonDisabled
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Konfirmasi'),
                                            content: const Text(
                                                'Apakah anda yakin barang yang anda terima sudah sesuai?'),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xffF05050),
                                                  elevation: 5,
                                                ),
                                                child: const Text("Tidak"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    var response =
                                                        await Services
                                                            .receivePurchase(
                                                                purchase.id);
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    if (mounted) {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            alert(
                                                                context,
                                                                "Berhasil",
                                                                response!.data[
                                                                    'message']),
                                                      );
                                                      setState(() {
                                                        purchase.status =
                                                            'Received';
                                                      });
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            alert(
                                                                context,
                                                                'Error',
                                                                e.toString()),
                                                      );
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff009199),
                                                  elevation: 5,
                                                ),
                                                child: const Text("Yakin"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  : null,
                              child: const Text('Terima Barang'),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: size.width,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff009199),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            elevation: 5,
                          ),
                          onPressed: () async {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterAsset(
                                  purchase: purchase,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftarkan Aset",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
        loadingOverlay(isLoading, context),
      ],
    );
  }

  PreferredSizeWidget customDownloadAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(
        title,
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
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () async {
              String docPath = purchase.docPath!;
              // Mencari indeks di mana 'purchase-documents' pertama kali muncul dalam path
              int index = docPath.indexOf('purchase-documents');
              // Mengambil potongan string mulai dari indeks yang ditemukan
              String desiredDocPath = docPath.substring(index);
              String url = '${Services.url}/$desiredDocPath';
              Uri parsedUrl = Uri.parse(url);

              try {
                setState(() {
                  isLoading = true;
                });
                await _launchUrl(parsedUrl);
                setState(() {
                  isLoading = false;
                });
              } catch (e) {
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => alert(context, "Error", e.toString()),
                  );
                }
              }
            },
            icon: const Icon(
              Icons.picture_as_pdf,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
