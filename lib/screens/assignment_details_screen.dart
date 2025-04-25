import 'package:flutter/material.dart';

class AssignmentDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> assignment;
  final VoidCallback? onStatusToggle;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
    this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          assignment['isCompleted']
                              ? Icons.check_circle
                              : Icons.pending,
                          color:
                              assignment['isCompleted']
                                  ? Colors.green
                                  : Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            assignment['title'],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      'Subject',
                      assignment['subject'],
                      Icons.subject,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      'Due Date',
                      assignment['dueDate'],
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      'Status',
                      assignment['isCompleted'] ? 'Completed' : 'Pending',
                      Icons.info_outline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              if (onStatusToggle != null) {
                onStatusToggle!();
              }
              Navigator.pop(context);
            },
            child: Text(
              assignment['isCompleted']
                  ? 'Mark as Incomplete'
                  : 'Mark as Complete',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(value, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ],
    );
  }
}
