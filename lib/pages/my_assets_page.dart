import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/services.dart';

import '../data_classes/asset.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({super.key});

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  int page = 1;
  late int lastPage;
  List assets = [];
  int assetsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
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
    var data = await Services.getMyAssets(page);
    if (data == null) {
      assets += [];
    } else {
      List<Asset> fetchedAssets = data['data'].map<Asset>((asset) {
        return Asset(
          asset['id'],
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
          asset['owner_id'],
        );
      }).toList();

      if (isRefresh == true) {
        assets = fetchedAssets;
      } else {
        assets += fetchedAssets;
      }

      setState(() {
        assets;
        assetsLength = assets.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (assetsLength > 0) {
      return RefreshIndicator(
        onRefresh: () async {
          page = 1;
          await fetchAssets(isRefresh: true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView.builder(
            controller: scrollController,
            itemCount: isLoadingMore ? assetsLength + 1 : assetsLength,
            itemBuilder: (context, index) {
              if (index < assetsLength) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    AssetCard(asset: assets[index], withDetail: true),
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
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Aset-aset anda akan tampil disini",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                  'Setelah asset ditambahkan, maka daftar asset yang anda miliki akan muncul disini',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: 115,
                height: 35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00ABB3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 5),
                  onPressed: () async {
                    page = 1;
                    await fetchAssets(isRefresh: true);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 4),
                      Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
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
}
