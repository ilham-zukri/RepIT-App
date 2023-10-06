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
  List assetRequests = [];
  late int page;
  late int lastPage;
  int requestsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    page = 1;
    scrollController.addListener(_scrollListener);
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    var data = await Services.getListOfRequests(page);
    if (data == null) {
      assetRequests = [];
    } else {
      assetRequests += data['data'].map((request) {
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
      }).toList();
      setState(() {
        lastPage = data['meta']['last_page'];
        assetRequests;
        requestsLength = assetRequests.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, "Manage Request"),
      body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: ListView.builder(
            controller: scrollController,
            itemCount: isLoadingMore ? requestsLength + 1 : requestsLength,
            itemBuilder: (context, index) {
              if(index < requestsLength){
                return Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    RequestCard(
                      request: assetRequests[index],
                    ),
                    (index == requestsLength - 1)
                        ? const SizedBox(height: 16)
                        : const SizedBox.shrink()
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }

            },
          )),
    );
  }

  Future<void> _scrollListener() async{
    if(isLoadingMore) return;
    if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
      if(page < lastPage){
        setState(() {
          isLoadingMore = true;
        });
        page++;
        await fetchRequests();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
