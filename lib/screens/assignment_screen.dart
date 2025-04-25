import 'package:flutter/material.dart';
import 'assignment_details_screen.dart';

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

  void _toggleAssignmentStatus(int index) {
    setState(() {
      _assignments[index]['isCompleted'] = !_assignments[index]['isCompleted'];
    });
  }

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
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.visibility),
                              title: const Text('View Details'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => AssignmentDetailsScreen(
                                          assignment: assignment,
                                          onStatusToggle:
                                              () => _toggleAssignmentStatus(
                                                index,
                                              ),
                                        ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                assignment['isCompleted']
                                    ? Icons.check_circle_outline
                                    : Icons.check_circle,
                              ),
                              title: Text(
                                assignment['isCompleted']
                                    ? 'Mark as Incomplete'
                                    : 'Mark as Complete',
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                _toggleAssignmentStatus(index);
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AssignmentDetailsScreen(
                          assignment: assignment,
                          onStatusToggle: () => _toggleAssignmentStatus(index),
                        ),
                  ),
                );
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
