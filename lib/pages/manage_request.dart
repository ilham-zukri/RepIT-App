import 'package:flutter/material.dart';
import 'package:repit_app/services.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/request_card.dart';
import '../data_classes/asset_request.dart';
import '../data_classes/location_for_list.dart';

class ManageRequest extends StatefulWidget {
  final Map<String, dynamic> role;

  const ManageRequest({Key? key, required this.role}) : super(key: key);

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest> {
  List assetRequests = [];
  late Map<String, dynamic> role;
  late int page;
  late int lastPage;
  int requestsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  static const List<String> sortOrders = <String>['asc', 'desc'];
  String? prioritySort;
  String? createdAtSort;
  int? locationFilter;
  late Future<List<LocationForList>> locations;
  late int? locationId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    role = widget.role;
    page = 1;
    scrollController.addListener(_scrollListener);
    fetchRequests();
    locations = fetchLocations();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRequests({bool? refresh}) async {
    var data = await Services.getListOfRequests(page,
        filterLocation: locationFilter,
        createdAtSort: createdAtSort,
        prioritySort: prioritySort);
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

  Future<void> fetchRequestsSort() async {
    try {
      var data = await Services.getListOfRequests(page,
          filterLocation: locationFilter,
          createdAtSort: createdAtSort,
          prioritySort: prioritySort);
      if (data != null) {
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
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<LocationForList>> fetchLocations() async {
    final data = await Services.getLocationList();
    if (data == null) {
      return [];
    }
    locationId = data[0]['id'];
    return data.map((item) {
      return LocationForList(item['id'], item['name']);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithSort(context, "Manage Request"),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
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
        await fetchRequests();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
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
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  var size = MediaQuery.of(context).size;
                  prioritySort = sortOrders[0];
                  createdAtSort = sortOrders[0];
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text("Sort & Filter"),
                        content: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Prioritas",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: prioritySort,
                                      items: sortOrders.map((String value) {
                                        return DropdownMenuItem(
                                            value: value, child: Text(value));
                                      }).toList(),
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            prioritySort = value!;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Tanggal dibuat",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black54, width: 1),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      isExpanded: true,
                                      value: createdAtSort,
                                      items: sortOrders.map((String value) {
                                        return DropdownMenuItem(
                                            value: value, child: Text(value));
                                      }).toList(),
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            createdAtSort = value!;
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Lokasi",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              FutureBuilder(
                                future: locations,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text(snapshot.error.toString());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else {
                                    List<dynamic>? locationData = snapshot.data;
                                    String? initialLocationSelection;
                                    if (locationData != null &&
                                        locationData.isNotEmpty) {
                                      initialLocationSelection =
                                          locationData.first.id.toString();
                                    }
                                    return DropdownMenu(
                                      width: size.width / 1.5,
                                      menuHeight: size.height / 2,
                                      textStyle: const TextStyle(fontSize: 16),
                                      enableSearch: true,
                                      initialSelection:
                                          initialLocationSelection,
                                      onSelected: (value) {
                                        setState(() {
                                          locationId =
                                              int.parse(value as String);
                                          locationFilter = locationId;
                                        });
                                      },
                                      dropdownMenuEntries:
                                          locationData!.map((location) {
                                        return DropdownMenuEntry(
                                            value: location.id.toString(),
                                            label: location.name);
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF05050),
                            ),
                            child: const Text("Batal"),
                          ),
                          const SizedBox.shrink(),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                page = 1;
                                await fetchRequestsSort();
                                if (mounted) {
                                  build(context);
                                }
                                if (mounted) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                if (mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        alert(context, "Error", e.toString()),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00ABB3),
                            ),
                            child: const Text("OK"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.filter_alt,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 6),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 32,
              color: Color(0xff00ABB3),
            ),
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
