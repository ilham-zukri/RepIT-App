import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';

import '../data_classes/asset.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({super.key});

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  Future<List<Asset>>? assetsList;

  @override
  void initState() {
    super.initState();
    assetsList = getAssetList();
  }

  Future<List<Asset>> getAssetList() async {
    var assetList = await Services.getMyAssets();
    if (assetList == null) {
      return [];
    }
    return assetList.map((asset) {
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
          asset['owner_id']);
    }).toList();
  }

  void refreshAsset() async {
    try {
      // Fetch the updated asset list
      var refreshedAssets = await getAssetList();

      setState(() {
        // Update the assetsList with the refreshed data
        assetsList = Future.value(refreshedAssets);
      });
    } catch (error) {
      // Handle any errors that occur during the refresh
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(
            context,
            'Error',
            error.toString(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: assetsList,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          alert(context, 'Error', snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        var assets = snapshot.data;
        int assetsLength = assets?.length ?? 0;
        if (assetsLength == 0) {
          return RefreshIndicator(
            onRefresh: () async {
              refreshAsset();
            },
            child: Center(
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
                          refreshAsset();
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
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: RefreshIndicator(
              onRefresh: () async {
                refreshAsset();
              },
              child: ListView(
                children: assets?.map((asset) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          AssetCard(
                            asset: asset,
                            withDetail: true,
                          ),
                          (assets.indexOf(asset) == assets.length - 1)
                              ? const SizedBox(height: 16)
                              : const SizedBox.shrink(),
                        ],
                      );
                    }).toList() ??
                    [],
              ),
            ),
          );
        }
      },
    );
  }
}
