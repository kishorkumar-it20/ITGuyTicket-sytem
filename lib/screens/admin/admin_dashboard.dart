import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import 'assign_ticket_screen.dart';

class AdminDashboard extends StatelessWidget {
  final _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getAllTickets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return ListTile(
                title: Text(ticket['title']),
                subtitle: Text('Status: ${ticket['status']}'),
                trailing: IconButton(
                  icon: Icon(Icons.assignment),
                  onPressed: () {
                    // Navigate to assign ticket screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignTicketScreen(ticketId: ticket['id']),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
