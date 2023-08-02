import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/services.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({Key? key, this.assetList}) : super(key: key);
  final List? assetList;

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  List? assetsList;
  int assetsLength = 0;

  @override
  void initState() {
    super.initState();
    assetsList = widget.assetList;
    assetsLength = assetsList?.length ?? 0;
  }

  Future<void> getAssetList() async {
    try{
      assetsList = await Services.getMyAssets();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xff00ABB3),
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }
    assetsLength = assetsLength = assetsList?.length ?? 0;
    setState(() {
      assetsList;
      assetsLength;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (assetsList?.isEmpty ?? true) {
      return RefreshIndicator(
        onRefresh: () async {
          getAssetList();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Aset-aset anda akan tampil disini",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                      getAssetList();
                    },
                    child: Row(
                      children: const [
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
            getAssetList();
          },
          child: ListView(
            children: assetsList?.map((asset) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      AssetCard(
                        utilization: asset['utilization'],
                        assetType: asset['asset_type'],
                        ram: asset['ram'],
                        cpu: asset['cpu'],
                        serialNumber: asset['serial_number'],
                        location: asset['location'],
                        status: asset['status'],
                        model: asset['model'],
                        brand: asset['brand'],
                      ),
                      (assetsList?.indexOf(asset) == assetsLength - 1)
                          ? const SizedBox(height: 16)
                          : const SizedBox.shrink()
                    ],
                  );
                }).toList() ??
                [],
          ),
        ),
      );
    }
  }
}
