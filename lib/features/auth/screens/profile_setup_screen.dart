import 'package:flutter/material.dart';
import '../models/profile_settings.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../../core/utils/performance_config.dart';

class ProfileSetupScreen extends StatefulWidget {
  final ProfileSettings? existingProfile;
  final bool isInitialSetup;

  const ProfileSetupScreen({
    super.key,
    this.existingProfile,
    this.isInitialSetup = false,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with SingleTickerProviderStateMixin, PerformanceOptimizedMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _hasChanges = false;
  
  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternateEmailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _institutionController = TextEditingController();
  final _departmentController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _officeHoursController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  
  // Form state
  String? _selectedRole;
  String? _selectedGender;
  String? _selectedGrade;
  String? _selectedMajor;
  String? _selectedYearOfStudy;
  String? _selectedEmergencyRelation;
  DateTime? _selectedDateOfBirth;
  int? _yearsOfExperience;
  List<String> _selectedSubjects = [];
  List<String> _selectedSpecializations = [];
  List<String> _selectedCertifications = [];
  
  // Privacy settings
  bool _showEmail = true;
  bool _showPhoneNumber = false;
  bool _showAddress = false;
  bool _allowDirectMessages = true;
  bool _showOnlineStatus = true;
  
  // Notification settings
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _assignmentReminders = true;
  bool _gradeNotifications = true;
  bool _announcementNotifications = true;
  
  // Static options
  final List<String> _roles = ['student', 'teacher', 'professor', 'admin'];
  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _grades = ['9th', '10th', '11th', '12th', 'Undergraduate', 'Graduate', 'PhD'];
  final List<String> _majors = [
    'Computer Science', 'Mathematics', 'Physics', 'Chemistry', 'Biology',
    'English', 'History', 'Geography', 'Economics', 'Business', 'Engineering',
    'Medicine', 'Law', 'Art', 'Music', 'Other'
  ];
  final List<String> _yearsOfStudy = ['1st Year', '2nd Year', '3rd Year', '4th Year', '5th Year+'];
  final List<String> _subjects = [
    'Mathematics', 'Science', 'English', 'History', 'Geography', 'Physics',
    'Chemistry', 'Biology', 'Computer Science', 'Art', 'Music', 'Physical Education',
    'Foreign Languages', 'Economics', 'Business Studies', 'Psychology'
  ];
  final List<String> _emergencyRelations = [
    'Parent', 'Guardian', 'Spouse', 'Sibling', 'Friend', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadExistingProfile();
    
    // Add listeners to detect changes
    _addChangeListeners();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _disposeControllers();
    super.dispose();
  }

  void _addChangeListeners() {
    final controllers = [
      _firstNameController, _lastNameController, _displayNameController,
      _bioController, _phoneController, _alternateEmailController,
      _addressController, _cityController, _stateController,
      _countryController, _postalCodeController, _institutionController,
      _departmentController, _studentIdController, _teacherIdController,
      _qualificationController, _officeLocationController, _officeHoursController,
      _emergencyNameController, _emergencyPhoneController,
    ];

    for (final controller in controllers) {
      controller.addListener(() {
        if (!_hasChanges) {
          setState(() => _hasChanges = true);
        }
      });
    }
  }

  void _disposeControllers() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _alternateEmailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _institutionController.dispose();
    _departmentController.dispose();
    _studentIdController.dispose();
    _teacherIdController.dispose();
    _qualificationController.dispose();
    _officeLocationController.dispose();
    _officeHoursController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
  }

  void _loadExistingProfile() {
    if (widget.existingProfile != null) {
      final profile = widget.existingProfile!;
      
      _firstNameController.text = profile.firstName ?? '';
      _lastNameController.text = profile.lastName ?? '';
      _displayNameController.text = profile.displayName ?? '';
      _bioController.text = profile.bio ?? '';
      _phoneController.text = profile.phoneNumber ?? '';
      _alternateEmailController.text = profile.alternateEmail ?? '';
      _addressController.text = profile.address ?? '';
      _cityController.text = profile.city ?? '';
      _stateController.text = profile.state ?? '';
      _countryController.text = profile.country ?? '';
      _postalCodeController.text = profile.postalCode ?? '';
      _institutionController.text = profile.institutionName ?? '';
      _departmentController.text = profile.department ?? '';
      _studentIdController.text = profile.studentId ?? '';
      _teacherIdController.text = profile.teacherId ?? '';
      _qualificationController.text = profile.qualification ?? '';
      _officeLocationController.text = profile.officeLocation ?? '';
      _officeHoursController.text = profile.officeHours ?? '';
      _emergencyNameController.text = profile.emergencyContactName ?? '';
      _emergencyPhoneController.text = profile.emergencyContactPhone ?? '';
      
      _selectedRole = profile.role;
      _selectedGender = profile.gender;
      _selectedGrade = profile.grade;
      _selectedMajor = profile.major;
      _selectedYearOfStudy = profile.yearOfStudy;
      _selectedEmergencyRelation = profile.emergencyContactRelation;
      _selectedDateOfBirth = profile.dateOfBirth;
      _yearsOfExperience = profile.yearsOfExperience;
      _selectedSubjects = profile.subjects ?? [];
      _selectedSpecializations = profile.specializations ?? [];
      _selectedCertifications = profile.certifications ?? [];
      
      _showEmail = profile.showEmail;
      _showPhoneNumber = profile.showPhoneNumber;
      _showAddress = profile.showAddress;
      _allowDirectMessages = profile.allowDirectMessages;
      _showOnlineStatus = profile.showOnlineStatus;
      
      _emailNotifications = profile.emailNotifications;
      _pushNotifications = profile.pushNotifications;
      _assignmentReminders = profile.assignmentReminders;
      _gradeNotifications = profile.gradeNotifications;
      _announcementNotifications = profile.announcementNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isInitialSetup ? 'Profile Setup' : 'Edit Profile'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.onPrimary,
          unselectedLabelColor: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          indicatorColor: theme.colorScheme.onPrimary,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Personal'),
            Tab(icon: Icon(Icons.school), text: 'Academic'),
            Tab(icon: Icon(Icons.security), text: 'Privacy'),
            Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
          ],
        ),
        actions: [
          if (!widget.isInitialSetup)
            TextButton(
              onPressed: _hasChanges ? _saveProfile : null,
              child: Text(
                'Save',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildPersonalTab(),
            _buildAcademicTab(),
            _buildPrivacyTab(),
            _buildNotificationsTab(),
          ],
        ),
      ),
      bottomNavigationBar: widget.isInitialSetup ? _buildBottomBar() : null,
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_tabController.index > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => _tabController.animateTo(_tabController.index - 1),
                child: const Text('Previous'),
              ),
            ),
          if (_tabController.index > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleNextOrComplete,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_tabController.index == 3 ? 'Complete Setup' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information', Icons.person),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'First name is required' : null,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Last name is required' : null,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _displayNameController,
            decoration: const InputDecoration(
              labelText: 'Display Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.badge),
              helperText: 'How others will see your name',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
              helperText: 'Tell us about yourself',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.wc),
            ),
            items: _genders.map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender));
            }).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
          ),
          
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Date of Birth'),
            subtitle: Text(
              _selectedDateOfBirth != null
                  ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                  : 'Select your birth date',
            ),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: _selectDateOfBirth,
            contentPadding: EdgeInsets.zero,
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Contact Information', Icons.contact_phone),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Phone number is required' : null,
            keyboardType: TextInputType.phone,
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _alternateEmailController,
            decoration: const InputDecoration(
              labelText: 'Alternate Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.alternate_email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Address', Icons.location_on),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Street Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.home),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State/Province',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Emergency Contact', Icons.emergency),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _emergencyNameController,
            decoration: const InputDecoration(
              labelText: 'Emergency Contact Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emergencyPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Phone',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedEmergencyRelation,
                  decoration: const InputDecoration(
                    labelText: 'Relation',
                    border: OutlineInputBorder(),
                  ),
                  items: _emergencyRelations.map((relation) {
                    return DropdownMenuItem(value: relation, child: Text(relation));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedEmergencyRelation = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Role & Institution', Icons.school),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: const InputDecoration(
              labelText: 'Role *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_pin),
            ),
            validator: (value) => value == null ? 'Role is required' : null,
            items: _roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedRole = value),
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _institutionController,
            decoration: const InputDecoration(
              labelText: 'Institution Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.account_balance),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            controller: _departmentController,
            decoration: const InputDecoration(
              labelText: 'Department/Faculty',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.business),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          
          if (_selectedRole == 'student') ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Student Information', Icons.school),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGrade,
                    decoration: const InputDecoration(
                      labelText: 'Grade/Level',
                      border: OutlineInputBorder(),
                    ),
                    items: _grades.map((grade) {
                      return DropdownMenuItem(value: grade, child: Text(grade));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedGrade = value),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedMajor,
                    decoration: const InputDecoration(
                      labelText: 'Major/Subject',
                      border: OutlineInputBorder(),
                    ),
                    items: _majors.map((major) {
                      return DropdownMenuItem(value: major, child: Text(major));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedMajor = value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedYearOfStudy,
                    decoration: const InputDecoration(
                      labelText: 'Year of Study',
                      border: OutlineInputBorder(),
                    ),
                    items: _yearsOfStudy.map((year) {
                      return DropdownMenuItem(value: year, child: Text(year));
                    }).toList(),
                    onChanged: (value) => setState(() => _selectedYearOfStudy = value),
                  ),
                ),
              ],
            ),
          ],
          
          if (_selectedRole == 'teacher' || _selectedRole == 'professor') ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Teaching Information', Icons.school),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _teacherIdController,
                    decoration: const InputDecoration(
                      labelText: 'Teacher/Employee ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _qualificationController,
                    decoration: const InputDecoration(
                      labelText: 'Highest Qualification',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Years of Experience',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => _yearsOfExperience = int.tryParse(value),
            ),
            
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _officeLocationController,
                    decoration: const InputDecoration(
                      labelText: 'Office Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _officeHoursController,
                    decoration: const InputDecoration(
                      labelText: 'Office Hours',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.schedule),
                    ),
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: 24),
          _buildSectionHeader('Subjects & Specializations', Icons.book),
          const SizedBox(height: 16),
          
          _buildMultiSelectChips(
            'Subjects',
            _subjects,
            _selectedSubjects,
            (selected) => setState(() => _selectedSubjects = selected),
          ),
          
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Specializations (comma separated)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.star),
              helperText: 'Enter your areas of specialization',
            ),
            onChanged: (value) {
              _selectedSpecializations = value
                  .split(',')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Profile Visibility', Icons.visibility),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Show Email Address'),
            subtitle: const Text('Others can see your email'),
            value: _showEmail,
            onChanged: (value) => setState(() => _showEmail = value),
            secondary: const Icon(Icons.email),
          ),
          
          SwitchListTile(
            title: const Text('Show Phone Number'),
            subtitle: const Text('Others can see your phone number'),
            value: _showPhoneNumber,
            onChanged: (value) => setState(() => _showPhoneNumber = value),
            secondary: const Icon(Icons.phone),
          ),
          
          SwitchListTile(
            title: const Text('Show Address'),
            subtitle: const Text('Others can see your address'),
            value: _showAddress,
            onChanged: (value) => setState(() => _showAddress = value),
            secondary: const Icon(Icons.location_on),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Communication', Icons.message),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Allow Direct Messages'),
            subtitle: const Text('Others can send you direct messages'),
            value: _allowDirectMessages,
            onChanged: (value) => setState(() => _allowDirectMessages = value),
            secondary: const Icon(Icons.message),
          ),
          
          SwitchListTile(
            title: const Text('Show Online Status'),
            subtitle: const Text('Others can see when you\'re online'),
            value: _showOnlineStatus,
            onChanged: (value) => setState(() => _showOnlineStatus = value),
            secondary: const Icon(Icons.circle),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('General Notifications', Icons.notifications),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive notifications via email'),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            secondary: const Icon(Icons.email),
          ),
          
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive push notifications on your device'),
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            secondary: const Icon(Icons.notifications_active),
          ),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Academic Notifications', Icons.school),
          const SizedBox(height: 16),
          
          SwitchListTile(
            title: const Text('Assignment Reminders'),
            subtitle: const Text('Get reminders about upcoming assignments'),
            value: _assignmentReminders,
            onChanged: (value) => setState(() => _assignmentReminders = value),
            secondary: const Icon(Icons.assignment),
          ),
          
          SwitchListTile(
            title: const Text('Grade Notifications'),
            subtitle: const Text('Get notified when grades are posted'),
            value: _gradeNotifications,
            onChanged: (value) => setState(() => _gradeNotifications = value),
            secondary: const Icon(Icons.grade),
          ),
          
          SwitchListTile(
            title: const Text('Announcement Notifications'),
            subtitle: const Text('Get notified about important announcements'),
            value: _announcementNotifications,
            onChanged: (value) => setState(() => _announcementNotifications = value),
            secondary: const Icon(Icons.campaign),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectChips(
    String label,
    List<String> options,
    List<String> selected,
    Function(List<String>) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return            FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (isOptionSelected) {
                final newSelected = List<String>.from(selected);
                if (isOptionSelected) {
                  newSelected.add(option);
                } else {
                  newSelected.remove(option);
                }
                onChanged(newSelected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDateOfBirth() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() => _selectedDateOfBirth = date);
    }
  }

  void _handleNextOrComplete() {
    if (_tabController.index < 3) {
      _tabController.animateTo(_tabController.index + 1);
    } else {
      _completeSetup();
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) {
      // Show validation errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final profile = ProfileSettings(
        id: widget.existingProfile?.id ?? '',
        userId: '', // Will be set by Firebase service
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        displayName: _displayNameController.text.trim().isEmpty 
            ? null 
            : _displayNameController.text.trim(),
        bio: _bioController.text.trim().isEmpty 
            ? null 
            : _bioController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        gender: _selectedGender,
        phoneNumber: _phoneController.text.trim(),
        alternateEmail: _alternateEmailController.text.trim().isEmpty 
            ? null 
            : _alternateEmailController.text.trim(),
        address: _addressController.text.trim().isEmpty 
            ? null 
            : _addressController.text.trim(),
        city: _cityController.text.trim().isEmpty 
            ? null 
            : _cityController.text.trim(),
        state: _stateController.text.trim().isEmpty 
            ? null 
            : _stateController.text.trim(),
        country: _countryController.text.trim().isEmpty 
            ? null 
            : _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim().isEmpty 
            ? null 
            : _postalCodeController.text.trim(),
        role: _selectedRole,
        institutionName: _institutionController.text.trim().isEmpty 
            ? null 
            : _institutionController.text.trim(),
        department: _departmentController.text.trim().isEmpty 
            ? null 
            : _departmentController.text.trim(),
        grade: _selectedGrade,
        major: _selectedMajor,
        studentId: _studentIdController.text.trim().isEmpty 
            ? null 
            : _studentIdController.text.trim(),
        teacherId: _teacherIdController.text.trim().isEmpty 
            ? null 
            : _teacherIdController.text.trim(),
        yearOfStudy: _selectedYearOfStudy,
        subjects: _selectedSubjects.isEmpty ? null : _selectedSubjects,
        specializations: _selectedSpecializations.isEmpty ? null : _selectedSpecializations,
        qualification: _qualificationController.text.trim().isEmpty 
            ? null 
            : _qualificationController.text.trim(),
        yearsOfExperience: _yearsOfExperience,
        certifications: _selectedCertifications.isEmpty ? null : _selectedCertifications,
        officeLocation: _officeLocationController.text.trim().isEmpty 
            ? null 
            : _officeLocationController.text.trim(),
        officeHours: _officeHoursController.text.trim().isEmpty 
            ? null 
            : _officeHoursController.text.trim(),
        showEmail: _showEmail,
        showPhoneNumber: _showPhoneNumber,
        showAddress: _showAddress,
        allowDirectMessages: _allowDirectMessages,
        showOnlineStatus: _showOnlineStatus,
        emailNotifications: _emailNotifications,
        pushNotifications: _pushNotifications,
        assignmentReminders: _assignmentReminders,
        gradeNotifications: _gradeNotifications,
        announcementNotifications: _announcementNotifications,
        emergencyContactName: _emergencyNameController.text.trim().isEmpty 
            ? null 
            : _emergencyNameController.text.trim(),
        emergencyContactPhone: _emergencyPhoneController.text.trim().isEmpty 
            ? null 
            : _emergencyPhoneController.text.trim(),
        emergencyContactRelation: _selectedEmergencyRelation,
        isProfileComplete: true,
      );

      if (widget.existingProfile != null) {
        await FirebaseService.updateProfileSettings(profile);
      } else {
        await FirebaseService.createProfileSettings(profile);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isInitialSetup 
                  ? 'Profile setup completed successfully!' 
                  : 'Profile updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.isInitialSetup) {
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    await _completeSetup();
  }
}
