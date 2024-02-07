import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/spare_part_request.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/request_card.dart';
import 'package:repit_app/widgets/spare_part_request_card.dart';
import '../data_classes/asset_request.dart';

class ManageRequest extends StatefulWidget {
  final Map<String, dynamic> role;

  const ManageRequest({Key? key, required this.role}) : super(key: key);

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest>
    with TickerProviderStateMixin {
  List assetRequests = [];
  late Map<String, dynamic> role;
  late int page;
  late int lastPage;
  int requestsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  late TabController _tabController;
  int _tabIndex = 0;
  List sparePartRequests = [];
  int sparePartRequestsLength = 0;
  late EdgeInsets mainPadding;
  String? searchParamAsset;
  final TextEditingController searchControllerAsset = TextEditingController();
  String? searchParamSparePart;
  final  TextEditingController searchControllerSparePart = TextEditingController();

  @override
  void initState() {
    mainPadding = !kIsWeb
        ? const EdgeInsets.symmetric(horizontal: 24)
        : const EdgeInsets.symmetric(horizontal: 600);
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_tabChangesListener);
    role = widget.role;
    page = 1;
    scrollController.addListener(_scrollListener);
    fetchRequests();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRequests({bool? refresh}) async {
    var data = await Services.getListOfRequests(page, searchParamAsset);
    if (data == null) {
      assetRequests += [];
    } else if (refresh == true) {
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

  Future<void> fetchSparePartRequests({bool? isRefresh}) async {
    var data = await Services.getSparePartRequests(page, searchParamSparePart);
    if (data == null) {
      sparePartRequests += [];
    } else {
      List<SparePartRequest> fetchedRequest =
          data['data'].map<SparePartRequest>((request) {
        return SparePartRequest(
          id: request['id'],
          title: request['title'],
          description: request['description'],
          status: request['status'],
          requester: request['requester'],
          createdAt: request['created_at'],
          approvedAt: request['approved_at'],
        );
      }).toList();
      if (isRefresh == true) {
        sparePartRequests = fetchedRequest;
      } else {
        sparePartRequests += fetchedRequest;
      }
      setState(() {
        sparePartRequests;
        sparePartRequestsLength = sparePartRequests.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithSort(context, "Manage Request"),
      body: TabBarView(
        controller: _tabController,
        children: [
          assetRequestsListView(),
          sparePartRequestsListView(),
        ],
      ),
    );
  }

  PreferredSizeWidget appBarWithSort(BuildContext context, String title) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff00ABB3)),
      ),
      titleSpacing: 0,
      backgroundColor: Colors.white,
      leading: BackButton(
        color: const Color(0xff00ABB3),
        onPressed: Navigator.of(context).pop,
      ),
      actions: [
        IconButton(
          onPressed: () async {
            if (_tabIndex == 0) {
              setState(() {
                page = 1;
                assetRequests = [];
                requestsLength = 0;
              });
              await fetchRequests(refresh: true);
            }else{
              setState(() {
                page = 1;
                sparePartRequests = [];
                sparePartRequestsLength = 0;
              });
              await fetchSparePartRequests(isRefresh: true);
            }
          },
          icon: const Icon(
            Icons.refresh,
            size: 32,
            color: Color(0xff00ABB3),
          ),
        ),
        const SizedBox(
          width: 8,
        )
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            text: "Asset",
          ),
          Tab(
            text: "Spare Part",
          )
        ],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        labelColor: const Color(0xff007980),
        indicatorColor: const Color(0xff007980),
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  Widget assetRequestsListView() {
    if (assetRequests.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        Padding(
          padding: mainPadding,
          child: (requestsLength > 0)
              ? RefreshIndicator(
                  onRefresh: () async {
                    page = 1;
                    await fetchRequests(refresh: true);
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount:
                        isLoadingMore ? requestsLength + 1 : requestsLength,
                    itemBuilder: (context, index) {
                      if (index < requestsLength) {
                        return Column(
                          children: [
                            if (index == 0)
                              const SizedBox(
                                height: 68,
                              ),
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
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Padding(
          padding: mainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 16,
              ),
              SearchBar(
                elevation: const MaterialStatePropertyAll<double>(4.0),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                controller: searchControllerAsset,
                onChanged: (value) async {
                  setState(() {
                    page = 1;
                    searchParamAsset = value;
                  });
                  await fetchRequests(refresh: true);
                },
                leading: const Icon(Icons.search),
                hintText: "Cari nomor Permintaan",
                hintStyle: const MaterialStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.black54),
                ),
                trailing: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () async {
                      setState(() {
                        page = 1;
                        searchControllerAsset.clear();
                        searchParamAsset = null;
                      });
                      await fetchRequests(refresh: true);
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget sparePartRequestsListView() {
    if (sparePartRequestsLength == 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Stack(
      children: [
        Padding(
          padding: mainPadding,
          child: (sparePartRequestsLength > 0)
              ? RefreshIndicator(
                  onRefresh: () async {
                    page = 1;
                    await fetchSparePartRequests(isRefresh: true);
                  },
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: isLoadingMore
                          ? sparePartRequestsLength + 1
                          : sparePartRequestsLength,
                      itemBuilder: (context, index) {
                        if (index < sparePartRequestsLength) {
                          return Column(children: [
                            if (index == 0)
                              const SizedBox(
                                height: 68,
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            SparePartRequestCard(
                              sparePartRequest: sparePartRequests[index],
                              role: role,
                            ),
                            (index == sparePartRequestsLength - 1)
                                ? const SizedBox(height: 16)
                                : const SizedBox.shrink()
                          ]);
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
        Padding(
          padding: mainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 16,
              ),
              SearchBar(
                elevation: const MaterialStatePropertyAll<double>(4.0),
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                controller: searchControllerSparePart,
                onChanged: (value) async {
                  setState(() {
                    page = 1;
                    searchParamSparePart = value;
                  });
                  await fetchSparePartRequests(isRefresh: true);
                },
                leading: const Icon(Icons.search),
                hintText: "Cari nomor Permintaan",
                hintStyle: const MaterialStatePropertyAll<TextStyle>(
                  TextStyle(color: Colors.black54),
                ),
                trailing: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () async {
                      setState(() {
                        page = 1;
                        searchControllerSparePart.clear();
                        searchParamSparePart = null;
                      });
                      await fetchSparePartRequests(isRefresh: true);
                    },
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _tabChangesListener() async {
    int newIndex = _tabController.index;
    if (_tabIndex != newIndex) {
      setState(() {
        page = 1;
        _tabIndex = newIndex;
      });
      if (_tabIndex == 0) {
        await fetchRequests(refresh: true);
      } else {
        await fetchSparePartRequests(isRefresh: true);
      }
    }
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
        if (_tabIndex == 0) {
          await fetchRequests();
        } else {
          await fetchSparePartRequests();
        }
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
