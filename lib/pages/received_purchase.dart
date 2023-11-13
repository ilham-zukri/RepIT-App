import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/data_classes/purchase_item.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../widgets/alert.dart';
import '../widgets/purchase_card.dart';

class ReceivedPurchase extends StatefulWidget {
  const ReceivedPurchase({super.key});

  @override
  State<ReceivedPurchase> createState() => _ReceivedPurchaseState();
}

class _ReceivedPurchaseState extends State<ReceivedPurchase> {
  int page = 1;
  late int lastPage;
  List purchases = [];
  int purchasesLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = 1;
    fetchPurchases();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchPurchases({bool isRefresh = false}) async {
    try {
      var data = await Services.getReceivedPurchases(page);
      if (data != null) {
        List<Purchase> updatedPurchases = List<Purchase>.from(data['data'].map((purchase) {
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
            items: List<PurchaseItem>.from(purchase['items'].map((item) => PurchaseItem(
              id: item['id'],
              assetType: item['asset_type'],
              brand: item['brand'],
              model: item['model'],
              amount: item['amount'],
              priceEa: item['price_ea'],
              priceTotal: item['total_price'],
            ))),
          );
        }));
        setState(() {
          purchases = isRefresh ? updatedPurchases : [...purchases, ...updatedPurchases];
          lastPage = data['meta']['last_page'];
          purchasesLength = purchases.length;
        });
      } else if (isRefresh) {
        setState(() {
          purchases = [];
          lastPage = 1;
          purchasesLength = 0;
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
      appBar: customAppBar(context, "Received Purchases"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: (purchasesLength > 0)
            ? RefreshIndicator(
                onRefresh: () async {
                  page = 1;
                  await fetchPurchases(isRefresh: true);
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount:
                      isLoadingMore ? purchasesLength + 1 : purchasesLength,
                  itemBuilder: (context, index) {
                    if (index < purchasesLength) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          PurchaseCard(purchase: purchases[index]),
                          (index == purchasesLength - 1)
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
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
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
        await fetchPurchases();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
