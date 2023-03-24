import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';

class MyAssetsPage extends StatefulWidget {
  const MyAssetsPage({Key? key}) : super(key: key);

  @override
  State<MyAssetsPage> createState() => _MyAssetsPageState();
}

class _MyAssetsPageState extends State<MyAssetsPage> {
  var assetsList;
  @override
  void initState(){
    getAssetList();
    super.initState();
  }

  void getAssetList()async{
    assetsList = await Services.getMyAssets();
    setState(() {
      assetsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(assetsList == null){
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
      return const Center(
        child: Text('data received'),
      );
    }
  }
}
