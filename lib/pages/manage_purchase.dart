import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/data_classes/purchase_item.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/purchase_card.dart';

class ManagePurchase extends StatefulWidget {
  const ManagePurchase({super.key});

  @override
  State<ManagePurchase> createState() => _ManagePurchaseState();
}

class _ManagePurchaseState extends State<ManagePurchase>
    with TickerProviderStateMixin {
  late int page;
  late int lastPage;
  List purchases = [];
  int purchasesLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  late TabController _tabController;
  int _tabIndex = 0;
  List sparePartPurchases = [];
  int sparePartPurchasesLength = 0;
  late EdgeInsets mainPadding;
  TextEditingController searchControllerAsset = TextEditingController();
  String? searchParamAsset;
  TextEditingController searchControllerSparePart = TextEditingController();
  String? searchParamSparePart;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    page = 1;
    fetchPurchases();
    scrollController.addListener(_scrollListener);
    _tabController.addListener(_tabChangesListener);
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchPurchases({bool isRefresh = false}) async {
    try {
      var data = await Services.getPurchases(page, searchParamAsset);
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
                      type: item['asset_type'],
                      brand: item['brand'],
                      model: item['model'],
                      amount: item['amount'],
                      priceEa: item['price_ea'],
                      priceTotal: item['total_price'],
                    ))),
          );
        }));
        setState(() {
          purchases = isRefresh
              ? updatedPurchases
              : [...purchases, ...updatedPurchases];
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

  Future<void> fetchSparePartPurchases({bool isRefresh = false}) async {
    try {
      var data = await Services.getSparePartPurchases(page, searchParamSparePart);
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
      appBar: appBarWithSort(context, "Purchasing"),
      body: TabBarView(
        controller: _tabController,
        children: [
          assetPurchaseListView(),
          sparePartPurchaseListView(),
        ],
      ),
    );
  }

  PreferredSizeWidget appBarWithSort(BuildContext context, String title) {
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
            onPressed: () async{
              if(_tabController.index == 0){
                setState(() {
                  page = 1;
                  purchasesLength = 0;
                  purchases = [];
                });
                await fetchPurchases(isRefresh: true);
              } else {
                setState(() {
                  page = 1;
                  sparePartPurchasesLength = 0;
                  sparePartPurchases = [];
                });
                await fetchSparePartPurchases(isRefresh: true);
              }
            },
            icon: const Icon(
              Icons.refresh,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            text: "Asset",
          ),
          Tab(
            text: "Spare Part",
          )
        ],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        labelColor: const Color(0xff007980),
        indicatorColor: const Color(0xff007980),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget assetPurchaseListView() {
    return Stack(
      children: [
        Padding(
          padding: mainPadding,
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
                            if (index == 0)
                              const SizedBox(
                                height: 68,
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            PurchaseCard(
                              purchase: purchases[index],
                              usage: "asset",
                            ),
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
        Padding(
          padding: mainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 16,
              ),
              SearchBar(
                elevation: const MaterialStatePropertyAll<double>(4.0),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                controller: searchControllerAsset,
                onChanged: (value) async {
                  setState(() {
                    page = 1;
                    searchParamAsset = value;
                  });
                  await fetchPurchases(isRefresh: true);
                },
                leading: const Icon(Icons.search),
                hintText: "Cari nomor Pembelian dan Nama Vendor",
                hintStyle: const MaterialStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.black54),
                ),
                trailing: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () async {
                      setState(() {
                        page = 1;
                        searchControllerAsset.clear();
                        searchParamAsset = null;
                      });
                      await fetchPurchases(isRefresh: true);
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget sparePartPurchaseListView() {
    return Stack(
      children: [
        Padding(
          padding: mainPadding,
          child: (sparePartPurchasesLength > 0)
              ? RefreshIndicator(
                  onRefresh: () async {
                    page = 1;
                    await fetchSparePartPurchases(isRefresh: true);
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: isLoadingMore
                        ? sparePartPurchasesLength + 1
                        : sparePartPurchasesLength,
                    itemBuilder: (context, index) {
                      if (index < sparePartPurchasesLength) {
                        return Column(
                          children: [
                            if (index == 0)
                              const SizedBox(
                                height: 68,
                              ),
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
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Padding(
          padding: mainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 16,
              ),
              SearchBar(
                elevation: const MaterialStatePropertyAll<double>(4.0),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                controller: searchControllerSparePart,
                onChanged: (value) async {
                  setState(() {
                    page = 1;
                    searchParamSparePart = value;
                  });
                  await fetchSparePartPurchases(isRefresh: true);
                },
                leading: const Icon(Icons.search),
                hintText: "Cari nomor Pembelian dan Nama Vendor",
                hintStyle: const MaterialStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.black54),
                ),
                trailing: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () async {
                      setState(() {
                        page = 1;
                        searchControllerSparePart.clear();
                        searchParamSparePart = null;
                      });
                      await fetchSparePartPurchases(isRefresh: true);
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
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

  Future<void> _tabChangesListener() async {
    int newIndex = _tabController.index;
    if (_tabIndex != newIndex) {
      setState(() {
        page = 1;
        _tabIndex = newIndex;
      });
      if (_tabIndex == 0) {
        await fetchPurchases(isRefresh: true);
      } else {
        await fetchSparePartPurchases(isRefresh: true);
      }
    }
  }
}
