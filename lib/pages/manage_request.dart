import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/request_card.dart';

import '../data_classes/asset_request.dart';

class ManageRequest extends StatefulWidget {
  const ManageRequest({Key? key}) : super(key: key);

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest> {
  late List<AssetRequest>? assetRequests;
  late int page;
  late Map? pageInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = 1;
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    var data = await Services.getListOfRequests(page);
    if (data == null) {
      assetRequests = null;
    } else {
      assetRequests = data['data'].map((request) {
        return AssetRequest(
            request['id'],
            request['priority'],
            request['created_at'],
            request['title'],
            request['description'],
            request['for_user'],
            request['location'],
            request['requester'],
            status: request['status']);
      });
      pageInfo = data['links'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Manage Request"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: ListView(
          children: [RequestCard()],
        ),
      ),
    );
  }
}
