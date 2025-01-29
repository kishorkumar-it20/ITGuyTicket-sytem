import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class FirebaseService {
  final _firestore = FirebaseFirestore.instance;

  // Add ticket
  Future<void> addTicket(
      {required String title,
        required String description,
        required String userId,
        List<String>? imagePaths}) async {
    final ticketId = _firestore.collection('Tickets').doc().id;

    List<String> imageUrls = [];
    if (imagePaths != null) {
      for (String path in imagePaths) {
        final ref = FirebaseStorage.instance.ref('tickets/$ticketId/${path.split('/').last}');
        final uploadTask = await ref.putFile(File(path));
        imageUrls.add(await ref.getDownloadURL());
      }
    }

    await _firestore.collection('Tickets').doc(ticketId).set({
      'id': ticketId,
      'title': title,
      'description': description,
      'images': imageUrls,
      'userId': userId,
      'status': 'Pending',
      'assignedEmployeeId': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Fetch tickets for user
  Stream<List<Map<String, dynamic>>> getUserTickets(String userId) {
    return _firestore
        .collection('Tickets')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Fetch all tickets for admin
  Stream<List<Map<String, dynamic>>> getAllTickets() {
    return _firestore.collection('Tickets').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
  }

  // Assign ticket to employee
  Future<void> assignTicket(String ticketId, String employeeId) async {
    await _firestore.collection('Tickets').doc(ticketId).update({
      'assignedEmployeeId': employeeId,
      'status': 'Assigned',
    });
  }

  // Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    await _firestore.collection('Tickets').doc(ticketId).update({
      'status': status,
    });
  }
}
