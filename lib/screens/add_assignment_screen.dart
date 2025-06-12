import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAssignmentScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onAssignmentAdded;
  final Map<String, dynamic>? assignmentToEdit;

  const AddAssignmentScreen({
    super.key,
    required this.onAssignmentAdded,
    this.assignmentToEdit,
  });

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _dueDate;

  // Animation controller for subtle effects
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Cache theme values
  late final Color _primaryColor;

  // Pre-defined list of subjects
  static const List<String> _subjects = [
    'Mathematics',
    'Science',
    'History',
    'Literature',
    'Computer Science',
    'Physics',
    'Chemistry',
    'Biology',
    'Geography',
    'Art',
    'Music',
    'Physical Education',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    // Set up animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward();

    // Initialize with default values or values from assignmentToEdit
    _dueDate = DateTime.now().add(const Duration(days: 7));

    // If we're editing an existing assignment, populate the form
    if (widget.assignmentToEdit != null) {
      _titleController.text = widget.assignmentToEdit!['title'] ?? '';
      _subjectController.text = widget.assignmentToEdit!['subject'] ?? '';
      _descriptionController.text =
          widget.assignmentToEdit!['description'] ?? '';

      // Parse the due date if available
      if (widget.assignmentToEdit!['dueDate'] != null) {
        try {
          _dueDate = DateFormat(
            'yyyy-MM-dd',
          ).parse(widget.assignmentToEdit!['dueDate']);
        } catch (e) {
          // Keep default date if parsing fails
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Cache theme-dependent values
    _primaryColor = Theme.of(context).colorScheme.primary;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(colorScheme: ColorScheme.light(primary: _primaryColor)),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final assignment = {
        'title': _titleController.text.trim(),
        'subject': _subjectController.text.trim(),
        'description': _descriptionController.text.trim(),
        'dueDate': DateFormat('yyyy-MM-dd').format(_dueDate),
        'isCompleted':
            widget.assignmentToEdit != null
                ? widget.assignmentToEdit!['isCompleted'] ?? false
                : false,
      };

      // If editing, preserve the original ID
      if (widget.assignmentToEdit != null &&
          widget.assignmentToEdit!.containsKey('id')) {
        assignment['id'] = widget.assignmentToEdit!['id'];
      }

      // Play a subtle animation before submitting
      _animationController.reverse().then((_) {
        widget.onAssignmentAdded(assignment);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.assignmentToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Assignment' : 'Add Assignment'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleField(),
                const SizedBox(height: 16),
                _buildSubjectField(),
                const SizedBox(height: 16),
                _buildDueDateField(),
                const SizedBox(height: 16),
                _buildDescriptionField(),
                const SizedBox(height: 32),
                _buildSubmitButton(isEditing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        labelText: 'Title',
        hintText: 'Enter assignment title',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildSubjectField() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return _subjects.where((String subject) {
          return subject.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      onSelected: (String selection) {
        _subjectController.text = selection;
      },
      fieldViewBuilder: (
        BuildContext context,
        TextEditingController controller,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted,
      ) {
        // Sync controllers
        if (_subjectController.text.isNotEmpty && controller.text.isEmpty) {
          controller.text = _subjectController.text;
        }

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            labelText: 'Subject',
            hintText: 'Enter or select a subject',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.subject),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a subject';
            }
            return null;
          },
          onChanged: (value) {
            _subjectController.text = value;
          },
        );
      },
    );
  }

  Widget _buildDueDateField() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('yyyy-MM-dd').format(_dueDate),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
      ),
      decoration: const InputDecoration(
        labelText: 'Description (Optional)',
        hintText: 'Enter details about the assignment',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 5,
    );
  }

  Widget _buildSubmitButton(bool isEditing) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
        ),
        child: Text(
          isEditing ? 'Update Assignment' : 'Add Assignment',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
