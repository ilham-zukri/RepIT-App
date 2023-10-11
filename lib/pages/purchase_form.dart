import 'package:flutter/material.dart';
import 'package:repit_app/widgets/purchase_item_card.dart';

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
  Map<String, dynamic> items = {};

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
            const SizedBox(
              height: 16,
            ),
            const PurchaseItemCard(),
            const SizedBox(
              height: 35,
            ),
            SizedBox(
              height: 35,
              width: size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff009199),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  elevation: 5,
                ),
                onPressed: () {

                },
                child: const Text(
                  "Kirim",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
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
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
}
