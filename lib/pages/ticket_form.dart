import 'package:flutter/material.dart';

class TicketForm extends StatefulWidget {
  const TicketForm({Key? key}) : super(key: key);

  @override
  State<TicketForm> createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('TicketForm'),
      ),
    );
  }
}
