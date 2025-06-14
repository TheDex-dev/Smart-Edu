import 'package:flutter/material.dart';
import '../../../../features/assignments/models/assignment.dart';
import '../../../../shared/models/user_profile.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/performance_config.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  const TeacherAssignmentScreen({super.key});

  @override
  State<TeacherAssignmentScreen> createState() => _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen>
    with SingleTickerProviderStateMixin, PerformanceOptimizedMixin {
  late AnimationController _animationController;
  
  List<Assignment> _teacherAssignments = [];
  List<UserProfile> _students = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedSubject = 'All';
  
  final List<String> _subjects = [
    'All',
    'Mathematics',
    'Science',
    'English',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadTeacherData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTeacherData() async {
    setState(() => _isLoading = true);
    
    try {
      // Load assignments created by this teacher
      final assignments = await FirebaseService.getTeacherAssignments();
      
      // Load students for assignment distribution
      final students = await FirebaseService.getStudents();
      
      setState(() {
        _teacherAssignments = assignments;
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  List<Assignment> get _filteredAssignments {
    return _teacherAssignments.where((assignment) {
      final matchesSearch = assignment.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          assignment.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesSubject = _selectedSubject == 'All' || assignment.subject == _selectedSubject;
      return matchesSearch && matchesSubject;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTeacherData,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAssignmentDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Create Assignment'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
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
              children: _subjects.map((subject) {
                final isSelected = _selectedSubject == subject;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(subject),
                    onSelected: (selected) {
                      setState(() => _selectedSubject = subject);
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
    final totalAssignments = _teacherAssignments.length;
    final activeAssignments = _teacherAssignments.where((a) => 
        DateTime.parse(a.dueDate).isAfter(DateTime.now())).length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Total', totalAssignments.toString(), Icons.assignment),
          _buildStatCard('Active', activeAssignments.toString(), Icons.schedule),
          _buildStatCard('Students', _students.length.toString(), Icons.people),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
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
              'No assignments found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first assignment to get started',
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
    final isOverdue = dueDate.isBefore(DateTime.now());
    final daysUntilDue = dueDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isOverdue ? Colors.red.shade100 : Colors.blue.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.assignment,
            color: isOverdue ? Colors.red : Colors.blue,
          ),
        ),
        title: Text(
          assignment.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(assignment.subject),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  isOverdue 
                      ? 'Overdue'
                      : daysUntilDue == 0 
                          ? 'Due today'
                          : 'Due in $daysUntilDue days',
                  style: TextStyle(
                    color: isOverdue ? Colors.red : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (assignment.assignedTo != null && assignment.assignedTo!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${assignment.assignedTo!.length} students',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'distribute',
              child: Row(
                children: [
                  Icon(Icons.send),
                  SizedBox(width: 8),
                  Text('Distribute'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                _showEditAssignmentDialog(assignment);
                break;
              case 'distribute':
                _showDistributeDialog(assignment);
                break;
              case 'delete':
                _showDeleteConfirmation(assignment);
                break;
            }
          },
        ),
      ),
    );
  }

  void _showCreateAssignmentDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateAssignmentDialog(
        students: _students,
        onAssignmentCreated: () {
          _loadTeacherData();
        },
      ),
    );
  }

  void _showEditAssignmentDialog(Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => CreateAssignmentDialog(
        assignment: assignment,
        students: _students,
        onAssignmentCreated: () {
          _loadTeacherData();
        },
      ),
    );
  }

  void _showDistributeDialog(Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => DistributeAssignmentDialog(
        assignment: assignment,
        students: _students,
        onDistributed: () {
          _loadTeacherData();
        },
      ),
    );
  }

  void _showDeleteConfirmation(Assignment assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to delete "${assignment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final messenger = ScaffoldMessenger.of(context);
              try {
                await FirebaseService.deleteAssignment(assignment.id);
                _loadTeacherData();
                if (mounted) {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Assignment deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Error deleting assignment: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class CreateAssignmentDialog extends StatefulWidget {
  final Assignment? assignment;
  final List<UserProfile> students;
  final VoidCallback onAssignmentCreated;

  const CreateAssignmentDialog({
    super.key,
    this.assignment,
    required this.students,
    required this.onAssignmentCreated,
  });

  @override
  State<CreateAssignmentDialog> createState() => _CreateAssignmentDialogState();
}

class _CreateAssignmentDialogState extends State<CreateAssignmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _classController = TextEditingController();
  
  String _selectedSubject = 'Mathematics';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));
  List<String> _selectedStudents = [];
  bool _isLoading = false;

  final List<String> _subjects = [
    'Mathematics',
    'Science',
    'English',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.assignment != null) {
      final assignment = widget.assignment!;
      _titleController.text = assignment.title;
      _descriptionController.text = assignment.description ?? '';
      _pointsController.text = assignment.points?.toString() ?? '';
      _classController.text = assignment.className ?? '';
      _selectedSubject = assignment.subject;
      _dueDate = DateTime.parse(assignment.dueDate);
      _selectedStudents = List.from(assignment.assignedTo ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.assignment != null ? 'Edit Assignment' : 'Create Assignment',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Assignment Title *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Title is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedSubject,
                        decoration: const InputDecoration(
                          labelText: 'Subject *',
                          border: OutlineInputBorder(),
                        ),
                        items: _subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedSubject = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _pointsController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Points',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _classController,
                              decoration: const InputDecoration(
                                labelText: 'Class/Grade',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('Due Date'),
                        subtitle: Text(
                          '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _selectDueDate,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Assign to Students:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: widget.students.isEmpty
                            ? const Center(child: Text('No students available'))
                            : ListView.builder(
                                itemCount: widget.students.length,
                                itemBuilder: (context, index) {
                                  final student = widget.students[index];
                                  final isSelected = _selectedStudents.contains(student.id);
                                  
                                  return CheckboxListTile(
                                    title: Text(student.name),
                                    subtitle: Text(student.email),
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedStudents.add(student.id);
                                        } else {
                                          _selectedStudents.remove(student.id);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveAssignment,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.assignment != null ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() => _dueDate = date);
    }
  }

  Future<void> _saveAssignment() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      final teacherProfile = await FirebaseService.getCurrentUserProfile();
      
      final assignment = Assignment(
        id: widget.assignment?.id ?? '',
        title: _titleController.text.trim(),
        subject: _selectedSubject,
        dueDate: _dueDate.toIso8601String(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        points: _pointsController.text.trim().isEmpty 
            ? null 
            : int.tryParse(_pointsController.text.trim()),
        className: _classController.text.trim().isEmpty 
            ? null 
            : _classController.text.trim(),
        teacherId: teacherProfile?.id,
        teacherName: teacherProfile?.name,
        assignedTo: _selectedStudents.isEmpty ? null : _selectedStudents,
        createdAt: widget.assignment?.createdAt ?? DateTime.now(),
      );
      
      if (widget.assignment != null) {
        await FirebaseService.updateAssignment(assignment.id, assignment);
      } else {
        await FirebaseService.addAssignment(assignment);
      }
      
      widget.onAssignmentCreated();
      navigator.pop();
      
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              widget.assignment != null 
                  ? 'Assignment updated successfully'
                  : 'Assignment created successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class DistributeAssignmentDialog extends StatefulWidget {
  final Assignment assignment;
  final List<UserProfile> students;
  final VoidCallback onDistributed;

  const DistributeAssignmentDialog({
    super.key,
    required this.assignment,
    required this.students,
    required this.onDistributed,
  });

  @override
  State<DistributeAssignmentDialog> createState() => _DistributeAssignmentDialogState();
}

class _DistributeAssignmentDialogState extends State<DistributeAssignmentDialog> {
  List<String> _selectedStudents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedStudents = List.from(widget.assignment.assignedTo ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Distribute Assignment'),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: widget.students.isEmpty
            ? const Center(child: Text('No students available'))
            : ListView.builder(
                itemCount: widget.students.length,
                itemBuilder: (context, index) {
                  final student = widget.students[index];
                  final isSelected = _selectedStudents.contains(student.id);
                  
                  return CheckboxListTile(
                    title: Text(student.name),
                    subtitle: Text(student.email),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedStudents.add(student.id);
                        } else {
                          _selectedStudents.remove(student.id);
                        }
                      });
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _distributeAssignment,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Distribute'),
        ),
      ],
    );
  }

  Future<void> _distributeAssignment() async {
    setState(() => _isLoading = true);
    
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      final updatedAssignment = widget.assignment.copyWith(
        assignedTo: _selectedStudents,
      );
      
      await FirebaseService.updateAssignment(widget.assignment.id, updatedAssignment);
      
      navigator.pop();
      widget.onDistributed();
      
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Assignment distributed to ${_selectedStudents.length} students'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Error distributing assignment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
