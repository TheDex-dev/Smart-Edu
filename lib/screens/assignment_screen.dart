import 'package:flutter/material.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final List<Map<String, dynamic>> _assignments = [
    {
      'title': 'Mathematics Homework',
      'subject': 'Mathematics',
      'dueDate': '2025-04-28',
      'isCompleted': false,
    },
    {
      'title': 'Science Project',
      'subject': 'Science',
      'dueDate': '2025-05-01',
      'isCompleted': false,
    },
    {
      'title': 'History Essay',
      'subject': 'History',
      'dueDate': '2025-04-30',
      'isCompleted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _assignments.length,
        itemBuilder: (context, index) {
          final assignment = _assignments[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(
                assignment['isCompleted'] ? Icons.check_circle : Icons.pending,
                color: assignment['isCompleted'] ? Colors.green : Colors.orange,
              ),
              title: Text(
                assignment['title'],
                style: TextStyle(
                  decoration:
                      assignment['isCompleted']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                '${assignment['subject']} • Due: ${assignment['dueDate']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Show assignment details or actions
                },
              ),
              onTap: () {
                // Navigate to assignment details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new assignment
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
