import 'package:flutter/material.dart';
import 'package:repit_app/widgets/ticket_card.dart';
import '../data_classes/ticket.dart';
import '../services.dart';

class MyTicketsPage extends StatefulWidget {
  final Map<String, dynamic> role;

  const MyTicketsPage({super.key, required this.role});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  bool isLoading = false;
  late Map<String, dynamic> role;
  int page = 1;
  late int lastPage;
  int ticketsLength = 0;
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  List tickets = [];

  @override
  void initState() {
    super.initState();
    role = widget.role;
    fetchTickets();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchTickets({bool? isRefresh}) async {
    var data = (role['asset_management'] != 1) ? await Services.getMyTickets(page) : await Services.getHandledTickets(page);
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
        );
      }).toList();
      if (isRefresh == true) {
        tickets = fetchedTickets;
      } else {
        tickets += fetchedTickets;
      }
      setState(() {
        tickets;
        ticketsLength = tickets.length;
        lastPage = data['meta']['last_page'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ticketsLength > 0) {
      return RefreshIndicator(
        onRefresh: () async {
          page = 1;
          await fetchTickets(isRefresh: true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView.builder(
            controller: scrollController,
            itemCount: (isLoadingMore) ? ticketsLength + 1 : ticketsLength,
            itemBuilder: (context, index) {
              if (index < ticketsLength) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    TicketCard(
                      ticket: tickets[index],
                      role: role,
                    ),
                    (index == ticketsLength - 1)? const SizedBox(
                      height: 16
                    ) : const SizedBox.shrink()
                  ]
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40  ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tiket-tiket anda akan tampil disini",
                style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                  'Setelah tiket ditambahkan, maka daftar tiket yang sudah terbuat akan muncul disini',
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
                  onPressed: () async {
                    page = 1;
                    await fetchTickets(isRefresh: true);
                  },
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
        ),
      );
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
        await fetchTickets();
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }
}
