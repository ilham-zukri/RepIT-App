import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/data_classes/spare_part.dart';
import 'package:repit_app/widgets/alert.dart';
import 'package:repit_app/widgets/spare_part_card.dart';

import '../data_classes/ticket.dart';
import '../services.dart';
import '../widgets/ticket_card.dart';

class RepairHistory extends StatefulWidget {
  final int assetId;

  const RepairHistory({super.key, required this.assetId});

  @override
  State<RepairHistory> createState() => _RepairHistoryState();
}

class _RepairHistoryState extends State<RepairHistory>
    with TickerProviderStateMixin {
  Map<String, dynamic>? role;
  late int assetId;
  late TabController _tabController;
  final scrollController = ScrollController();
  late int page;
  late int lastPage;
  List tickets = [];
  int ticketsLength = 0;
  List spareParts = [];
  int sparePartsLength = 0;
  bool isLoadingMore = false;
  int _tabIndex = 0;
  late EdgeInsets mainPadding;
  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    assetId = widget.assetId;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_tabChangesListener);
    page = 1;
    scrollController.addListener(_scrollListener);
    fetchRoles();
    fetchTickets();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchRoles() async {
    try {
      role = await Services.getRoles() as Map<String, dynamic>;
    } catch (e) {
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) => alert(
                  context,
                  "Error",
                  e.toString(),
                ));
      }
      return;
    }
    setState(() {
      role;
    });
  }

  Future<void> fetchTickets({bool? isRefresh}) async {
    Map? response;
    try {
      response = await Services.getAssetTickets(assetId: assetId, page: page);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(
            context,
            "Error",
            e.toString(),
          ),
        );
      }
      return;
    }
    List<Ticket> fetchedTickets = response!['data'].map<Ticket>((ticket) {
      return Ticket(
        id: ticket['id'],
        title: ticket['title'],
        categoryId: ticket['category']['id'],
        category: ticket['category']['category'],
        assetId: ticket['asset_id'],
        description: ticket['description'],
        priorityId: ticket['priority']['id'],
        priority: ticket['priority']['priority'],
        status: ticket['status'],
        location: ticket['location'],
        images: (ticket['images'].isEmpty) ? null : ticket['images'],
        createdBy: ticket['created_by'],
        createdAt: ticket['created_at'],
        respondedAt: ticket['responded_at'],
        resolvedAt: ticket['resolved_at'],
        closedAt: ticket['closed_at'],
        handler: ticket['handler'],
        note: ticket['note'],
      );
    }).toList();
    if (isRefresh == true) {
      tickets = fetchedTickets;
    } else {
      tickets += fetchedTickets;
    }
    setState(() {
      tickets;
      lastPage = response!['meta']['last_page'];
      ticketsLength = tickets.length;
    });
  }

  Future<void> fetchSpareParts({bool? isRefresh}) async {
    Map? response;
    try {
      response =
          await Services.getAssetSpareParts(assetId: assetId, page: page);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => alert(
            context,
            "Error",
            e.toString(),
          ),
        );
      }
      return;
    }
    List<SparePart> fetchedSpareParts =
        response!['data'].map<SparePart>((sparePart) {
      return SparePart(
        id: sparePart['id'],
        type: sparePart['type'],
        purchaseId: sparePart['purchase_id'],
        brand: sparePart['brand'],
        model: sparePart['model'],
        qrPath: sparePart['qr_path'],
        serialNumber: sparePart['serial_number'],
        status: sparePart['status'],
        assetId: sparePart['device_id'],
        createdAt: sparePart['created_at'],
      );
    }).toList();
    if (isRefresh == true) {
      spareParts = fetchedSpareParts;
    } else {
      spareParts += fetchedSpareParts;
    }
    setState(() {
      spareParts;
      lastPage = response!['meta']['last_page'];
      sparePartsLength = spareParts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder(context, "Repair History"),
      body: TabBarView(
        controller: _tabController,
        children: [
          ticketListViewBuilder(),
          sparePartListViewBuilder(),
        ],
      ),
    );
  }

  Widget ticketListViewBuilder() {
    if (tickets.isEmpty || role == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        page = 1;
        await fetchTickets(isRefresh: true);
      },
      child: Padding(
        padding: mainPadding,
        child: ListView.builder(
          controller: scrollController,
          itemCount: ticketsLength + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < ticketsLength) {
              return Column(children: [
                const SizedBox(
                  height: 16,
                ),
                TicketCard(
                  ticket: tickets[index],
                  role: role!,
                ),
                (index == ticketsLength - 1)
                    ? const SizedBox(height: 16)
                    : const SizedBox.shrink()
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget sparePartListViewBuilder() {
    if (spareParts.isEmpty || role == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        page = 1;
        await fetchSpareParts();
      },
      child: Padding(
        padding: mainPadding,
        child: ListView.builder(
          controller: scrollController,
          itemCount: sparePartsLength + (isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < sparePartsLength) {
              return Column(children: [
                const SizedBox(
                  height: 16,
                ),
                SparePartCard(sparePart: spareParts[index], withDetail: true),
                (index == sparePartsLength - 1)
                    ? const SizedBox(height: 16)
                    : const SizedBox.shrink()
              ]);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  PreferredSizeWidget appBarBuilder(BuildContext context, String title) {
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
      bottom: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(
            text: "Tickets",
          ),
          Tab(
            text: "Spare Parts",
          )
        ],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        labelColor: const Color(0xff007980),
        indicatorColor: const Color(0xff007980),
        indicatorSize: TabBarIndicatorSize.label,
      ),
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
        await fetchTickets(isRefresh: true);
      } else {
        await fetchSpareParts(isRefresh: true);
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
          await fetchTickets();
        } else {
          await fetchSpareParts();
        }
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
