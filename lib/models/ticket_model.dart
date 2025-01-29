class Ticket {
  String id;
  String title;
  String description;
  List<String>? images;
  String userId;
  String? assignedEmployeeId;
  String status;
  DateTime? createdAt;

  Ticket({
    required this.id,
    required this.title,
    required this.description,
    this.images,
    required this.userId,
    this.assignedEmployeeId,
    required this.status,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'images': images,
      'userId': userId,
      'assignedEmployeeId': assignedEmployeeId,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory Ticket.fromMap(Map<String, dynamic> map) {
    return Ticket(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      images: List<String>.from(map['images'] ?? []),
      userId: map['userId'],
      assignedEmployeeId: map['assignedEmployeeId'],
      status: map['status'],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
    );
  }
}
