import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/loading_overlay.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';

import '../data_classes/purchase_item.dart';

class PurchaseForm extends StatefulWidget {
  final int requestId;

  const PurchaseForm({super.key, required this.requestId});

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  TextEditingController vendorNameEc = TextEditingController();
  TextEditingController descriptionEc = TextEditingController();
  TextEditingController typeEc = TextEditingController();
  TextEditingController brandEc = TextEditingController();
  TextEditingController modelEc = TextEditingController();
  TextEditingController amountEc = TextEditingController();
  TextEditingController priceEaEc = TextEditingController();
  List<Map<String, dynamic>> items = [];
  List<PurchaseItem> purchaseItems = [];
  late String assetType;
  late Future<List?> assetTypes;
  bool isLoading = false;
  late EdgeInsets mainPadding;
  bool isEnabled = true;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.all(24) : const EdgeInsets.symmetric(horizontal: 600, vertical: 24);
    super.initState();
    assetTypes = fetchAssetTypes();
  }

  @override
  void dispose() {
    vendorNameEc.dispose();
    descriptionEc.dispose();
    typeEc.dispose();
    brandEc.dispose();
    modelEc.dispose();
    amountEc.dispose();
    super.dispose();
  }

  /// GET asset Types
  Future<List?> fetchAssetTypes() async {
    try {
      final data = await Services.getAssetType();
      if (data == null) {
        return [];
      }
      assetType = data.first['type'];
      return data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarWithAdd(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "No. Permintaan: ${widget.requestId}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  "Nama Toko*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 41,
                  child: TextField(
                    enabled: isEnabled,
                    controller: vendorNameEc,
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
                const Text(
                  "Deskripsi*",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 41,
                  child: TextField(
                    enabled: isEnabled,
                    controller: descriptionEc,
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
                  height: 12,
                ),
                const Divider(
                  color: Colors.black45,
                ),
                (purchaseItems.isNotEmpty)
                    ? Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: purchaseItems.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                PurchaseItemCard(
                                  purchaseItem: purchaseItems[index],
                                  onDelete: () {
                                    deleteItem(index);
                                  },
                                ),
                                (index == purchaseItems.length - 1)
                                    ? Container(
                                        margin: const EdgeInsets.only(
                                            top: 32, bottom: 16),
                                        height: 35,
                                        width: size.width,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff009199),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            elevation: 5,
                                          ),
                                          onPressed: isEnabled ? () async {
                                            if (vendorNameEc.text.isEmpty) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => alert(
                                                    context,
                                                    "Error",
                                                    "Lengkapi Form"),
                                              );
                                            } else {
                                              String vendorName =
                                                  vendorNameEc.text.trim();
                                              String description = descriptionEc.text.trim();
                                              try {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                Response? response =
                                                    await Services
                                                        .createPurchasingForm(
                                                            widget.requestId,
                                                            vendorName,
                                                            description,
                                                            items);
                                                setState(() {
                                                  isLoading = false;
                                                  isEnabled = false;
                                                });
                                                if (mounted) {
                                                  setState(() {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          alert(
                                                              context,
                                                              "Berhasil",
                                                              response!.data[
                                                                  'message']),
                                                    );
                                                  });
                                                }
                                              } catch (e) {
                                                if (mounted) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) => alert(
                                                        context,
                                                        "Error",
                                                        e.toString()),
                                                  );
                                                }
                                              }
                                            }
                                          } : null,
                                          child: const Text(
                                            "Kirim",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ) : const SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          loadingOverlay(isLoading, context),
        ],
      ),
    );
  }

  /// Custom Appbar
  PreferredSizeWidget appBarWithAdd() {
    return AppBar(
      title: const Text(
        "Purchasing Form",
        style: TextStyle(
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
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      Size size = MediaQuery.of(context).size;
                      return AlertDialog(
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        scrollable: true,
                        content: Column(
                          children: [
                            /// Field Tipe Aset
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Tipe Aset",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: FutureBuilder(
                                  future: assetTypes,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      List<dynamic>? types = snapshot.data;
                                      String? initialTypeSelection;
                                      if (types != null && types.isNotEmpty) {
                                        initialTypeSelection =
                                            types.first['type'];
                                      }
                                      return DropdownMenu(
                                        textStyle:
                                            const TextStyle(fontSize: 16),
                                        width: size.width - 130,
                                        enableSearch: true,
                                        initialSelection: initialTypeSelection,
                                        onSelected: (value) {
                                          setState(() {
                                            assetType = value;
                                          });
                                        },
                                        dropdownMenuEntries: types!.map((type) {
                                          return DropdownMenuEntry(
                                              value: type['type'],
                                              label: type['type']);
                                        }).toList(),
                                      );
                                    }
                                  }),
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            /// Field Merek
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Merek",
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
                                controller: brandEc,
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

                            /// Field Model
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Model",
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
                                controller: modelEc,
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

                            /// Field Jumlah Item
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Jumlah Item",
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
                                controller: amountEc,
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

                            /// Field Harga Satuan
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Harga Satuan",
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
                                controller: priceEaEc,
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
                                onPressed: () {
                                  if (brandEc.text.isEmpty ||
                                      modelEc.text.isEmpty ||
                                      amountEc.text.isEmpty ||
                                      priceEaEc.text.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => alert(
                                          context, "Error", "Lengkapi Field"),
                                    );
                                  } else {
                                    addItems();
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text(
                                  "Simpan",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.add,
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

  /// Adding Items
  void addItems() {
    String brand = brandEc.text;
    String model = modelEc.text;
    int amount = int.tryParse(amountEc.text.toString()) as int;
    int priceEa = int.tryParse(priceEaEc.text.toString()) as int;
    int priceTotal = amount * priceEa;

    PurchaseItem purchaseItem = PurchaseItem(
      type: assetType,
      brand: brand,
      model: model,
      amount: amount,
      priceEa: priceEa,
      priceTotal: priceTotal,
    );

    Map<String, dynamic> item = purchaseItem.toMap();
    items.add(item);

    setState(() {
      purchaseItems.add(purchaseItem);
      clearItemForm();
    });
  }

  /// Deleting Item From Maps
  void deleteItem(int index) {
    setState(() {
      purchaseItems.removeAt(index);
      items.removeAt(index);
    });
  }

  /// Clearing Form Texts
  void clearItemForm() {
    typeEc.clear();
    brandEc.clear();
    modelEc.clear();
    amountEc.clear();
    priceEaEc.clear();
  }
}
