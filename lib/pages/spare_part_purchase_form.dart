import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/custom_text_field_builder.dart';
import 'package:repit_app/widgets/drop_down_builder.dart';
import 'package:repit_app/widgets/loading_overlay.dart';

import '../data_classes/purchase_item.dart';
import '../services.dart';
import '../widgets/alert.dart';
import '../widgets/purchase_item_card.dart';

class SparePartPurchaseForm extends StatefulWidget {
  final int requestId;

  const SparePartPurchaseForm({super.key, required this.requestId});

  @override
  State<SparePartPurchaseForm> createState() => _SparePartPurchaseFormState();
}

class _SparePartPurchaseFormState extends State<SparePartPurchaseForm> {
  TextEditingController vendorEc = TextEditingController();
  TextEditingController descriptionEc = TextEditingController();
  TextEditingController typeEc = TextEditingController();
  TextEditingController brandEc = TextEditingController();
  TextEditingController modelEc = TextEditingController();
  TextEditingController amountEc = TextEditingController();
  TextEditingController priceEaEc = TextEditingController();
  List<Map<String, dynamic>> items = [];
  List<PurchaseItem> purchaseItems = [];
  late Future<List?> types;
  late int typeId;
  bool isLoading = false;

  @override
  void initState() {
    types = fetchSparePartTypes();
    super.initState();
  }

  Future<List?> fetchSparePartTypes() async {
    final data = await Services.getSparePartTypes();
    if (data == null) {
      return [];
    }
    typeId = data.first['id'];
    return data;
  }

  @override
  void dispose() {
    vendorEc.dispose();
    descriptionEc.dispose();
    typeEc.dispose();
    brandEc.dispose();
    modelEc.dispose();
    amountEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: customAppBar(context, "Spare Part Purchase Form", 'add', () {
            showAddItemDialog();
          }),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No. Permintaan: ${widget.requestId}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 16,
                ),
                regularTextFieldBuilder(
                    labelText: "Nama Toko*", controller: vendorEc),
                const SizedBox(
                  height: 8,
                ),
                regularTextFieldBuilder(
                    labelText: "Deskripsi*", controller: descriptionEc),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  thickness: 1,
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
                                          onPressed: () async {
                                            if (vendorEc.text.isEmpty ||
                                                descriptionEc.text.isEmpty) {
                                              showDialog(
                                                context: context,
                                                builder: (context) => alert(
                                                    context,
                                                    "Error",
                                                    "Lengkapi Form"),
                                              );
                                              return;
                                            }
                                            String vendorName =
                                                vendorEc.text.trim();
                                            String description =
                                                descriptionEc.text.trim();
                                            Map<String, dynamic> data = {
                                              "request_id": widget.requestId,
                                              "purchased_from": vendorName,
                                              "description": description,
                                              "items": items
                                            };
                                            try {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Response? response = await Services
                                                  .createSparePartPurchaseForm(
                                                      data);
                                              setState(() {
                                                isLoading = false;
                                              });
                                              if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  backgroundColor:
                                                      const Color(0xff009199),
                                                  content: Text(
                                                      response!.data['message'],
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ));
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
                                                      e.toString()),
                                                );
                                              }
                                            }
                                          },
                                          child: const Text(
                                            "Kirim",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(height: 8),
                              ],
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
        loadingOverlay(isLoading, context)
      ],
    );
  }

  void showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          Size size = MediaQuery.of(context).size;
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              scrollable: true,
              content: Column(
                children: [
                  sparePartTypeDropDownBuilder(
                    context,
                    future: types,
                    label: "Tipe",
                    value: typeId,
                    onChange: (value) {
                      setState(() {
                        typeId = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Brand*",
                    controller: brandEc,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Model*",
                    controller: modelEc,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Jumlah*",
                    controller: amountEc,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  regularTextFieldBuilder(
                    labelText: "Harga satuan*",
                    controller: priceEaEc,
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
                        if (brandEc.text.trim().isEmpty ||
                            modelEc.text.trim().isEmpty ||
                            amountEc.text.trim().isEmpty ||
                            priceEaEc.text.trim().isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                alert(context, "Error", "Lengkapi Field"),
                          );
                          return;
                        }
                        addItems();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Simpan",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                ],
              ));
        });
      },
    );
  }

  Future<void> addItems() async {
    String brand = brandEc.text;
    String model = modelEc.text;
    int amount = int.tryParse(amountEc.text.toString()) as int;
    int priceEa = int.tryParse(priceEaEc.text.toString()) as int;
    int priceTotal = amount * priceEa;

    PurchaseItem purchaseItem = PurchaseItem(
      type: await getTypeById(typeId),
      typeId: typeId,
      brand: brand,
      model: model,
      amount: amount,
      priceEa: priceEa,
      priceTotal: priceTotal,
    );

    Map<String, dynamic> item = purchaseItem.toMapSp();
    items.add(item);
    setState(() {
      purchaseItems.add(purchaseItem);
      clearItemForm();
    });
  }

  Future<String> getTypeById(int id) async {
    late String type;
    List? typeList = await types;
    for (var element in typeList!) {
      if (element['id'] == id) {
        type = element['type'];
      }
    }
    return type;
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
