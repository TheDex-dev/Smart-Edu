import 'package:flutter/material.dart';
import '../../auth/models/profile_settings.dart';
import '../../../core/services/firebase_service.dart';
import '../../auth/screens/profile_setup_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  ProfileSettings? _profileSettings;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfileSettings();
  }

  Future<void> _loadProfileSettings() async {
    try {
      final profileSettings = await FirebaseService.getProfileSettings();
      
      setState(() {
        _profileSettings = profileSettings;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        actions: [
          if (_profileSettings != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editProfile,
              tooltip: 'Edit Profile',
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _profileSettings == null
          ? FloatingActionButton.extended(
              onPressed: _createProfile,
              icon: const Icon(Icons.add),
              label: const Text('Setup Profile'),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profile settings...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfileSettings,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_profileSettings == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No Profile Setup',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your detailed profile to get the most out of Smart Edu.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createProfile,
              icon: const Icon(Icons.add),
              label: const Text('Setup Profile'),
            ),
          ],
        ),
      );
    }

    return _buildProfileDetails();
  }

  Widget _buildProfileDetails() {
    final profile = _profileSettings!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile completion card
          _buildCompletionCard(profile),
          const SizedBox(height: 20),
          
          // Personal information section
          _buildSection(
            'Personal Information',
            Icons.person,
            [
              _buildInfoRow('Full Name', profile.fullName),
              if (profile.displayName != null && profile.displayName != profile.fullName)
                _buildInfoRow('Display Name', profile.displayName!),
              if (profile.bio != null) _buildInfoRow('Bio', profile.bio!),
              if (profile.dateOfBirth != null)
                _buildInfoRow('Date of Birth', _formatDate(profile.dateOfBirth!)),
              if (profile.gender != null) _buildInfoRow('Gender', profile.gender!),
            ],
          ),
          
          // Contact information section
          _buildSection(
            'Contact Information',
            Icons.contact_phone,
            [
              if (profile.phoneNumber != null) _buildInfoRow('Phone', profile.phoneNumber!),
              if (profile.alternateEmail != null) _buildInfoRow('Alternate Email', profile.alternateEmail!),
              if (profile.address != null) _buildInfoRow('Address', _buildFullAddress(profile)),
            ],
          ),
          
          // Academic information section
          _buildSection(
            'Academic Information',
            Icons.school,
            [
              if (profile.role != null) _buildInfoRow('Role', profile.role!.toUpperCase()),
              if (profile.institutionName != null) _buildInfoRow('Institution', profile.institutionName!),
              if (profile.department != null) _buildInfoRow('Department', profile.department!),
              if (profile.grade != null) _buildInfoRow('Grade/Level', profile.grade!),
              if (profile.major != null) _buildInfoRow('Major', profile.major!),
              if (profile.studentId != null) _buildInfoRow('Student ID', profile.studentId!),
              if (profile.teacherId != null) _buildInfoRow('Teacher ID', profile.teacherId!),
              if (profile.yearOfStudy != null) _buildInfoRow('Year of Study', profile.yearOfStudy!),
            ],
          ),
          
          // Professional information (for teachers)
          if (profile.role == 'teacher' || profile.role == 'professor') ...[
            _buildSection(
              'Professional Information',
              Icons.work,
              [
                if (profile.qualification != null) _buildInfoRow('Qualification', profile.qualification!),
                if (profile.yearsOfExperience != null) 
                  _buildInfoRow('Experience', '${profile.yearsOfExperience} years'),
                if (profile.officeLocation != null) _buildInfoRow('Office', profile.officeLocation!),
                if (profile.officeHours != null) _buildInfoRow('Office Hours', profile.officeHours!),
              ],
            ),
          ],
          
          // Subjects and specializations
          if (profile.subjects != null && profile.subjects!.isNotEmpty) ...[
            _buildSection(
              'Subjects',
              Icons.book,
              [
                _buildChipsList(profile.subjects!),
              ],
            ),
          ],
          
          if (profile.specializations != null && profile.specializations!.isNotEmpty) ...[
            _buildSection(
              'Specializations',
              Icons.star,
              [
                _buildChipsList(profile.specializations!),
              ],
            ),
          ],
          
          // Emergency contact
          if (profile.emergencyContactName != null) ...[
            _buildSection(
              'Emergency Contact',
              Icons.emergency,
              [
                _buildInfoRow('Name', profile.emergencyContactName!),
                if (profile.emergencyContactPhone != null)
                  _buildInfoRow('Phone', profile.emergencyContactPhone!),
                if (profile.emergencyContactRelation != null)
                  _buildInfoRow('Relation', profile.emergencyContactRelation!),
              ],
            ),
          ],
          
          // Privacy settings
          _buildSection(
            'Privacy Settings',
            Icons.security,
            [
              _buildSwitchRow('Show Email', profile.showEmail),
              _buildSwitchRow('Show Phone', profile.showPhoneNumber),
              _buildSwitchRow('Show Address', profile.showAddress),
              _buildSwitchRow('Allow Direct Messages', profile.allowDirectMessages),
              _buildSwitchRow('Show Online Status', profile.showOnlineStatus),
            ],
          ),
          
          // Notification settings
          _buildSection(
            'Notification Settings',
            Icons.notifications,
            [
              _buildSwitchRow('Email Notifications', profile.emailNotifications),
              _buildSwitchRow('Push Notifications', profile.pushNotifications),
              _buildSwitchRow('Assignment Reminders', profile.assignmentReminders),
              _buildSwitchRow('Grade Notifications', profile.gradeNotifications),
              _buildSwitchRow('Announcements', profile.announcementNotifications),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _editProfile,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showDeleteConfirmation,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(ProfileSettings profile) {
    final completionPercentage = profile.completionPercentage;
    final color = completionPercentage >= 0.8 
        ? Colors.green 
        : completionPercentage >= 0.5 
            ? Colors.orange 
            : Colors.red;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, color: color, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Completion',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${(completionPercentage * 100).toInt()}% Complete',
                        style: TextStyle(color: color, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: completionPercentage,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
            if (completionPercentage < 1.0) ...[
              const SizedBox(height: 8),
              Text(
                'Complete your profile to unlock all features',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildChipsList(List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items.map((item) {
        return Chip(
          label: Text(item),
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _buildFullAddress(ProfileSettings profile) {
    final parts = [
      profile.address,
      profile.city,
      profile.state,
      profile.country,
      profile.postalCode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    
    return parts.join(', ');
  }

  void _createProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileSetupScreen(isInitialSetup: true),
      ),
    ).then((result) {
      if (result == true) {
        _loadProfileSettings();
      }
    });
  }

  void _editProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(
          existingProfile: _profileSettings,
          isInitialSetup: false,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadProfileSettings();
      }
    });
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text(
          'Are you sure you want to delete your profile settings? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteProfile();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProfile() async {
    try {
      await FirebaseService.deleteProfileSettings();
      
      setState(() {
        _profileSettings = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
