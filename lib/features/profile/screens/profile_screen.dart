import 'package:flutter/material.dart';
import '../../auth/models/auth.dart';
import '../../../shared/models/user_profile.dart';
import '../../settings/screens/settings_screen.dart';
import 'edit_profile_screen.dart';
import '../../academic/screens/academic_info_screen.dart';
import '../../academic/screens/performance_screen.dart';
import '../../academic/screens/schedule_screen.dart';
import '../../academic/screens/academic_stats_screen.dart';
import 'profile_details_screen.dart';
import 'profile_settings_screen.dart';
import '../../../core/constants/subject_images.dart';
import '../../../core/services/firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _avatarAnimation;
  late Animation<double> _infoAnimation;
  late Animation<double> _listAnimation;

  // Cache for frequently used values
  late final String _userName;
  late final String _userEmail;
  UserProfile? _userProfile;
  Map<String, dynamic> _academicStats = {};
  bool _isLoading = true;

  // Cache for animations
  late final Animatable<Offset> _infoSlideOffset;
  late final Animatable<Offset> _menuItemsOffset;
  late final Animatable<Offset> _settingsRouteOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _avatarAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _infoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );

    _listAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    // Initialize cache
    _userName = Auth.userName ?? Auth.currentUser?.displayName ?? 'User';
    _userEmail =
        Auth.userEmail ?? Auth.currentUser?.email ?? 'user@example.com';

    // Log screen view
    FirebaseService.logScreenView('profile_screen');

    // Initialize animation tweens
    _infoSlideOffset = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    );

    _menuItemsOffset = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    );

    _settingsRouteOffset = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    );

    // Load user profile and academic stats
    _loadUserData();

    _controller.forward();
  }

  Future<void> _loadUserData() async {
    try {
      final profileData = await FirebaseService.getUserProfile();
      final stats = await FirebaseService.getUserAcademicStats();
      
      if (mounted) {
        setState(() {
          _userProfile = profileData != null ? UserProfile.fromMap(profileData) : null;
          _academicStats = stats ?? {};
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final primaryWithAlpha20 = SubjectUtils.getTransparentColor(
      primaryColor,
      0.2,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _navigateToEditProfile,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile header with avatar and info
                      _buildProfileAvatar(theme, primaryColor, primaryWithAlpha20),
                      const SizedBox(height: 24),

                      // User info
                      _buildUserInfoCard(theme),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Menu items
                      _buildMenuItems(theme),
                      
                      // Quick Actions Section
                      _buildQuickActionsSection(theme),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProfileAvatar(
    ThemeData theme,
    Color primaryColor,
    Color backgroundColor,
  ) {
    return ScaleTransition(
      scale: _avatarAnimation,
      child: GestureDetector(
        onTap: _navigateToProfileDetails,
        child: Hero(
          tag: 'profile-avatar',
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 3),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: backgroundColor,
              backgroundImage: _userProfile?.photoUrl != null 
                  ? NetworkImage(_userProfile!.photoUrl!) 
                  : null,
              child: _userProfile?.photoUrl == null 
                  ? Icon(Icons.person, size: 60, color: primaryColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(ThemeData theme) {
    return FadeTransition(
      opacity: _infoAnimation,
      child: SlideTransition(
        position: _infoSlideOffset.animate(_infoAnimation),
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: InkWell(
            onTap: _navigateToEditProfile,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userProfile?.displayName ?? _userName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userProfile?.email ?? _userEmail,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            if (_userProfile?.studentId != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'ID: ${_userProfile!.studentId}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                  
                  // Profile Completion Progress
                  if (_userProfile != null) ...[
                    const SizedBox(height: 16),
                    _buildProfileCompletionProgress(theme),
                  ],
                  
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoItem(
                        context, 
                        _academicStats['totalCourses']?.toString() ?? '0', 
                        'Courses'
                      ),
                      _buildVerticalDivider(),
                      _buildInfoItem(
                        context, 
                        _academicStats['attendanceRate'] != null 
                          ? '${_academicStats['attendanceRate'].toStringAsFixed(1)}%' 
                          : '0%', 
                        'Attendance'
                      ),
                      _buildVerticalDivider(),
                      _buildInfoItem(
                        context, 
                        _academicStats['currentGPA']?.toStringAsFixed(1) ?? '0.0', 
                        'GPA'
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItems(ThemeData theme) {
    return SlideTransition(
      position: _menuItemsOffset.animate(_listAnimation),
      child: FadeTransition(
        opacity: _listAnimation,
        child: Column(
          children: [
            _buildProfileMenuItem(
              context,
              Icons.person_outline,
              'Profile Settings',
              'Detailed profile setup and preferences',
              onTap: _navigateToProfileSettings,
            ),
            _buildProfileMenuItem(
              context,
              Icons.school,
              'Academic Information',
              _userProfile?.academicLevel ?? 'Not specified',
              onTap: _navigateToAcademicInfo,
            ),
            _buildProfileMenuItem(
              context,
              Icons.assessment,
              'Performance',
              'View your academic progress',
              onTap: _navigateToPerformance,
            ),
            _buildProfileMenuItem(
              context,
              Icons.calendar_today,
              'Schedule',
              'View your weekly schedule',
              onTap: _navigateToSchedule,
            ),
            _buildProfileMenuItem(
              context,
              Icons.analytics,
              'Detailed Statistics',
              'View comprehensive academic data',
              onTap: _navigateToAcademicStats,
            ),
            _buildProfileMenuItem(
              context,
              Icons.settings,
              'Settings',
              'App preferences and account',
              onTap: () => _navigateToSettings(context),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => const SettingsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: _settingsRouteOffset.animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateToEditProfile() async {
    if (_userProfile == null) return;

    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userProfile: _userProfile!),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _userProfile = result;
      });
    }
  }

  void _navigateToAcademicInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AcademicInfoScreen(),
      ),
    );
  }

  void _navigateToPerformance() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PerformanceScreen(),
      ),
    );
  }

  void _navigateToSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScheduleScreen(),
      ),
    );
  }

  void _navigateToAcademicStats() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AcademicStatsScreen(),
      ),
    );
  }

  Future<void> _navigateToProfileDetails() async {
    if (_userProfile == null) return;

    final result = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailsScreen(userProfile: _userProfile!),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _userProfile = result;
      });
    }
  }

  void _navigateToProfileSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileSettingsScreen(),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[300]);
  }

  Widget _buildProfileCompletionProgress(ThemeData theme) {
    final completeness = _calculateProfileCompleteness();
    final completenessPercentage = (completeness / 100 * 100).round();
    
    Color progressColor;
    String statusText;
    
    if (completeness >= 80) {
      progressColor = Colors.green;
      statusText = 'Complete';
    } else if (completeness >= 50) {
      progressColor = Colors.orange;
      statusText = 'Good';
    } else {
      progressColor = Colors.red;
      statusText = 'Incomplete';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile Completion',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$completenessPercentage% • $statusText',
              style: theme.textTheme.bodySmall?.copyWith(
                color: progressColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completeness / 100,
            minHeight: 6,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }

  int _calculateProfileCompleteness() {
    if (_userProfile == null) return 0;
    
    int completeness = 0;
    
    if (_userProfile!.name.isNotEmpty) completeness += 20;
    if (_userProfile!.phoneNumber != null && _userProfile!.phoneNumber!.isNotEmpty) completeness += 15;
    if (_userProfile!.dateOfBirth != null) completeness += 10;
    if (_userProfile!.address != null && _userProfile!.address!.isNotEmpty) completeness += 10;
    if (_userProfile!.grade != null) completeness += 15;
    if (_userProfile!.major != null) completeness += 15;
    if (_userProfile!.studentId != null && _userProfile!.studentId!.isNotEmpty) completeness += 15;
    
    return completeness;
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return SlideTransition(
      position: _menuItemsOffset.animate(_listAnimation),
      child: FadeTransition(
        opacity: _listAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    theme,
                    'Add Assignment',
                    Icons.add_task,
                    Colors.blue,
                    () => Navigator.pushNamed(context, '/add_assignment'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    theme,
                    'View Calendar',
                    Icons.calendar_month,
                    Colors.green,
                    _navigateToSchedule,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    theme,
                    'My Progress',
                    Icons.trending_up,
                    Colors.purple,
                    _navigateToPerformance,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    theme,
                    'Statistics',
                    Icons.analytics,
                    Colors.orange,
                    _navigateToAcademicStats,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final primaryWithAlpha10 = SubjectUtils.getTransparentColor(
      primaryColor,
      0.1,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryWithAlpha10,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Icon(icon, color: primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
