import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../data_classes/asset.dart';
import '../services.dart';

class PurchaseAsset extends StatefulWidget {
  final int purchaseId;

  const PurchaseAsset({super.key, required this.purchaseId});

  @override
  State<PurchaseAsset> createState() => _PurchaseAssetState();
}

class _PurchaseAssetState extends State<PurchaseAsset> {
  List assets = [];
  int assetsLength = 0;

  @override
  void initState() {
    getPurchasedAssets();
    super.initState();
  }

  Future<void> getPurchasedAssets() async {
    var data = await Services.getPurchasedAssets(widget.purchaseId);
    if (data == null) {
      assets += [];
    } else {
      assets = data.map(
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
            asset['owner'],
          );
        },
      ).toList();
    }
    setState(() {
      assets;
      assetsLength = assets.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Purchased Asset"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Nomor Pembelian: ${widget.purchaseId}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              color: Colors.black38,
              thickness: 2,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: assetsLength,
                  itemBuilder: (context, index) {
                    if (index < assetsLength) {
                      return Column(children: [
                        const SizedBox(
                          height: 16,
                        ),
                        AssetCard(
                          withDetail: true,
                          asset: assets[index],
                          withAdvancedMenu: false,
                        ),
                        if (index == assetsLength - 1)
                          const SizedBox(
                            height: 16,
                          ),
                      ]);
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
