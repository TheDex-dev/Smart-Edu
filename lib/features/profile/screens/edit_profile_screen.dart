import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/user_profile.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../shared/widgets/modern_components.dart';
import '../../../core/data/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile userProfile;

  const EditProfileScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _studentIdController;

  String? _selectedGrade;
  String? _selectedMajor;
  DateTime? _dateOfBirth;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _grades = MockData.grades;

  final List<String> _majors = MockData.majors;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.userProfile.name);
    _phoneController = TextEditingController(text: widget.userProfile.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.userProfile.address ?? '');
    _studentIdController = TextEditingController(text: widget.userProfile.studentId ?? '');

    _selectedGrade = widget.userProfile.grade;
    _selectedMajor = widget.userProfile.major;
    _dateOfBirth = widget.userProfile.dateOfBirth;

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _studentIdController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = widget.userProfile.copyWith(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        studentId: _studentIdController.text.trim().isEmpty ? null : _studentIdController.text.trim(),
        grade: _selectedGrade,
        major: _selectedMajor,
        dateOfBirth: _dateOfBirth,
      );

      await FirebaseService.updateUserProfile(updatedProfile.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context, updatedProfile);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              tooltip: 'Save Changes',
            ),
        ],
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
                // Profile Picture Section
                _buildProfilePictureSection(theme),
                const SizedBox(height: 32),

                // Personal Information
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildPhoneField(),
                      const SizedBox(height: 16),
                      _buildDateOfBirthField(),
                      const SizedBox(height: 16),
                      _buildAddressField(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Academic Information
                ModernCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStudentIdField(),
                      const SizedBox(height: 16),
                      _buildGradeField(),
                      const SizedBox(height: 16),
                      _buildMajorField(),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                _buildSaveButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.primary, width: 3),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  backgroundImage: widget.userProfile.photoUrl != null
                      ? NetworkImage(widget.userProfile.photoUrl!)
                      : null,
                  child: widget.userProfile.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.colorScheme.surface, width: 2),
                  ),
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Photo upload will be available soon'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tap to change photo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone Number (Optional)',
        prefixIcon: Icon(Icons.phone_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 10) {
          return 'Please enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date of Birth (Optional)',
          prefixIcon: Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(),
        ),
        child: Text(
          _dateOfBirth != null
              ? DateFormat('MMM dd, yyyy').format(_dateOfBirth!)
              : 'Select date',
          style: _dateOfBirth != null
              ? null
              : TextStyle(color: Theme.of(context).hintColor),
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Address (Optional)',
        prefixIcon: Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
    );
  }

  Widget _buildStudentIdField() {
    return TextFormField(
      controller: _studentIdController,
      decoration: const InputDecoration(
        labelText: 'Student ID (Optional)',
        prefixIcon: Icon(Icons.badge_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGradeField() {
    return DropdownButtonFormField<String>(
      value: _selectedGrade,
      decoration: const InputDecoration(
        labelText: 'Grade Level (Optional)',
        prefixIcon: Icon(Icons.school_outlined),
        border: OutlineInputBorder(),
      ),
      items: _grades.map((String grade) {
        return DropdownMenuItem<String>(
          value: grade,
          child: Text(grade),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGrade = newValue;
        });
      },
    );
  }

  Widget _buildMajorField() {
    return DropdownButtonFormField<String>(
      value: _selectedMajor,
      decoration: const InputDecoration(
        labelText: 'Major/Field of Study (Optional)',
        prefixIcon: Icon(Icons.auto_stories_outlined),
        border: OutlineInputBorder(),
      ),
      items: _majors.map((String major) {
        return DropdownMenuItem<String>(
          value: major,
          child: Text(major),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedMajor = newValue;
        });
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
