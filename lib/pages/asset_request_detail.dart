import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';

import '../data_classes/asset_request.dart';

class AssetRequestDetail extends StatefulWidget {

  AssetRequest? request;

  AssetRequestDetail({super.key, required this.request});
  @override
  State<AssetRequestDetail> createState() => _AssetRequestDetailState();
}

class _AssetRequestDetailState extends State<AssetRequestDetail> {
  AssetRequest? request;

  @override
  void initState() {
    super.initState();
    request = widget.request;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Detail Request"),
      body: Center(
        child: Text(
          request!.title
        ),
      ),
    );
  }
}
