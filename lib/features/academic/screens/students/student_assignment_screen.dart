import 'package:flutter/material.dart';
import '../../../../features/assignments/models/assignment.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/performance_config.dart';

class StudentAssignmentScreen extends StatefulWidget {
  const StudentAssignmentScreen({super.key});

  @override
  State<StudentAssignmentScreen> createState() => _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<StudentAssignmentScreen>
    with SingleTickerProviderStateMixin, PerformanceOptimizedMixin {
  late AnimationController _animationController;
  
  List<Assignment> _studentAssignments = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'All';
  
  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Completed',
    'Overdue',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadAssignments();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAssignments() async {
    setState(() => _isLoading = true);
    
    try {
      final assignments = await FirebaseService.getStudentAssignments();
      
      setState(() {
        _studentAssignments = assignments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading assignments: $e')),
        );
      }
    }
  }

  List<Assignment> get _filteredAssignments {
    return _studentAssignments.where((assignment) {
      final matchesSearch = assignment.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          assignment.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (assignment.teacherName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final now = DateTime.now();
      final dueDate = DateTime.parse(assignment.dueDate);
      final isOverdue = dueDate.isBefore(now) && !assignment.isCompleted;
      
      bool matchesFilter = true;
      switch (_selectedFilter) {
        case 'Pending':
          matchesFilter = !assignment.isCompleted && !isOverdue;
          break;
        case 'Completed':
          matchesFilter = assignment.isCompleted;
          break;
        case 'Overdue':
          matchesFilter = isOverdue;
          break;
        case 'All':
        default:
          matchesFilter = true;
      }
      
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Assignments'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssignments,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchAndFilter(),
                _buildAssignmentStats(),
                Expanded(child: _buildAssignmentsList()),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search assignments...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(filter),
                    onSelected: (selected) {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentStats() {
    final totalAssignments = _studentAssignments.length;
    final pendingAssignments = _studentAssignments.where((a) => 
        !a.isCompleted && DateTime.parse(a.dueDate).isAfter(DateTime.now())).length;
    final completedAssignments = _studentAssignments.where((a) => a.isCompleted).length;
    final overdueAssignments = _studentAssignments.where((a) => 
        !a.isCompleted && DateTime.parse(a.dueDate).isBefore(DateTime.now())).length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Total', totalAssignments.toString(), Icons.assignment),
          _buildStatCard('Pending', pendingAssignments.toString(), Icons.schedule),
          _buildStatCard('Done', completedAssignments.toString(), Icons.check_circle),
          if (overdueAssignments > 0)
            _buildStatCard('Overdue', overdueAssignments.toString(), Icons.warning, isWarning: true),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, {bool isWarning = false}) {
    return Column(
      children: [
        Icon(
          icon, 
          color: isWarning ? Colors.orange.shade200 : Colors.white, 
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isWarning ? Colors.orange.shade200 : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isWarning ? Colors.orange.shade100 : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentsList() {
    final filteredAssignments = _filteredAssignments;
    
    if (filteredAssignments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != 'All'
                  ? 'No assignments match your filters'
                  : 'No assignments yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty || _selectedFilter != 'All'
                  ? 'Try adjusting your search or filter'
                  : 'Your teacher will assign work soon',
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAssignments.length,
      itemBuilder: (context, index) {
        final assignment = filteredAssignments[index];
        return _buildAssignmentCard(assignment, index);
      },
    );
  }

  Widget _buildAssignmentCard(Assignment assignment, int index) {
    final dueDate = DateTime.parse(assignment.dueDate);
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now) && !assignment.isCompleted;
    final isDueSoon = dueDate.difference(now).inDays <= 1 && !assignment.isCompleted;
    final daysUntilDue = dueDate.difference(now).inDays;
    
    Color cardColor = Colors.blue.shade50;
    Color accentColor = Colors.blue;
    
    if (assignment.isCompleted) {
      cardColor = Colors.green.shade50;
      accentColor = Colors.green;
    } else if (isOverdue) {
      cardColor = Colors.red.shade50;
      accentColor = Colors.red;
    } else if (isDueSoon) {
      cardColor = Colors.orange.shade50;
      accentColor = Colors.orange;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              assignment.isCompleted 
                  ? Icons.check_circle 
                  : isOverdue 
                      ? Icons.warning 
                      : Icons.assignment,
              color: accentColor,
              size: 24,
            ),
          ),
          title: Text(
            assignment.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: assignment.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.book, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(assignment.subject),
                ],
              ),
              if (assignment.teacherName != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(assignment.teacherName!),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: isOverdue ? Colors.red : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    assignment.isCompleted
                        ? 'Completed'
                        : isOverdue 
                            ? 'Overdue'
                            : daysUntilDue == 0 
                                ? 'Due today'
                                : 'Due in $daysUntilDue days',
                    style: TextStyle(
                      color: assignment.isCompleted 
                          ? Colors.green 
                          : isOverdue 
                              ? Colors.red 
                              : isDueSoon 
                                  ? Colors.orange 
                                  : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (assignment.points != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${assignment.points} points',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!assignment.isCompleted)
                IconButton(
                  icon: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  onPressed: () => _markAsCompleted(assignment),
                  tooltip: 'Mark as completed',
                ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () => _viewAssignmentDetails(assignment),
                tooltip: 'View details',
              ),
            ],
          ),
          onTap: () => _viewAssignmentDetails(assignment),
        ),
      ),
    );
  }

  Future<void> _markAsCompleted(Assignment assignment) async {
    try {
      final updatedAssignment = assignment.copyWith(isCompleted: true);
      await FirebaseService.updateAssignment(assignment.id, updatedAssignment);
      
      _loadAssignments();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment marked as completed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating assignment: $e')),
        );
      }
    }
  }

  void _viewAssignmentDetails(Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => AssignmentDetailsDialog(assignment: assignment),
    );
  }
}

class AssignmentDetailsDialog extends StatelessWidget {
  final Assignment assignment;

  const AssignmentDetailsDialog({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    final dueDate = DateTime.parse(assignment.dueDate);
    final now = DateTime.now();
    final isOverdue = dueDate.isBefore(now) && !assignment.isCompleted;
    final daysUntilDue = dueDate.difference(now).inDays;
    
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.book, 'Subject', assignment.subject),
            if (assignment.teacherName != null)
              _buildDetailRow(Icons.person, 'Teacher', assignment.teacherName!),
            if (assignment.className != null)
              _buildDetailRow(Icons.class_, 'Class', assignment.className!),
            _buildDetailRow(
              Icons.schedule,
              'Due Date',
              '${dueDate.day}/${dueDate.month}/${dueDate.year}',
              subtitle: assignment.isCompleted
                  ? 'Completed'
                  : isOverdue 
                      ? 'Overdue'
                      : daysUntilDue == 0 
                          ? 'Due today'
                          : 'Due in $daysUntilDue days',
              subtitleColor: assignment.isCompleted 
                  ? Colors.green 
                  : isOverdue 
                      ? Colors.red 
                      : Colors.orange,
            ),
            if (assignment.points != null)
              _buildDetailRow(Icons.star, 'Points', '${assignment.points}'),
            _buildDetailRow(
              Icons.check_circle,
              'Status',
              assignment.isCompleted ? 'Completed' : 'Pending',
              subtitleColor: assignment.isCompleted ? Colors.green : Colors.orange,
            ),
            if (assignment.description != null && assignment.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Description:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assignment.description!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon, 
    String label, 
    String value, {
    String? subtitle,
    Color? subtitleColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor ?? Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
