import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/firebase_service.dart';

class RaiseTicketScreen extends StatefulWidget {
  @override
  _RaiseTicketScreenState createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<XFile> _images = [];
  final _firebaseService = FirebaseService();

  // 📸 Pick multiple images
  void _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images = pickedFiles;
      });
    }
  }

  // 🚀 Submit ticket
  void _submitTicket() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and description are required!')),
      );
      return;
    }

    List<String> imagePaths = _images
        .map((e) => e.path ?? '') // Null safe fallback
        .toList();

    await _firebaseService.addTicket(
      title: _titleController.text,
      description: _descriptionController.text,
      userId: 'USER_ID', // Replace with actual user ID
      imagePaths: imagePaths,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ticket raised successfully')),
    );

    // Clear form after submission
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _images.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Raise a Ticket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Problem Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 4,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Pick Images'),
              ),
              SizedBox(height: 10),

              // 🖼 Preview Selected Images
              _images.isNotEmpty
                  ? Wrap(
                spacing: 8.0,
                children: _images.map((image) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(image.path), // ✅ Ensured non-null
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              )
                  : Text('No images selected'),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTicket,
                child: Text('Submit Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
