import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/pages/purchase_asset.dart';
import 'package:repit_app/pages/register_asset.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/image_viewer.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';
import 'package:repit_app/widgets/purchase_status_box_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseDetail extends StatefulWidget {
  final Purchase purchase;
  final String usage;

  const PurchaseDetail(
      {super.key, required this.purchase, required this.usage});

  @override
  State<PurchaseDetail> createState() => _PurchaseDetailState();
}

class _PurchaseDetailState extends State<PurchaseDetail> {
  late Purchase purchase;
  late String usage;
  late String appbarTittle;
  bool isButtonDisabled = false;
  bool isLoading = false;
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  late EdgeInsets mainPadding;
  File? image;
  String? imageUrl;

  @override
  void initState() {
    mainPadding = !kIsWeb
        ? const EdgeInsets.all(28)
        : const EdgeInsets.symmetric(horizontal: 640, vertical: 28);
    super.initState();
    usage = widget.usage;
    purchase = widget.purchase;
    imageUrl = purchase.imageUrl;
    if (usage == 'asset') {
      appbarTittle = 'Purchase Detail';
    } else {
      appbarTittle = 'Spare Part Purchase Detail';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    isButtonDisabled =
        purchase.status == 'Cancelled' || purchase.status == 'Received';
    return Stack(
      children: [
        Scaffold(
          appBar: customDownloadAppBar(context, appbarTittle),
          body: Padding(
            padding: mainPadding,
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
                          child: const Text(
                            ':',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                        ),
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
                  height: 4,
                ),
                if (imageUrl != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Gambar :"),
                      const SizedBox(
                        height: 4,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageViewer(imageUrl: '${Services.url}/${imageUrl!}'),
                            ),
                          );
                        },
                        icon: Image.network(
                        '${Services.url}/${imageUrl!}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height:
                      imageUrl == null ? size.height / 1.8 : size.height / 2.2,
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
                (purchase.status == 'In Progress')
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
                                                  late Response? response;
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    if (usage == 'asset') {
                                                      response = await Services
                                                          .cancelPurchase(
                                                              purchase.id);
                                                    } else {
                                                      response = await Services
                                                          .cancelSparePartPurchase(
                                                              purchase.id);
                                                    }

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
                                                'Apakah anda yakin barang yang anda terima sudah sesuai?',
                                                textAlign: TextAlign.justify),
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
                                                  late Response? response;
                                                  try {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    if (usage == "asset") {
                                                      response = await Services
                                                          .receivePurchase(
                                                              purchase.id);
                                                    } else {
                                                      response = await Services
                                                          .receiveSparePartPurchase(
                                                              purchase.id);
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    if (mounted) {
                                                      Navigator.pop(context);
                                                      showTakePicDialog();
                                                      setState(() {
                                                        purchase.status =
                                                            'Received';
                                                      });
                                                    }
                                                  } catch (e) {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
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
                    : const SizedBox.shrink(),
                if (purchase.status == 'Received')
                  SizedBox(
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
                              usage: usage,
                            ),
                          ),
                        );
                      },
                      child: (usage == "asset")
                          ? const Text(
                              "Daftarkan Aset",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          : const Text(
                              "Daftarkan Spare Part",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                if (purchase.status == 'Done')
                  SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff009199),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                PurchaseAsset(purchaseId: purchase.id),
                          ),
                        );
                      },
                      child: const Text("Lihat aset yang berhubungan"),
                    ),
                  ),
              ],
            ),
          ),
        ),
        loadingOverlay(isLoading, context),
      ],
    );
  }

  void showTakePicDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text("Ambil Gambar?"),
            content: const Text(
                "Apakah anda ingin mengambil gambar untuk penerimaan pembelian ini?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF05050),
                ),
                child: const Text("Tidak"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _pickImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff009199),
                ),
                child: const Text("Ya"),
              ),
            ]);
      },
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        isLoading = true;
      });
      image = File(pickedImage.path);
      try {
        var response = await Services.uploadReceivedPurchasePict(
          purchase.id,
          image!,
          usage
        );
        if (mounted) {
          setState(() {
            isLoading = false;
            imageUrl = response!['url'];
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xff00ABB3),
              content: Text(
                e.toString(),
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }
}
