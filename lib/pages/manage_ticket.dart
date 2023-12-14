import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:repit_app/widgets/custom_app_bar.dart';
import '../data_classes/ticket.dart';
import '../services.dart';
import '../widgets/ticket_card.dart';

class ManageTicket extends StatefulWidget {
  final Map<String, dynamic> role;

  const ManageTicket({super.key, required this.role});

  @override
  State<ManageTicket> createState() => _ManageTicketState();
}

class _ManageTicketState extends State<ManageTicket> {
  bool isLoading = false;
  late Map<String, dynamic> role;
  int page = 1;
  late int lastPage;
  int ticketsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List tickets = [];
  late EdgeInsets mainPadding;
  final TextEditingController searchController = TextEditingController();
  String? searchParam;

  @override
  void initState() {
    mainPadding = !kIsWeb ? const EdgeInsets.symmetric(horizontal: 24) : const EdgeInsets.symmetric(horizontal: 600);
    super.initState();
    fetchTickets();
    role = widget.role;
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchTickets({bool? isRefresh}) async {
    var data = await Services.getAllTickets(page, searchParam);
    if (data == null) {
      tickets += [];
    } else {
      List<Ticket> fetchedTickets = data['data'].map<Ticket>((ticket) {
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
          flag: ticket['flag'],
        );
      }).toList();
      if (isRefresh == true) {
        tickets = fetchedTickets;
      } else {
        tickets += fetchedTickets;
      }
      setState(() {
        tickets;
        lastPage = data['meta']['last_page'];
        ticketsLength = tickets.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context,
        "Manage Ticket",
        'refresh',
        () {
          setState(() {
            page = 1;
            tickets = [];
            ticketsLength = 0;
            fetchTickets(isRefresh: true);
          });
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: mainPadding,
            child: (ticketsLength > 0)
                ? RefreshIndicator(
                    onRefresh: () async {
                      page = 1;
                      await fetchTickets(isRefresh: true);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount:
                          (isLoadingMore) ? ticketsLength + 1 : ticketsLength,
                      itemBuilder: (context, index) {
                        if (index < ticketsLength) {
                          return Column(children: [
                            if (index == 0)
                              const SizedBox(
                                height: 68,
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                            TicketCard(
                              ticket: tickets[index],
                              role: role,
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
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: mainPadding,
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                SearchBar(
                  elevation: const MaterialStatePropertyAll<double>(4.0),

                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  controller: searchController,
                  onChanged: (value) async {
                    setState(() {
                      searchParam = value;
                    });
                    await fetchTickets(isRefresh: true);
                  },
                  leading: const Icon(Icons.search),
                  hintText: "Cari No Ticket dan ID Asset",
                  hintStyle: const MaterialStatePropertyAll<TextStyle>(
                    TextStyle(color: Colors.black54),
                  ),
                  trailing: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () async {
                        setState(() {
                          searchController.clear();
                          searchParam = null;
                        });
                        await fetchTickets(isRefresh: true);
                      },
                    )
                  ],
                ),
              ],
            ),
          )
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
        await fetchTickets();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
