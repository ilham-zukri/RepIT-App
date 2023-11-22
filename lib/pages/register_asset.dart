import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/data_classes/spare_part.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';
import 'package:repit_app/widgets/spare_part_card.dart';

import '../data_classes/asset.dart';
import '../data_classes/purchase_item.dart';

class RegisterAsset extends StatefulWidget {
  final Purchase purchase;
  final String usage;

  const RegisterAsset({super.key, required this.purchase, required this.usage});

  @override
  State<RegisterAsset> createState() => _RegisterAssetState();
}

class _RegisterAssetState extends State<RegisterAsset> {
  late final Purchase purchase;
  late String usage;
  late String appbarTittle;
  late List<PurchaseItem> purchaseItems;
  List<Map<String, dynamic>> items = [];
  List<Asset> assets = [];
  List<SparePart> spareParts = [];
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
    usage = widget.usage;
    appbarTittle =
        (usage == 'asset') ? 'Register Asset' : 'Register Spare Part';
    super.initState();
    purchase = widget.purchase;
    purchaseItems = purchase.items;
  }

  @override
  void dispose() {
    serialNumberEc.dispose();
    cpuEc.dispose();
    ramEc.dispose();
    utilizationEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(
            context,
            appbarTittle,
            "purchaseItems",
            () {
              showPurchaseItemDialog(context);
            },
          ),
          body: assetForm(context),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  Widget assetForm(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "No. Pembelian: ${purchase.id}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  if (assets.isNotEmpty)
                    Expanded(
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
                              (index < assets.length - 1)
                                  ? const SizedBox.shrink()
                                  : const SizedBox(
                                      height: 8,
                                    ),
                            ],
                          );
                        },
                      ),
                    ),
                  if (spareParts.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: spareParts.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(
                                height: 8,
                              ),
                              SparePartCard(
                                sparePart: spareParts[index],
                                withDetail: false,
                              ),
                              (index < spareParts.length - 1)
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
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff009199),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 5,
                ),
                onPressed: (!isButtonDisabled)
                    ? () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          Response? response;
                          if (usage == 'asset') {
                            response = await Services.registerAssetFromPurchase(
                                items: items, purchaseId: purchase.id);
                          } else {
                            response = await Services.registerSparePartFromPurchase(
                                items: items, purchaseId: purchase.id);
                          }
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
                      }
                    : null,
                child: (usage == 'asset')
                    ? const Text('Daftarkan Asset')
                    : const Text('Daftarkan Spare Part'),
              ),
            ),
          ],
        ),
      ),
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
              // height: MediaQuery.of(context).size.height * 0.6,
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
    String type = item.type;
    String brand = item.brand;
    String model = item.model;
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: (usage == 'asset')
              ? const Text("Data Asset")
              : const Text("Data Spare Part"),
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
                  Text(type),
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
            regularTextFieldBuilder(
                labelText: "Serial Number*", controller: serialNumberEc, obscureText: false),
            const SizedBox(
              height: 8,
            ),
            if (usage == "asset")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  regularTextFieldBuilder(labelText: "CPU", controller: cpuEc, obscureText: false),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(labelText: "RAM", controller: ramEc, obscureText: false),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(
                      labelText: "Utilization", controller: utilizationEc,obscureText: false),
                ],
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
                  if(usage == "asset"){
                    if (serialNumberEc.text.trim().isEmpty ||
                        utilizationEc.text.trim().isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => alert(context, "Lengkapi Field",
                            "Field Serial Number dan Utilization Wajib diisi"),
                      );
                      return;
                    }
                    Asset asset = Asset(
                        null,
                        utilizationEc.text.trim(),
                        null,
                        type,
                        ramEc.text.trim(),
                        cpuEc.text.trim(),
                        null,
                        serialNumberEc.text.trim(),
                        brand,
                        model,
                        null,
                        null);
                    setState(() {
                      addAsset(asset);
                    });
                    Navigator.pop(context);
                    return;
                  }
                  if(serialNumberEc.text.trim().isEmpty){
                    showDialog(
                      context: context,
                      builder: (context) => alert(context, "Lengkapi Field",
                          "Field Serial Number Wajib diisi"),
                    );
                    return;
                  }
                  SparePart sparePart = SparePart(
                    brand: brand,
                    model: model,
                    type: type,
                    serialNumber: serialNumberEc.text.trim(),
                  );
                  setState(() {
                    addSparePart(sparePart);
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
        item.type == asset.assetType &&
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
  }

  void addSparePart(SparePart sparePart) {
    spareParts.add(sparePart);
    items.add(sparePart.toMap());
    // Ambil index PurchaseItem yang sesuai dengan spare part yang ditambahkan
    int index = purchaseItems.indexWhere((item) =>
        item.type == sparePart.type &&
        item.brand == sparePart.brand &&
        item.model == sparePart.model);

    if (index != -1) {
      // Kurangi item yang dibeli (amount) sesuai dengan item yang ditambahkan
      purchaseItems[index].amount--;
    }

    // Jika item yang dibeli mencapai 0 atau kurang, hapus dari daftar pembelian
    if (purchaseItems[index].amount <= 0) {
      purchaseItems.removeAt(index);
    }
    clearFields();
  }

  void clearFields() {
    setState(() {
      serialNumberEc.clear();
      cpuEc.clear();
      ramEc.clear();
      utilizationEc.clear();
    });
  }
}
