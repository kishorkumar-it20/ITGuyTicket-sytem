import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';

class TicketDetailScreen extends StatefulWidget {
  final String ticketId;

  TicketDetailScreen({required this.ticketId});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _firebaseService = FirebaseService();
  String _status = 'In Progress'; // Default status

  void _updateTicketStatus() async {
    await _firebaseService.updateTicketStatus(widget.ticketId, _status);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ticket Status Updated')));
    Navigator.pop(context); // Go back to the Employee Dashboard
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['In Progress', 'Completed', 'Pending']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _updateTicketStatus,
              child: Text('Update Status'),
            ),
          ],
        ),
      ),
    );
  }
}
