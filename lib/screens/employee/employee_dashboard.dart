import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firebase_service.dart';
import 'ticket_detail_screen.dart';

class EmployeeDashboard extends StatelessWidget {
  final _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee Dashboard')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseService.getAllTickets(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tickets = snapshot.data!;
          final assignedTickets = tickets
              .where((ticket) => ticket['assignedEmployeeId'] == 'EMPLOYEE_ID') // Replace with actual employee ID
              .toList();

          return ListView.builder(
            itemCount: assignedTickets.length,
            itemBuilder: (context, index) {
              final ticket = assignedTickets[index];
              return ListTile(
                title: Text(ticket['title']),
                subtitle: Text('Status: ${ticket['status']}'),
                onTap: () {
                  // Navigate to ticket details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketDetailScreen(ticketId: ticket['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
