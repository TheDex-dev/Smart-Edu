import 'package:flutter/material.dart';
import '../models/auth.dart';
import 'settings_screen.dart';
import '../utils/subject_images.dart';

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
    _userName = Auth.userName ?? 'John Doe';
    _userEmail = Auth.userEmail ?? 'student@example.com';

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

    _controller.forward();
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
      ),
      body: SingleChildScrollView(
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
              const SizedBox(height: 32),
            ],
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
            child: Icon(Icons.person, size: 60, color: primaryColor),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  _userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _userEmail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildInfoItem(context, '12', 'Courses'),
                    _buildVerticalDivider(),
                    _buildInfoItem(context, '85%', 'Attendance'),
                    _buildVerticalDivider(),
                    _buildInfoItem(context, '4.2', 'GPA'),
                  ],
                ),
              ],
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
              Icons.school,
              'Academic Information',
              'Grade 10 • Science Major',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              context,
              Icons.assessment,
              'Performance',
              'View your academic progress',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              context,
              Icons.calendar_today,
              'Schedule',
              'View your weekly schedule',
              onTap: () {},
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
