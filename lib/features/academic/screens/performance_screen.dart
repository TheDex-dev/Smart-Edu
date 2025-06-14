import 'package:flutter/material.dart';
import '../../../shared/widgets/modern_components.dart';
import '../../../core/theme/modern_theme.dart';
import '../../../core/data/mock_data.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(theme),
          _buildGradesTab(theme),
          _buildProgressTab(theme),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.6,
          ),
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined)),
            Tab(text: 'Grades', icon: Icon(Icons.grade_outlined)),
            Tab(text: 'Progress', icon: Icon(Icons.trending_up_outlined)),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          ModernCard(
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
                        Icons.trending_up,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Performance',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep up the excellent work!',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Performance Summary Cards
          Row(
            children: [
              Expanded(
                child: ModernStatCard(
                  title: 'Overall GPA',
                  value: '4.2',
                  icon: Icons.school_outlined,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModernStatCard(
                  title: 'Attendance',
                  value: '95%',
                  icon: Icons.calendar_today_outlined,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ModernStatCard(
                  title: 'Assignments',
                  value: '18/20',
                  icon: Icons.assignment_outlined,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ModernStatCard(
                  title: 'Class Rank',
                  value: '#5',
                  icon: Icons.leaderboard_outlined,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Recent Performance
          Text(
            'Recent Performance',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentPerformance(theme),
          const SizedBox(height: 32),

          // Subject Strengths
          Text(
            'Subject Strengths',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSubjectStrengths(theme),
        ],
      ),
    );
  }

  Widget _buildGradesTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Semester Grades',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildGradesList(theme),
        ],
      ),
    );
  }

  Widget _buildProgressTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Academic Progress',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildProgressCharts(theme),
          const SizedBox(height: 32),

          Text(
            'Goals & Targets',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildGoalsAndTargets(theme),
        ],
      ),
    );
  }

  Widget _buildRecentPerformance(ThemeData theme) {
    final recentTests = MockData.recentPerformanceTests;

    return Column(
      children:
          recentTests
              .map(
                (test) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.quiz_outlined,
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
                              test['test']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${test['subject']} • ${test['date']}',
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
                      ModernChip(
                        label: test['score']!,
                        backgroundColor: _getScoreColor(test['score']!),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildSubjectStrengths(ThemeData theme) {
    final subjects = [
      {'name': 'Mathematics', 'strength': 98, 'color': Colors.blue},
      {'name': 'Computer Science', 'strength': 96, 'color': Colors.green},
      {'name': 'Biology', 'strength': 94, 'color': Colors.purple},
      {'name': 'Physics', 'strength': 90, 'color': Colors.orange},
      {'name': 'Chemistry', 'strength': 88, 'color': Colors.red},
      {'name': 'English', 'strength': 85, 'color': Colors.teal},
    ];

    return Column(
      children:
          subjects
              .map(
                (subject) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subject['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${subject['strength']}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: subject['color'] as Color,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ModernProgressIndicator(
                        value: (subject['strength'] as int) / 100,
                        valueColor: subject['color'] as Color,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildGradesList(ThemeData theme) {
    final grades = [
      {
        'subject': 'Advanced Mathematics',
        'grade': 'A',
        'percentage': '95%',
        'points': '4.0',
      },
      {
        'subject': 'Physics',
        'grade': 'A-',
        'percentage': '90%',
        'points': '3.7',
      },
      {
        'subject': 'Chemistry',
        'grade': 'B+',
        'percentage': '87%',
        'points': '3.3',
      },
      {
        'subject': 'Biology',
        'grade': 'A',
        'percentage': '94%',
        'points': '4.0',
      },
      {
        'subject': 'English Literature',
        'grade': 'B+',
        'percentage': '85%',
        'points': '3.3',
      },
      {
        'subject': 'Computer Science',
        'grade': 'A',
        'percentage': '96%',
        'points': '4.0',
      },
    ];

    return Column(
      children:
          grades
              .map(
                (grade) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.subject_outlined,
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
                              grade['subject']!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${grade['percentage']} • ${grade['points']} points',
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
                      ModernChip(
                        label: grade['grade']!,
                        backgroundColor: _getGradeColor(grade['grade']!),
                        foregroundColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildProgressCharts(ThemeData theme) {
    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GPA Trend',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      size: 48,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Steady Improvement',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your GPA has increased by 0.3 points this semester',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsAndTargets(ThemeData theme) {
    final goals = [
      {'goal': 'Maintain GPA above 4.0', 'progress': 100, 'status': 'Achieved'},
      {
        'goal': 'Perfect attendance this semester',
        'progress': 95,
        'status': 'On Track',
      },
      {
        'goal': 'Complete all assignments on time',
        'progress': 90,
        'status': 'On Track',
      },
      {
        'goal': 'Improve Chemistry grade to A',
        'progress': 70,
        'status': 'In Progress',
      },
    ];

    return Column(
      children:
          goals
              .map(
                (goal) => ModernCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              goal['goal'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ModernChip(
                            label: goal['status'] as String,
                            backgroundColor: _getStatusColor(
                              goal['status'] as String,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ModernProgressIndicator(
                        value: (goal['progress'] as int) / 100,
                        valueColor: theme.colorScheme.primary,
                        label: '${goal['progress']}% Complete',
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }

  Color _getScoreColor(String score) {
    final percentage = int.tryParse(score.replaceAll('%', '')) ?? 0;
    if (percentage >= 90) return Colors.green;
    if (percentage >= 80) return Colors.blue;
    if (percentage >= 70) return Colors.orange;
    return Colors.red;
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Achieved':
        return Colors.green;
      case 'On Track':
        return Colors.blue;
      case 'In Progress':
        return Colors.orange;
      case 'At Risk':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
