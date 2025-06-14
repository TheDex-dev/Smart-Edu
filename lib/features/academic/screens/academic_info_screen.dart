import 'package:flutter/material.dart';
import '../../../shared/widgets/modern_components.dart';
import '../../../core/data/mock_data.dart';
import '../../../core/theme/modern_theme.dart';

class AcademicInfoScreen extends StatelessWidget {
  const AcademicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Information'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Academic Summary Card
            _buildAcademicSummaryCard(theme),
            const SizedBox(height: 32),

            // Current Courses
            _buildSectionTitle(theme, 'Current Courses'),
            const SizedBox(height: 16),
            _buildCurrentCourses(theme),
            const SizedBox(height: 32),

            // Academic History
            _buildSectionTitle(theme, 'Academic History'),
            const SizedBox(height: 16),
            _buildAcademicHistory(theme),
            const SizedBox(height: 32),

            // Achievements
            _buildSectionTitle(theme, 'Achievements'),
            const SizedBox(height: 16),
            _buildAchievements(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAcademicSummaryCard(ThemeData theme) {
    return ModernCard(
      gradient: ModernTheme.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:                  Text(
                    MockData.getAcademicSummary()['grade'],
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(
                theme,
                'Student ID',
                MockData.getAcademicSummary()['studentId'],
                isLight: true,
              ),
              _buildInfoColumn(
                theme,
                'Academic Year',
                MockData.getAcademicSummary()['academicYear'],
                isLight: true,
              ),
              _buildInfoColumn(theme, 'Semester', MockData.getAcademicSummary()['semester'], isLight: true),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(theme, 'Credits Earned', MockData.getAcademicSummary()['creditsEarned'], isLight: true),
              _buildInfoColumn(theme, 'Current GPA', MockData.getAcademicSummary()['currentGPA'].toString(), isLight: true),
              _buildInfoColumn(theme, 'Class Rank', MockData.getAcademicSummary()['classRank'], isLight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCourses(ThemeData theme) {
    final courses = MockData.currentCourses;

    return Column(
      children:
          courses.map((course) => _buildCourseCard(theme, course)).toList(),
    );
  }

  Widget _buildCourseCard(ThemeData theme, Map<String, String> course) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.book_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course['name']!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${course['code']} • ${course['credits']} Credits',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ModernChip(
            label: course['grade']!,
            backgroundColor: _getGradeColor(course['grade']!),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicHistory(ThemeData theme) {
    final history = MockData.academicHistory;

    return Column(
      children:
          history
              .map(
                (year) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.history_outlined,
                          color: theme.colorScheme.secondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              year['grade']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              year['year']!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'GPA: ${year['gpa']}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${year['credits']} Credits',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildAchievements(ThemeData theme) {
    final achievements = [
      {
        'title': 'Honor Roll',
        'description': 'Fall 2024 Semester',
        'icon': Icons.star,
      },
      {
        'title': 'Science Fair Winner',
        'description': '1st Place - Physics Project',
        'icon': Icons.science,
      },
      {
        'title': 'Math Olympiad',
        'description': 'Regional Qualifier',
        'icon': Icons.calculate,
      },
      {
        'title': 'Perfect Attendance',
        'description': 'Spring 2024 Semester',
        'icon': Icons.check_circle,
      },
    ];

    return Column(
      children:
          achievements
              .map(
                (achievement) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          achievement['icon'] as IconData,
                          color: Colors.amber.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement['title'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement['description'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber.shade700,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoColumn(
    ThemeData theme,
    String label,
    String value, {
    bool isLight = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                isLight
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isLight ? Colors.white : null,
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A+':
        return Colors.green;
      case 'A-':
        return Colors.lightGreen;
      case 'B+':
        return Colors.blue;
      case 'B':
        return Colors.lightBlue;
      case 'B-':
        return Colors.orange;
      case 'C+':
      case 'C':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}
