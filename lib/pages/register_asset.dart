import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';

import '../data_classes/asset.dart';
import '../data_classes/purchase_item.dart';

class RegisterAsset extends StatefulWidget {
  final Purchase purchase;

  const RegisterAsset({super.key, required this.purchase});

  @override
  State<RegisterAsset> createState() => _RegisterAssetState();
}

class _RegisterAssetState extends State<RegisterAsset> {
  late final Purchase purchase;
  late List<PurchaseItem> purchaseItems;
  List<Map<String, dynamic>> items = [];
  List<Asset> assets = [];
  TextEditingController serialNumberEc = TextEditingController();
  TextEditingController cpuEc = TextEditingController();
  TextEditingController ramEc = TextEditingController();
  TextEditingController utilizationEc = TextEditingController();
  static const TextStyle tableContentStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const EdgeInsets tableContentMargin = EdgeInsets.only(top: 4);
  bool isLoading = false;
  bool isButtonDisabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    purchase = widget.purchase;
    purchaseItems = purchase.items;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
            context,
            "Register Asset",
            "purchaseItems",
            () {
              showPurchaseItemDialog(context);
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "No. Pembelian: ${purchase.id}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: size.height / 1.4,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black26),
                        bottom: BorderSide(color: Colors.black26),
                      ),
                    ),
                    child: Column(
                      children: [
                        (assets.isNotEmpty)
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: assets.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        AssetCard(
                                          asset: assets[index],
                                          withDetail: false,
                                        ),
                                        (index < purchase.items.length - 1)
                                            ? const SizedBox.shrink()
                                            : const SizedBox(
                                                height: 8,
                                              ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff009199),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        elevation: 5,
                      ),
                      onPressed: (!isButtonDisabled) ? () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          Response? response =
                              await Services.registerAssetFromPurchase(
                                  items: items, purchaseId: purchase.id);
                          setState(() {
                            isLoading = false;
                            isButtonDisabled = true;
                          });
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => alert(
                                context,
                                "Berhasil",
                                response!.data['message'],
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  alert(context, "Error", e.toString()),
                            );
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      } : null,
                      child: const Text('Daftarkan Asset'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  void showPurchaseItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        if (purchaseItems.isEmpty) {
          return alert(
              context, "Sudah Ditambahkan", "Semua Item sudah ditambahkan");
        }
        return SimpleDialog(
          title: const Text("Purchasing Items"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: purchaseItems.map((item) {
                    return Column(
                      children: [
                        PurchaseItemCard(
                          purchaseItem: item,
                          onAdd: () {
                            showAddItemDialog(context, item);
                          },
                        ),
                        const SizedBox(height: 6),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void showAddItemDialog(BuildContext context, PurchaseItem item) {
    Size size = MediaQuery.of(context).size;
    String assetType = item.assetType;
    String brand = item.brand;
    String model = item.model;
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Data Asset"),
          titlePadding: const EdgeInsets.all(12),
          contentPadding: const EdgeInsets.all(12),
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1.7),
                1: FlexColumnWidth(0.2),
                2: FlexColumnWidth(3)
              },
              children: [
                TableRow(children: [
                  const Text(
                    "Asset Type",
                    style: tableContentStyle,
                  ),
                  const Text(
                    ":",
                    style: tableContentStyle,
                  ),
                  Text(assetType),
                ]),
                TableRow(
                  children: [
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        "Brand",
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                      margin: tableContentMargin,
                      child: const Text(
                        ":",
                        style: tableContentStyle,
                      ),
                    ),
                    Container(
                      margin: tableContentMargin,
                      child: Text(brand),
                    ),
                  ],
                ),
                TableRow(children: [
                  Container(
                    margin: tableContentMargin,
                    child: const Text(
                      "Model",
                      style: tableContentStyle,
                    ),
                  ),
                  Container(
                    margin: tableContentMargin,
                    child: const Text(
                      ":",
                      style: tableContentStyle,
                    ),
                  ),
                  Container(
                    margin: tableContentMargin,
                    child: Text(model),
                  ),
                ]),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Serial Number*",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 41,
              child: TextField(
                controller: serialNumberEc,
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
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "CPU",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 41,
              child: TextField(
                controller: cpuEc,
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
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "RAM",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 41,
              child: TextField(
                controller: ramEc,
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
            const SizedBox(
              height: 8,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Utilization*",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 41,
              child: TextField(
                controller: utilizationEc,
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
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff009199),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 5,
                ),
                onPressed: () {
                  if (serialNumberEc.text.isEmpty ||
                      utilizationEc.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => alert(context, "Lengkapi Field",
                          "Field Serial Number dan Utilization Wajib diisi"),
                    );
                    return;
                  }
                  Asset asset = Asset(
                    null,
                    utilizationEc.text,
                    null,
                    assetType,
                    ramEc.text,
                    cpuEc.text,
                    null,
                    serialNumberEc.text,
                    brand,
                    model,
                    null,
                  );
                  setState(() {
                    addAsset(asset);
                  });
                  Navigator.pop(context);
                },
                child: const Text('Tambahkan'),
              ),
            ),
          ],
        );
      },
    );
  }

  void addAsset(Asset asset) {
    assets.add(asset);
    items.add(asset.toMap());
    // Ambil index PurchaseItem yang sesuai dengan asset yang ditambahkan
    int index = purchaseItems.indexWhere((item) =>
        item.assetType == asset.assetType &&
        item.brand == asset.brand &&
        item.model == asset.model);

    if (index != -1) {
      // Kurangi jumlah item yang dibeli (amount) sesuai dengan item yang ditambahkan
      purchaseItems[index].amount--;

      // Jika jumlah item yang dibeli mencapai 0 atau kurang, hapus dari daftar pembelian
      if (purchaseItems[index].amount <= 0) {
        purchaseItems.removeAt(index);
      }
    }
    clearFields();

    print(items);
  }

  void clearFields() {
    serialNumberEc.clear();
    cpuEc.clear();
    ramEc.clear();
    utilizationEc.clear();
  }
}
