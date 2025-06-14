import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/models/user_profile.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../shared/widgets/modern_components.dart';
import 'edit_profile_screen.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final UserProfile userProfile;

  const ProfileDetailsScreen({
    super.key,
    required this.userProfile,
  });

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  late UserProfile _userProfile;
  Map<String, dynamic> _academicStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _loadUserData();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final stats = await FirebaseService.getUserAcademicStats();
      if (mounted) {
        setState(() {
          _academicStats = stats ?? {};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToEditProfile() async {
    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userProfile: _userProfile),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _userProfile = result;
      });
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _navigateToEditProfile,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              _buildProfileHeader(theme),
              const SizedBox(height: 24),

              // Personal Information
              _buildPersonalInfoCard(theme),
              const SizedBox(height: 24),

              // Academic Information
              _buildAcademicInfoCard(theme),
              const SizedBox(height: 24),

              // Academic Statistics
              if (!_isLoading) _buildAcademicStatsCard(theme),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          Hero(
            tag: 'profile-avatar',
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 3),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                backgroundImage: _userProfile.photoUrl != null
                    ? NetworkImage(_userProfile.photoUrl!)
                    : null,
                child: _userProfile.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: theme.colorScheme.primary,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _userProfile.displayName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _userProfile.email,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (_userProfile.academicLevel != 'Not specified') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _userProfile.academicLevel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(ThemeData theme) {
    return ModernCard(
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
          _buildInfoRow(
            context,
            'Full Name',
            _userProfile.name,
            Icons.person_outline,
          ),
          if (_userProfile.phoneNumber != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Phone Number',
              _userProfile.phoneNumber!,
              Icons.phone_outlined,
            ),
          ],
          if (_userProfile.dateOfBirth != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Date of Birth',
              DateFormat('MMM dd, yyyy').format(_userProfile.dateOfBirth!),
              Icons.cake_outlined,
            ),
          ],
          if (_userProfile.address != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Address',
              _userProfile.address!,
              Icons.location_on_outlined,
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            context,
            'Email',
            _userProfile.email,
            Icons.email_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInfoCard(ThemeData theme) {
    return ModernCard(
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
          if (_userProfile.studentId != null) ...[
            _buildInfoRow(
              context,
              'Student ID',
              _userProfile.studentId!,
              Icons.badge_outlined,
            ),
            const SizedBox(height: 12),
          ],
          if (_userProfile.grade != null) ...[
            _buildInfoRow(
              context,
              'Grade Level',
              _userProfile.grade!,
              Icons.school_outlined,
            ),
            const SizedBox(height: 12),
          ],
          if (_userProfile.major != null) ...[
            _buildInfoRow(
              context,
              'Major/Field of Study',
              _userProfile.major!,
              Icons.auto_stories_outlined,
            ),
            const SizedBox(height: 12),
          ],
          if (_userProfile.createdAt != null) ...[
            _buildInfoRow(
              context,
              'Member Since',
              DateFormat('MMM yyyy').format(_userProfile.createdAt!),
              Icons.event_available_outlined,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAcademicStatsCard(ThemeData theme) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic Statistics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Courses',
                  _academicStats['totalCourses']?.toString() ?? '0',
                  Icons.library_books,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Current GPA',
                  _academicStats['currentGPA']?.toStringAsFixed(2) ?? '0.0',
                  Icons.star,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Attendance',
                  _academicStats['attendanceRate'] != null 
                    ? '${_academicStats['attendanceRate'].toStringAsFixed(1)}%'
                    : '0%',
                  Icons.event_available,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  'Assignments',
                  '${_academicStats['completedAssignments'] ?? 0}/${_academicStats['totalAssignments'] ?? 0}',
                  Icons.assignment,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
