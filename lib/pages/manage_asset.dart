import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/pages/received_purchase.dart';
import 'package:repit_app/pages/register_asset_old.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../data_classes/asset.dart';

class ManageAsset extends StatefulWidget {
  const ManageAsset({super.key});

  @override
  State<ManageAsset> createState() => _ManageAssetState();
}

class _ManageAssetState extends State<ManageAsset> {
  int page = 1;
  late int lastPage;
  String? searchParam;
  List assets = [];
  int assetsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  final TextEditingController searchController = TextEditingController();
  late EdgeInsets mainPadding;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    super.initState();
    fetchAssets();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchAssets({bool? isRefresh}) async {
    var data = await Services.getAllAssets(page, searchParam);
    if (data == null) {
      assets += [];
    } else if (isRefresh == true) {
      assets = data['data'].map(
        (asset) {
          return Asset(
              asset['id'],
              asset['name'],
              asset['utilization'],
              asset['status'],
              asset['asset_type'],
              asset['ram'],
              asset['cpu'],
              asset['location'],
              asset['serial_number'],
              asset['brand'],
              asset['model'],
              asset['qr_path'],
              asset['owner']);
        },
      ).toList();
      setState(() {
        assets;
        assetsLength = assets.length;
        lastPage = data['meta']['last_page'];
      });
    } else {
      assets += data['data'].map(
        (asset) {
          return Asset(
              asset['id'],
              asset['name'],
              asset['utilization'],
              asset['status'],
              asset['asset_type'],
              asset['ram'],
              asset['cpu'],
              asset['location'],
              asset['serial_number'],
              asset['brand'],
              asset['model'],
              asset['qr_path'],
              asset['owner']);
        },
      ).toList();
      setState(() {
        assets;
        assetsLength = assets.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Manage Assets",
        'add',
        () {
          addAssetsDialog(context);
        },
        'refresh',
        () {
          setState(() {
            assets = [];
            assetsLength = 0;
            page = 1;
            fetchAssets(isRefresh: true);
          });
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: mainPadding,
            child: (assetsLength > 0)
                ? RefreshIndicator(
                    onRefresh: () async {
                      page = 1;
                      await fetchAssets(isRefresh: true);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: isLoadingMore ? assetsLength + 1 : assetsLength,
                      itemBuilder: (context, index) {
                        if (index < assetsLength) {
                          return Column(
                            children: [
                              if (index == 0)
                                const SizedBox(
                                  height: 68,
                                ),
                              const SizedBox(
                                height: 16,
                              ),
                              AssetCard(
                                asset: assets[index],
                                withDetail: true,
                                withAdvancedMenu: true,
                              ),
                              (index == assetsLength - 1)
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
                  controller: searchController,
                  onChanged: (value) async {
                    setState(() {
                      searchParam = value;
                    });
                    await fetchAssets(isRefresh: true);
                  },
                  leading: const Icon(Icons.search),
                  hintText: "Cari nama asset atau ID asset",
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(
                    TextStyle(color: Colors.black54),
                  ),
                  trailing: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async {
                        setState(() {
                          searchController.clear();
                          searchParam = null;
                        });
                        await fetchAssets(isRefresh: true);
                      },
                    )
                  ],
                ),
              ],
            ),
          )
        ],
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
        await fetchAssets();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  void addAssetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tambahkan Aset",
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
                      builder: (context) => const ReceivedPurchase(),
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
                      builder: (context) => const RegisterAssetOld(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff00ABB3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 5),
                child: const Text("Aset Lama"),
              ),
            ),
          ],
        );
      },
    );
  }
}
