import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

class AssignTicketScreen extends StatefulWidget {
  final String ticketId;

  AssignTicketScreen({required this.ticketId});

  @override
  _AssignTicketScreenState createState() => _AssignTicketScreenState();
}

class _AssignTicketScreenState extends State<AssignTicketScreen> {
  final _firebaseService = FirebaseService();
  final _employeeIdController = TextEditingController();

  void _assignTicket() async {
    await _firebaseService.assignTicket(widget.ticketId, _employeeIdController.text);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket Assigned')));
    Navigator.pop(context); // Go back to the Admin Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assign Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _employeeIdController,
              decoration: InputDecoration(labelText: 'Employee ID'),
            ),
            ElevatedButton(
              onPressed: _assignTicket,
              child: Text('Assign Ticket'),
            ),
          ],
        ),
      ),
    );
  }
}
