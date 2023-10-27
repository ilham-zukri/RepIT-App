import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/purchase.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

class RegisterAsset extends StatefulWidget {
  final Purchase purchase;

  const RegisterAsset({super.key, required this.purchase});

  @override
  State<RegisterAsset> createState() => _RegisterAssetState();
}

class _RegisterAssetState extends State<RegisterAsset> {
  late final Purchase purchase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    purchase = widget.purchase;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Register Asset", "purchaseItems", () {
        showPurchaseItemDialog();
      }),
    );
  }

  void showPurchaseItemDialog() {
    showDialog(
      context: context,
      builder: (context) => alert(context, "Test", "test alert"),
    );
  }
}
