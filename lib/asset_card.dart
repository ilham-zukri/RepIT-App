import 'package:flutter/material.dart';

class AssetCard extends StatelessWidget {
  const AssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 155,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 5,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xff009199),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Aset-aset anda akan tampil disini",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 15, right: 15),
              child: const Text(
                  "Setelah asset ditambahkan, maka daftar asset yang anda miliki akan muncul disini"),
            )
          ],
        ),
      ),
    );
  }
}
