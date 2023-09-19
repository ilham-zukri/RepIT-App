import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

class AssetRequestForm extends StatefulWidget {
  const AssetRequestForm({Key? key}) : super(key: key);

  @override
  State<AssetRequestForm> createState() => _AssetRequestFormState();
}

class _AssetRequestFormState extends State<AssetRequestForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context)
    );
  }
}
