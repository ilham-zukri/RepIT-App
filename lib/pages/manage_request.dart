import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import 'package:repit_app/widgets/request_card.dart';

class ManageRequest extends StatefulWidget {
  const ManageRequest({Key? key}) : super(key: key);

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: customAppBar(context, "Manage Request"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: ListView(
          children: [
            RequestCard()
          ],
        ),
      ),
    );
  }
}
