import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import '../data_classes/purchase.dart';
import '../data_classes/purchase_item.dart';
import '../services.dart';
import '../widgets/alert.dart';
import '../widgets/purchase_card.dart';

class SparePartReceivedPurchase extends StatefulWidget {
  const SparePartReceivedPurchase({super.key});

  @override
  State<SparePartReceivedPurchase> createState() =>
      _SparePartReceivedPurchaseState();
}

class _SparePartReceivedPurchaseState extends State<SparePartReceivedPurchase> {
  int page = 1;
  late int lastPage;
  List sparePartPurchases = [];
  int sparePartPurchasesLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  late EdgeInsets mainPadding;
  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    scrollController.addListener(_scrollListener);
    fetchSparePartPurchases();
    super.initState();
  }

  Future<void> fetchSparePartPurchases({bool isRefresh = false}) async {
    try {
      var data = await Services.getReceivedSparePartPurchases(page);
      if (data != null) {
        List<Purchase> updatedPurchases =
            List<Purchase>.from(data['data'].map((purchase) {
          return Purchase(
            requestId: purchase["request_id"],
            purchasedBy: purchase['purchased_by'],
            requester: purchase['requester'],
            createdAt: purchase['created_at'],
            status: purchase['status'],
            totalPrice: purchase['total_price'],
            id: purchase['id'],
            vendorName: purchase['purchased_from'],
            docPath: purchase['doc_path'],
            imageUrl: purchase['pic_path'],
            items: List<PurchaseItem>.from(
                purchase['items'].map((item) => PurchaseItem(
                      id: item['id'],
                      type: item['type'],
                      brand: item['brand'],
                      model: item['model'],
                      amount: item['amount'],
                      priceEa: item['price_ea'],
                      priceTotal: item['total_price'],
                    ))),
          );
        }));
        setState(() {
          sparePartPurchases = isRefresh
              ? updatedPurchases
              : [...sparePartPurchases, ...updatedPurchases];
          lastPage = data['meta']['last_page'];
          sparePartPurchasesLength = sparePartPurchases.length;
        });
      } else if (isRefresh) {
        setState(() {
          sparePartPurchases = [];
          lastPage = 1;
          sparePartPurchasesLength = 0;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => alert(context, "error", e.toString()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Spare Part Received Purchase"),
      body: sparePartReceivedPurchaseListView(),
    );
  }

  Widget sparePartReceivedPurchaseListView() {
    if (sparePartPurchasesLength > 0) {
      return Padding(
        padding: mainPadding,
        child: RefreshIndicator(
            onRefresh: () async {
              page = 1;
              await fetchSparePartPurchases(isRefresh: true);
            },
            child: ListView.builder(
              controller: scrollController,
              itemCount: sparePartPurchasesLength + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < sparePartPurchasesLength) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      PurchaseCard(
                        purchase: sparePartPurchases[index],
                        usage: "spare_part",
                      ),
                      (index == sparePartPurchasesLength - 1)
                          ? const SizedBox(height: 16)
                          : const SizedBox.shrink()
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
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
        // await fetchPurchases();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
