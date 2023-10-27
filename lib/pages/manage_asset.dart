import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

class ManageAsset extends StatefulWidget {
  const ManageAsset({super.key});

  @override
  State<ManageAsset> createState() => _ManageAssetState();
}

class _ManageAssetState extends State<ManageAsset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Manage Assets"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
          itemBuilder: (context, index) {

          },
        ),
      ),
    );
  }
}
