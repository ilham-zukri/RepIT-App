import 'package:flutter/material.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';

import '../data_classes/purchase_item.dart';

class PurchaseForm extends StatefulWidget {
  final int purchaseId;

  const PurchaseForm({super.key, required this.purchaseId});

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  TextEditingController vendorNameEc = TextEditingController();
  TextEditingController typeEc = TextEditingController();
  TextEditingController brandEc = TextEditingController();
  TextEditingController modelEc = TextEditingController();
  TextEditingController amountEc = TextEditingController();
  TextEditingController priceEaEc = TextEditingController();
  List<Map<String, dynamic>> items = [];
  List<PurchaseItem> purchaseItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: appBarWithAdd(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "No. Permintaan: ${widget.purchaseId}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Nama Toko*",
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
              height: 12,
            ),
            const Divider(
              color: Colors.black45,
            ),
            (purchaseItems.isNotEmpty)
                ? Expanded(
                    // flex: 1,
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
                            ),
                            (index == purchaseItems.length - 1)
                                ? Container(
                                    margin: const EdgeInsets.only(top: 32, bottom: 16),
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
                                      onPressed: () {},
                                      child: const Text(
                                        "Kirim",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                : const SizedBox(height: 8)
                          ],
                        );
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

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
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              height: 41,
                              child: TextField(
                                controller: typeEc,
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
                                  addItems();
                                  Navigator.of(context).pop();
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

  void addItems() {
    String assetType = typeEc.text;
    String brand = brandEc.text;
    String model = modelEc.text;
    int amount = int.tryParse(amountEc.text.toString()) as int;
    int priceEa = int.tryParse(priceEaEc.text.toString()) as int;
    int priceTotal = amount * priceEa;

    PurchaseItem purchaseItem = PurchaseItem(
      assetType: assetType,
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

  void clearItemForm() {
    typeEc.clear();
    brandEc.clear();
    modelEc.clear();
    amountEc.clear();
    priceEaEc.clear();
  }
}
