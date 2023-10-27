import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
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
  List assets = [];
  int assetsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAssets();
    scrollController.addListener(_scrollListener);
  }

  Future<void> fetchAssets({bool? isRefresh}) async {
    var data = await Services.getAllAssets(page);
    if (data == null) {
      assets += [];
    } else if (isRefresh == true) {
      assets = data['data'].map(
        (asset) {
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
          );
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
          );
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
        appBar: customAppBar(context, "Manage Assets"),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                            const SizedBox(
                              height: 16,
                            ),
                            AssetCard(asset: assets[index]),
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
        ));
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
