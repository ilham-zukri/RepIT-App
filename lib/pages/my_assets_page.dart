import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:repit_app/asset_card.dart';
import 'package:repit_app/services.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({Key? key}) : super(key: key);

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  List? assetsList;
  int assetsLength = 0;
  @override
  void initState(){
    getAssetList();
    super.initState();
  }

  void getAssetList()async{
    assetsList = await Services.getMyAssets();
    assetsLength = assetsList?.length ?? 0;
    setState(() {
      assetsList;
      assetsLength;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(assetsList?.isEmpty ?? true){
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Aset-aset anda akan tampil disini",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                  'Setelah asset ditambahkan, maka daftar asset yang anda miliki akan muncul disini',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    } else{
      return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
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
                ),

                (assetsList?.indexOf(asset) == assetsLength - 1) ? const SizedBox(height: 16) : const SizedBox.shrink()

              ],
            );
          }).toList() ?? [],
        ),
      );
    }
  }
}
