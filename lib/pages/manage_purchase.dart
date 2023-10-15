import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/purchase_card.dart';

class ManagePurchase extends StatefulWidget {
  const ManagePurchase({super.key});

  @override
  State<ManagePurchase> createState() => _ManagePurchaseState();
}

class _ManagePurchaseState extends State<ManagePurchase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Purchasing"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: const Center(
          child: PurchaseCard(),
        ),
      ),
    );
  }
}
