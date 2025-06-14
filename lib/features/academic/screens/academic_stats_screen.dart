import 'package:flutter/material.dart';
import '../../../../core/services/firebase_service.dart';
import '../../../shared/widgets/modern_components.dart';

class AcademicStatsScreen extends StatefulWidget {
  const AcademicStatsScreen({super.key});

  @override
  State<AcademicStatsScreen> createState() => _AcademicStatsScreenState();
}

class _AcademicStatsScreenState extends State<AcademicStatsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic> _academicStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _loadAcademicStats();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadAcademicStats() async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading academic stats: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Statistics'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadAcademicStats,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Overall Performance Card
                        _buildOverallPerformanceCard(theme),
                        const SizedBox(height: 24),

                        // Course Statistics
                        _buildCourseStatisticsCard(theme),
                        const SizedBox(height: 24),

                        // Assignment Statistics
                        _buildAssignmentStatisticsCard(theme),
                        const SizedBox(height: 24),

                        // Attendance & Progress
                        _buildAttendanceProgressCard(theme),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildOverallPerformanceCard(ThemeData theme) {
    final gpa = _academicStats['currentGPA']?.toDouble() ?? 0.0;
    final attendanceRate = _academicStats['attendanceRate']?.toDouble() ?? 0.0;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Overall Performance',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  gpa.toStringAsFixed(2),
                  'Current GPA',
                  Icons.school,
                  _getGpaColor(gpa),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  '${attendanceRate.toStringAsFixed(1)}%',
                  'Attendance Rate',
                  Icons.event_available,
                  _getAttendanceColor(attendanceRate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourseStatisticsCard(ThemeData theme) {
    final totalCourses = _academicStats['totalCourses'] ?? 0;
    final completedCourses = _academicStats['completedCourses'] ?? 0;
    final totalCredits = _academicStats['totalCredits'] ?? 0;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Course Statistics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  totalCourses.toString(),
                  'Total Courses',
                  Icons.library_books,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  completedCourses.toString(),
                  'Completed',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatItem(
            context,
            totalCredits.toString(),
            'Total Credits Earned',
            Icons.star,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentStatisticsCard(ThemeData theme) {
    final totalAssignments = _academicStats['totalAssignments'] ?? 0;
    final completedAssignments = _academicStats['completedAssignments'] ?? 0;
    final pendingAssignments = _academicStats['pendingAssignments'] ?? 0;
    final completionRate =
        totalAssignments > 0
            ? (completedAssignments / totalAssignments * 100)
            : 0.0;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Assignment Statistics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  totalAssignments.toString(),
                  'Total Assignments',
                  Icons.assignment_outlined,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  completedAssignments.toString(),
                  'Completed',
                  Icons.assignment_turned_in,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  pendingAssignments.toString(),
                  'Pending',
                  Icons.assignment_late,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  '${completionRate.toStringAsFixed(1)}%',
                  'Completion Rate',
                  Icons.percent,
                  _getCompletionRateColor(completionRate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceProgressCard(ThemeData theme) {
    final attendanceRate = _academicStats['attendanceRate']?.toDouble() ?? 0.0;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Attendance & Progress',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Attendance Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance Rate',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${attendanceRate.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getAttendanceColor(attendanceRate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: attendanceRate / 100,
                  minHeight: 8,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getAttendanceColor(attendanceRate),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Performance Tips
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getPerformanceTip(attendanceRate),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGpaColor(double gpa) {
    if (gpa >= 3.5) return Colors.green;
    if (gpa >= 3.0) return Colors.orange;
    return Colors.red;
  }

  Color _getAttendanceColor(double attendance) {
    if (attendance >= 90) return Colors.green;
    if (attendance >= 75) return Colors.orange;
    return Colors.red;
  }

  Color _getCompletionRateColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getPerformanceTip(double attendanceRate) {
    if (attendanceRate >= 95) {
      return 'Excellent attendance! Keep up the great work!';
    } else if (attendanceRate >= 85) {
      return 'Good attendance rate. Try to maintain consistency.';
    } else if (attendanceRate >= 75) {
      return 'Consider improving your attendance for better academic performance.';
    } else {
      return 'Low attendance may affect your academic progress. Consider speaking with an advisor.';
    }
  }
}
