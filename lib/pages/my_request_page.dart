import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';

import '../data_classes/asset_request.dart';
import '../widgets/request_card.dart';

class MyRequestPage extends StatefulWidget {
  final Map<String, dynamic> role;

  const MyRequestPage({Key? key, required this.role}) : super(key: key);

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  List assetRequests = [];
  late Map<String, dynamic> role;
  late int page;
  late int lastPage;
  int requestsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  late EdgeInsets mainPadding;

  bool isLoading = false;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    super.initState();
    role = widget.role;
    page = 1;
    fetchRequests(isRefresh: true);
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRequests({required bool isRefresh}) async {
    var data = await Services.getMyListOfRequests(page);
    if (data == null) {
      assetRequests += [];
    } else if (isRefresh) {
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
      }).toList();
      setState(() {
        lastPage = data['meta']['last_page'];
        assetRequests;
        requestsLength = assetRequests.length;
      });
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
    return Padding(
      padding: mainPadding,
      child: (requestsLength > 0)
          ? RefreshIndicator(
              onRefresh: () async {
                page = 1;
                await fetchRequests(isRefresh: true);
              },
              child: ListView.builder(
                controller: scrollController,
                itemCount:
                    isLoadingMore ? requestsLength + 1 : requestsLength,
                itemBuilder: (context, index) {
                  if (index < requestsLength) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        RequestCard(
                          request: assetRequests[index],
                          role: role,
                        ),
                        (index == requestsLength - 1)
                            ? const SizedBox(height: 16)
                            : const SizedBox.shrink()
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          : blankListView(),
    );
  }

  Widget blankListView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Permintaan-Permintaan anda akan tampil disini",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
              'Setelah permintaan ditambahkan, maka daftar permintaan yang anda miliki akan muncul disini',
              style: TextStyle(
                fontSize: 14,
              ),
              textAlign: TextAlign.center),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            width: 115,
            height: 35,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00ABB3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5),
              onPressed: (role["asset_request"] == 1) ? () async {
                setState(() {
                  isLoading = true;
                });
                await fetchRequests(isRefresh: true);
                setState(() {
                  isLoading = false;
                });
              } : null,
              child: const Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 4),
                  Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scrollListener() async {
    if (isLoadingMore) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page < lastPage) {
        setState(() {
          isLoadingMore = true;
        });
        page++;
        await fetchRequests(isRefresh: false);
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
