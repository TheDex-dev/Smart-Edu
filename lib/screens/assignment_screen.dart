import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'assignment_details_screen.dart';
import 'add_assignment_screen.dart';
import '../widgets/custom_card.dart';
import '../utils/subject_images.dart';
import '../utils/performance_config.dart';
import '../utils/cache_manager.dart';
import '../models/assignment.dart';
import '../services/firebase_service.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key});

  @override
  State<AssignmentScreen> createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen>
    with SingleTickerProviderStateMixin, PerformanceOptimizedMixin, CacheMixin {
  late AnimationController _animationController;

  // Search functionality
  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Filter functionality
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Completed',
    'Pending',
    'Due Today',
    'Overdue',
  ];

  // Cache for animation transitions
  late final Animatable<Offset> _detailsRouteTween = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: Offset.zero,
  ).chain(CurveTween(curve: Curves.easeInOut));

  // To track if the screen is first loaded
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Log screen view
    FirebaseService.logScreenView('assignments_screen');

    // Add a small delay to ensure animations run after widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _isFirstLoad = false);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _toggleAssignmentStatus(Assignment assignment) async {
    try {
      final updatedData = {'isCompleted': !assignment.isCompleted};

      await FirebaseService.updateAssignment(assignment.id, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              assignment.isCompleted
                  ? 'Assignment marked as incomplete'
                  : 'Assignment marked as complete',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating assignment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addNewAssignment(Map<String, dynamic> assignmentData) async {
    try {
      await FirebaseService.addAssignment(assignmentData);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding assignment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;

    if (_searchQuery.isNotEmpty) {
      title = 'No Results Found';
      subtitle = 'Try a different search term';
      icon = Icons.search_off;
    } else if (_selectedFilter != 'All') {
      title = 'No $_selectedFilter Assignments';
      subtitle = 'Try changing the filter';
      icon = Icons.filter_list_off;
    } else {
      title = 'No Assignments Yet';
      subtitle = 'Use the floating action button to add assignments';
      icon = Icons.assignment_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400])
              .animate(target: _isFirstLoad ? 0 : 1)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 16),
          Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              )
              .animate(target: _isFirstLoad ? 0 : 1)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOutQuad,
              ),
          const SizedBox(height: 8),
          Text(
                subtitle,
                style: TextStyle(fontSize: 16, color: Colors.grey[500]),
              )
              .animate(target: _isFirstLoad ? 0 : 1)
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 400.ms,
                curve: Curves.easeOutQuad,
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

  Widget _buildAssignmentCard(Assignment assignment, int index) {
    final bool isCompleted = assignment.isCompleted;
    final String subject = assignment.subject;
    final String dueDate = assignment.dueDate;
    final String description = assignment.description ?? '';

    // Get subject-specific styling
    final String imageUrl = SubjectUtils.getImageForSubject(subject);
    final Color subjectColor = SubjectUtils.getColorForSubject(subject);
    final String formattedDueDate = SubjectUtils.formatDueDate(dueDate);

    // Create subject badge
    final Widget subjectBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SubjectUtils.getTransparentColor(subjectColor, 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SubjectUtils.getTransparentColor(subjectColor, 0.5),
        ),
      ),
      child: Text(
        subject,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: subjectColor,
        ),
      ),
    );

    return CustomCard(
      title: assignment.title,
      subtitle: formattedDueDate,
      description:
          description.isNotEmpty
              ? description.substring(
                    0,
                    description.length > 100 ? 100 : description.length,
                  ) +
                  (description.length > 100 ? '...' : '')
              : null,
      imageUrl: imageUrl,
      isCompleted: isCompleted,
      badges: [subjectBadge],
      onTap: () => _navigateToDetails(context, assignment, index),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => _showOptionsSheet(context, assignment, index),
      ),
    );
  }

  void _showOptionsSheet(
    BuildContext context,
    Assignment assignment,
    int index,
  ) {
    final bool isCompleted = assignment.isCompleted;

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
    Assignment assignment,
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
            _toggleAssignmentStatus(assignment);
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.blue),
          title: const Text('Edit Assignment'),
          onTap: () {
            Navigator.pop(context);
            _editAssignment(assignment, index);
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
            _confirmDelete(context, assignment);
          },
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, Assignment assignment) {
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
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  navigator.pop();
                  try {
                    await FirebaseService.deleteAssignment(assignment.id);
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Assignment deleted')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Text('Error deleting assignment: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  void _navigateToDetails(
    BuildContext context,
    Assignment assignment,
    int index,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => AssignmentDetailsScreen(
              assignment: assignment.toMap()..['id'] = assignment.id,
              onStatusToggle: () => _toggleAssignmentStatus(assignment),
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

  void _editAssignment(Assignment assignment, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddAssignmentScreen(
              onAssignmentAdded:
                  (updatedAssignment) =>
                      _updateAssignment(updatedAssignment, assignment.id),
              assignmentToEdit: assignment.toMap()..['id'] = assignment.id,
            ),
      ),
    );
  }

  Future<void> _updateAssignment(
    Map<String, dynamic> updatedAssignment,
    String assignmentId,
  ) async {
    try {
      // Remove the ID from the update data as it shouldn't be updated
      updatedAssignment.remove('id');
      await FirebaseService.updateAssignment(assignmentId, updatedAssignment);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating assignment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Assignment> _getFilteredAssignments(List<Assignment> assignments) {
    List<Assignment> filtered = List.from(assignments);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((assignment) {
            final title = assignment.title.toLowerCase();
            final subject = assignment.subject.toLowerCase();
            final description = (assignment.description ?? '').toLowerCase();
            final query = _searchQuery.toLowerCase();

            return title.contains(query) ||
                subject.contains(query) ||
                description.contains(query);
          }).toList();
    }

    // Apply status filter
    switch (_selectedFilter) {
      case 'Completed':
        filtered =
            filtered.where((assignment) => assignment.isCompleted).toList();
        break;
      case 'Pending':
        filtered =
            filtered.where((assignment) => !assignment.isCompleted).toList();
        break;
      case 'Due Today':
        final today = DateTime.now();
        filtered =
            filtered.where((assignment) {
              try {
                final date = DateTime.parse(assignment.dueDate);
                return date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
              } catch (e) {
                return false;
              }
            }).toList();
        break;
      case 'Overdue':
        final today = DateTime.now();
        filtered =
            filtered.where((assignment) {
              if (!assignment.isCompleted) {
                try {
                  final date = DateTime.parse(assignment.dueDate);
                  return date.isBefore(today);
                } catch (e) {
                  return false;
                }
              }
              return false;
            }).toList();
        break;
    }

    return filtered;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _showFilterDialog(List<Assignment> assignments) {
    // Calculate counts for each filter
    final Map<String, int> filterCounts = {
      'All': assignments.length,
      'Completed': assignments.where((a) => a.isCompleted).length,
      'Pending': assignments.where((a) => !a.isCompleted).length,
      'Due Today': _getDueTodayCount(assignments),
      'Overdue': _getOverdueCount(assignments),
    };

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filter Assignments'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  _filterOptions.map((filter) {
                    final count = filterCounts[filter] ?? 0;
                    return RadioListTile<String>(
                      title: Row(
                        children: [
                          Expanded(child: Text(filter)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                      value: filter,
                      groupValue: _selectedFilter,
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  int _getDueTodayCount(List<Assignment> assignments) {
    final today = DateTime.now();
    return assignments.where((assignment) {
      try {
        final date = DateTime.parse(assignment.dueDate);
        return date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
      } catch (e) {
        return false;
      }
    }).length;
  }

  int _getOverdueCount(List<Assignment> assignments) {
    final today = DateTime.now();
    return assignments.where((assignment) {
      if (!assignment.isCompleted) {
        try {
          final date = DateTime.parse(assignment.dueDate);
          return date.isBefore(today);
        } catch (e) {
          return false;
        }
      }
      return false;
    }).length;
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Search assignments...',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      autofocus: true,
    );
  }

  Widget _buildActiveFiltersBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (_selectedFilter != 'All') ...[
            Chip(
              label: Text(_selectedFilter),
              onDeleted: () {
                setState(() {
                  _selectedFilter = 'All';
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            const SizedBox(width: 8),
          ],
          if (_searchQuery.isNotEmpty) ...[
            Chip(
              label: Text('Search: "$_searchQuery"'),
              onDeleted: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                });
              },
              deleteIcon: const Icon(Icons.close, size: 16),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : const Text('Assignments'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom:
            _selectedFilter != 'All' || _searchQuery.isNotEmpty
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: _buildActiveFiltersBar(),
                )
                : null,
        actions: [
          FutureBuilder<List<Assignment>>(
            future: FirebaseService.getUserAssignments(),
            builder: (context, snapshot) {
              final assignments =
                  snapshot.hasData ? snapshot.data! : <Assignment>[];

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () => _showFilterDialog(assignments),
                  ),
                  if (_selectedFilter != 'All')
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: FutureBuilder<List<Assignment>>(
        future: FirebaseService.getUserAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final assignments =
              snapshot.hasData ? snapshot.data! : <Assignment>[];

          final filteredAssignments = _getFilteredAssignments(assignments);

          if (filteredAssignments.isEmpty) {
            return _buildEmptyState();
          }

          return _buildAssignmentsList(filteredAssignments);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAssignment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAssignmentsList(List<Assignment> assignments) {
    return ListView.builder(
      itemCount: assignments.length,
      padding: const EdgeInsets.only(bottom: 80), // Space for FAB
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return _buildOptimizedListItem(assignment, index);
      },
    );
  }

  Widget _buildOptimizedListItem(Assignment assignment, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutQuad,
      transform:
          _isFirstLoad
              ? (Matrix4.identity()..translate(0.0, 20.0, 0.0))
              : Matrix4.identity(),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300 + (index * 50)),
        opacity: _isFirstLoad ? 0.0 : 1.0,
        child: _buildAssignmentCard(assignment, index),
      ),
    );
  }
}
