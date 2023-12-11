import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/spare_part.dart';
import 'package:repit_app/pages/register_spare_part_old.dart';
import 'package:repit_app/pages/spare_part_received_purchase.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/spare_part_card.dart';

import '../services.dart';

class ManageSparePart extends StatefulWidget {
  const ManageSparePart({super.key});

  @override
  State<ManageSparePart> createState() => _ManageSparePartState();
}

class _ManageSparePartState extends State<ManageSparePart> {
  int page = 1;
  late int lastPage;
  List spareParts = [];
  int sparePartsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  late EdgeInsets mainPadding;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    scrollController.addListener(_scrollListener);
    fetchSpareParts();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchSpareParts({bool isRefresh = false}) async {
    var data = await Services.getAllSpareParts(page: page);
    if (data == null) {
      spareParts += [];
    } else {
      List<SparePart> fetchedSpareParts =
          data['data'].map<SparePart>((sparePart) {
        return SparePart(
          id: sparePart['id'],
          type: sparePart['type'],
          purchaseId: sparePart['purchase_id'],
          brand: sparePart['brand'],
          model: sparePart['model'],
          qrPath: sparePart['qr_path'],
          serialNumber: sparePart['serial_number'],
          status: sparePart['status'],
          assetId: sparePart['device_id'],
          createdAt: sparePart['created_at'],
        );
      }).toList();
      if (isRefresh) {
        spareParts = fetchedSpareParts;
      } else {
        spareParts += fetchedSpareParts;
      }
      setState(() {
        spareParts;
        sparePartsLength = spareParts.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Manage Spare Part", 'add', () {
        addAssetsDialog(context);
      }),
      body: sparePartListView(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: const Icon(Icons.filter_alt),
      ),
    );
  }

  Widget sparePartListView(BuildContext context) {
    if (sparePartsLength > 0) {
      return Padding(
        padding: mainPadding,
        child: RefreshIndicator(
          onRefresh: () async {
            page = 1;
            await fetchSpareParts(isRefresh: true);
          },
          child: ListView.builder(
            controller: scrollController,
            itemCount: sparePartsLength + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < sparePartsLength) {
                return Column(children: [
                  const SizedBox(
                    height: 16,
                  ),
                  SparePartCard(
                    sparePart: spareParts[index],
                    withDetail: true,
                  ),
                  (index == sparePartsLength - 1)
                      ? const SizedBox(height: 16)
                      : const SizedBox.shrink(),
                ]);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void addAssetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tambahkan Spare Part",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SparePartReceivedPurchase(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Text("Dari Pembelian"),
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterSparePartOld(),
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Text("Spare part lama"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page < lastPage) {
        setState(() {
          isLoadingMore = true;
        });
        page++;
        await fetchSpareParts();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
