import 'package:flutter/material.dart';
import 'package:repit_app/widgets/priority_box_builder.dart';
import 'package:repit_app/widgets/ticket_status_box_builder.dart';

import '../data_classes/ticket.dart';

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> role;
  final Ticket ticket;
  const TicketCard({super.key, required this.role, required this.ticket});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SizedBox(
      width: size.width,
      height: 170,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: InkWell(
          onTap: () {},
          child: Column(
            children: [
              Container(
                width: size.width,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xff009199),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ticket.id.toString(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      priorityBoxBuilder('Low', 'card')
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.createdBy!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      ticket.title,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        ticket.location!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ticketStatusBoxBuilder(ticket.status!, "card"),
                        Text(ticket.createdAt!)
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
