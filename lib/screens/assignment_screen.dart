import 'package:flutter/material.dart';
import 'assignment_details_screen.dart';
import 'add_assignment_screen.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  // Cache for reused colors and styles
  late final Color _primaryWithAlpha;
  late final Color _greenBackground = const Color.fromRGBO(76, 175, 80, 0.1);
  late final Color _orangeBackground = const Color.fromRGBO(255, 152, 0, 0.1);
  late final Color _green = Colors.green;
  late final Color _orange = Colors.orange;
  late final Color _greyBorder = const Color.fromRGBO(158, 158, 158, 0.2);

  // Cache for animation transitions
  late final Animatable<Offset> _detailsRouteTween = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  final List<Map<String, dynamic>> _assignments = [
    {
      'id': '1',
      'title': 'Mathematics Homework',
      'subject': 'Mathematics',
      'dueDate': '2025-04-28',
      'description': 'Complete exercises 1-10 from chapter 5',
      'isCompleted': false,
    },
    {
      'id': '2',
      'title': 'Science Project',
      'subject': 'Science',
      'dueDate': '2025-05-01',
      'description': 'Research and create a presentation on renewable energy',
      'isCompleted': false,
    },
    {
      'id': '3',
      'title': 'History Essay',
      'subject': 'History',
      'dueDate': '2025-04-30',
      'description': 'Write a 1000-word essay on World War II',
      'isCompleted': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize theme-dependent colors
    _primaryWithAlpha = Theme.of(context).colorScheme.primary.withAlpha(26);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleAssignmentStatus(int index) {
    setState(() {
      _assignments[index]['isCompleted'] = !_assignments[index]['isCompleted'];

      // Play animation when status changes
      if (_assignments[index]['isCompleted']) {
        _animationController.forward(from: 0.0);
      } else {
        _animationController.reverse(from: 1.0);
      }
    });
  }

  void _addNewAssignment(Map<String, dynamic> assignment) {
    setState(() {
      // Add an ID to the assignment
      assignment['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      _assignments.add(assignment);
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Assignments Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first assignment to get started',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddAssignment(),
            icon: const Icon(Icons.add),
            label: const Text('Add Assignment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddAssignment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddAssignmentScreen(onAssignmentAdded: _addNewAssignment),
      ),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment, int index) {
    final bool isCompleted = assignment['isCompleted'] ?? false;
    final Color statusColor = isCompleted ? _green : _orange;
    final Color statusBackgroundColor =
        isCompleted ? _greenBackground : _orangeBackground;
    final TextDecoration titleDecoration =
        isCompleted ? TextDecoration.lineThrough : TextDecoration.none;
    final Color titleColor = isCompleted ? Colors.grey : Colors.black87;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        side: BorderSide(color: _greyBorder, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: statusBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.pending,
            color: statusColor,
          ),
        ),
        title: Text(
          assignment['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: titleDecoration,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: _buildAssignmentSubtitle(assignment),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showOptionsSheet(context, assignment, index),
        ),
        onTap: () => _navigateToDetails(context, assignment, index),
      ),
    );
  }

  Widget _buildAssignmentSubtitle(Map<String, dynamic> assignment) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: _primaryWithAlpha,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Text(
            assignment['subject'],
            style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          'Due: ${assignment['dueDate']}',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _showOptionsSheet(
    BuildContext context,
    Map<String, dynamic> assignment,
    int index,
  ) {
    final bool isCompleted = assignment['isCompleted'] ?? false;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) =>
              _buildOptionsSheet(context, assignment, index, isCompleted),
    );
  }

  Widget _buildOptionsSheet(
    BuildContext context,
    Map<String, dynamic> assignment,
    int index,
    bool isCompleted,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.visibility),
          title: const Text('View Details'),
          onTap: () {
            Navigator.pop(context);
            _navigateToDetails(context, assignment, index);
          },
        ),
        ListTile(
          leading: Icon(
            isCompleted ? Icons.check_circle_outline : Icons.check_circle,
          ),
          title: Text(isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
          onTap: () {
            Navigator.pop(context);
            _toggleAssignmentStatus(index);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.blue),
          title: const Text('Edit Assignment'),
          onTap: () {
            Navigator.pop(context);
            // TODO: Implement edit functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit functionality coming soon')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text(
            'Delete Assignment',
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            Navigator.pop(context);
            _confirmDelete(context, index);
          },
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Assignment'),
            content: const Text(
              'Are you sure you want to delete this assignment?',
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _assignments.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Assignment deleted')),
                  );
                },
              ),
            ],
          ),
    );
  }

  void _navigateToDetails(
    BuildContext context,
    Map<String, dynamic> assignment,
    int index,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => AssignmentDetailsScreen(
              assignment: assignment,
              onStatusToggle: () => _toggleAssignmentStatus(index),
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(_detailsRouteTween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filtering functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filtering coming soon')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon')),
              );
            },
          ),
        ],
      ),
      body: _assignments.isEmpty ? _buildEmptyState() : _buildAssignmentsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAssignment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    return ListView.builder(
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        final assignment = _assignments[index];
        return _buildAnimatedListItem(assignment, index);
      },
    );
  }

  Widget _buildAnimatedListItem(Map<String, dynamic> assignment, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + (index * 100)),
          curve: Curves.easeOutQuad,
          builder: (context, value, child) {
            return FadeTransition(
              opacity: Animation<double>.fromValueListenable(
                ValueNotifier<double>(value),
              ),
              child: SlideTransition(
                position: Animation<Offset>.fromValueListenable(
                  ValueNotifier<Offset>(Offset(0, 1 - value)),
                ),
                child: child,
              ),
            );
          },
          child: _buildAssignmentCard(assignment, index),
        );
      },
    );
  }
}
