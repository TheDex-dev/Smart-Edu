class Assignment {
  final String id;
  final String title;
  final String subject;
  final String dueDate;
  final String? description;
  bool isCompleted;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    this.description,
    this.isCompleted = false,
  });

  // Convert from Map (for JSON parsing)
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      dueDate: map['dueDate'] ?? '',
      description: map['description'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Convert to Map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'dueDate': dueDate,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Create a copy with some fields changed
  Assignment copyWith({
    String? title,
    String? subject,
    String? dueDate,
    String? description,
    bool? isCompleted,
  }) {
    return Assignment(
      id: id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
