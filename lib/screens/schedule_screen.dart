import 'package:flutter/material.dart';
import '../widgets/modern_components.dart';
import '../utils/modern_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDay = DateTime.now().weekday - 1; // Monday = 0

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  final Map<String, List<Map<String, dynamic>>> _schedule = {
    'Monday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Physics',
        'time': '09:45 - 11:15',
        'room': 'B203',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '11:15 - 11:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Chemistry',
        'time': '11:30 - 13:00',
        'room': 'C105',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Lunch',
        'time': '13:00 - 14:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'English',
        'time': '14:00 - 15:30',
        'room': 'A205',
        'teacher': 'Ms. Brown',
      },
    ],
    'Tuesday': [
      {
        'subject': 'Biology',
        'time': '08:00 - 09:30',
        'room': 'D102',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Computer Science',
        'time': '09:45 - 11:15',
        'room': 'E301',
        'teacher': 'Mr. Wilson',
      },
      {
        'subject': 'Break',
        'time': '11:15 - 11:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Mathematics',
        'time': '11:30 - 13:00',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Lunch',
        'time': '13:00 - 14:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Art',
        'time': '14:00 - 15:30',
        'room': 'F201',
        'teacher': 'Ms. Garcia',
      },
    ],
    'Wednesday': [
      {
        'subject': 'Physics Lab',
        'time': '08:00 - 10:00',
        'room': 'B203L',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '10:00 - 10:15',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'English',
        'time': '10:15 - 11:45',
        'room': 'A205',
        'teacher': 'Ms. Brown',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Chemistry',
        'time': '12:00 - 13:30',
        'room': 'C105',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'PE',
        'time': '14:30 - 16:00',
        'room': 'Gym',
        'teacher': 'Coach Miller',
      },
    ],
    'Thursday': [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30',
        'room': 'A101',
        'teacher': 'Dr. Smith',
      },
      {
        'subject': 'Biology Lab',
        'time': '09:45 - 11:45',
        'room': 'D102L',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Computer Science',
        'time': '12:00 - 13:30',
        'room': 'E301',
        'teacher': 'Mr. Wilson',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'History',
        'time': '14:30 - 16:00',
        'room': 'G102',
        'teacher': 'Mr. Taylor',
      },
    ],
    'Friday': [
      {
        'subject': 'Chemistry Lab',
        'time': '08:00 - 10:00',
        'room': 'C105L',
        'teacher': 'Dr. Williams',
      },
      {
        'subject': 'Break',
        'time': '10:00 - 10:15',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Physics',
        'time': '10:15 - 11:45',
        'room': 'B203',
        'teacher': 'Prof. Johnson',
      },
      {
        'subject': 'Break',
        'time': '11:45 - 12:00',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Biology',
        'time': '12:00 - 13:30',
        'room': 'D102',
        'teacher': 'Dr. Davis',
      },
      {
        'subject': 'Lunch',
        'time': '13:30 - 14:30',
        'room': '',
        'teacher': '',
        'isBreak': true,
      },
      {
        'subject': 'Study Hall',
        'time': '14:30 - 15:30',
        'room': 'Library',
        'teacher': '',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: const Text('Schedule'),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.6,
          ),
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Weekly', icon: Icon(Icons.calendar_view_week)),
            Tab(text: 'Today', icon: Icon(Icons.today)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildWeeklySchedule(theme), _buildTodaySchedule(theme)],
      ),
    );
  }

  Widget _buildWeeklySchedule(ThemeData theme) {
    return Column(
      children: [
        // Day selector
        Container(
          height: 70,
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedDay == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedDay = index),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? ModernTheme.primaryGradient : null,
                    color: isSelected ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color:
                          isSelected
                              ? Colors.transparent
                              : theme.colorScheme.outline.withValues(
                                alpha: 0.3,
                              ),
                      width: 1.5,
                    ),
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                            : null,
                  ),
                  child: Center(
                    child: Text(
                      _days[index],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Schedule for selected day
        Expanded(child: _buildDaySchedule(theme, _days[_selectedDay])),
      ],
    );
  }

  Widget _buildTodaySchedule(ThemeData theme) {
    final today = DateTime.now();
    final dayName =
        _days[(today.weekday - 1).clamp(0, 4)]; // Clamp to weekdays only

    return Column(
      children: [
        // Today's date header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: ModernTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.today, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${today.day}/${today.month}/${today.year}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Today's schedule
        Expanded(child: _buildDaySchedule(theme, dayName, showNextClass: true)),
      ],
    );
  }

  Widget _buildDaySchedule(
    ThemeData theme,
    String day, {
    bool showNextClass = false,
  }) {
    final daySchedule = _schedule[day] ?? [];
    final now = TimeOfDay.now();

    if (daySchedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.free_breakfast, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No classes today!',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: daySchedule.length,
      itemBuilder: (context, index) {
        final classInfo = daySchedule[index];
        final isBreak = classInfo['isBreak'] == true;
        final isCurrentClass =
            showNextClass && _isCurrentClass(classInfo['time'], now);
        final isNextClass =
            showNextClass && _isNextClass(daySchedule, index, now);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: _buildClassCard(
            theme,
            classInfo,
            isBreak: isBreak,
            isCurrentClass: isCurrentClass,
            isNextClass: isNextClass,
          ),
        );
      },
    );
  }

  Widget _buildClassCard(
    ThemeData theme,
    Map<String, dynamic> classInfo, {
    bool isBreak = false,
    bool isCurrentClass = false,
    bool isNextClass = false,
  }) {
    final primaryColor = theme.colorScheme.primary;
    Gradient? gradient;

    if (isCurrentClass) {
      gradient = ModernTheme.primaryGradient;
    } else if (isNextClass) {
      gradient = LinearGradient(
        colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return ModernCard(
      gradient: gradient,
      margin: const EdgeInsets.only(bottom: 12),
      isElevated: isCurrentClass || isNextClass,
      child: Row(
        children: [
          // Time column
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classInfo['time'].split(' - ')[0],
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        (isCurrentClass || isNextClass)
                            ? Colors.white
                            : theme.colorScheme.primary,
                  ),
                ),
                Text(
                  classInfo['time'].split(' - ')[1],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color:
                        (isCurrentClass || isNextClass)
                            ? Colors.white.withValues(alpha: 0.8)
                            : theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Subject icon
          if (!isBreak) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (isCurrentClass || isNextClass)
                        ? Colors.white.withValues(alpha: 0.2)
                        : _getSubjectColor(
                          classInfo['subject'],
                        ).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getSubjectIcon(classInfo['subject']),
                color:
                    (isCurrentClass || isNextClass)
                        ? Colors.white
                        : _getSubjectColor(classInfo['subject']),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    (isCurrentClass || isNextClass)
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                classInfo['subject'] == 'Lunch'
                    ? Icons.restaurant
                    : Icons.coffee,
                color:
                    (isCurrentClass || isNextClass)
                        ? Colors.white
                        : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Class details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classInfo['subject'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        (isCurrentClass || isNextClass) ? Colors.white : null,
                  ),
                ),
                if (!isBreak && classInfo['teacher'].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    classInfo['teacher'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          (isCurrentClass || isNextClass)
                              ? Colors.white.withValues(alpha: 0.8)
                              : theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                    ),
                  ),
                ],
                if (!isBreak && classInfo['room'].isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.room,
                        size: 16,
                        color:
                            (isCurrentClass || isNextClass)
                                ? Colors.white.withValues(alpha: 0.8)
                                : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        classInfo['room'],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              (isCurrentClass || isNextClass)
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Status indicator
          if (isCurrentClass) ...[
            ModernChip(
              label: 'NOW',
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
            ),
          ] else if (isNextClass) ...[
            ModernChip(
              label: 'NEXT',
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
            ),
          ],
        ],
      ),
    );
  }

  bool _isCurrentClass(String timeRange, TimeOfDay now) {
    final times = timeRange.split(' - ');
    final startTime = _parseTime(times[0]);
    final endTime = _parseTime(times[1]);

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return nowMinutes >= startMinutes && nowMinutes < endMinutes;
  }

  bool _isNextClass(
    List<Map<String, dynamic>> schedule,
    int index,
    TimeOfDay now,
  ) {
    if (index == 0) return false;

    final nowMinutes = now.hour * 60 + now.minute;

    // Check if this is the next non-break class after current time
    for (int i = 0; i < schedule.length; i++) {
      final classInfo = schedule[i];
      if (classInfo['isBreak'] == true) continue;

      final timeRange = classInfo['time'];
      final startTime = _parseTime(timeRange.split(' - ')[0]);
      final startMinutes = startTime.hour * 60 + startTime.minute;

      if (startMinutes > nowMinutes) {
        return i == index;
      }
    }

    return false;
  }

  TimeOfDay _parseTime(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'math':
        return Icons.calculate;
      case 'physics':
        return Icons.science;
      case 'chemistry':
        return Icons.biotech;
      case 'biology':
        return Icons.eco;
      case 'computer science':
        return Icons.computer;
      case 'english':
      case 'english literature':
        return Icons.menu_book;
      case 'history':
        return Icons.history_edu;
      case 'art':
        return Icons.palette;
      case 'pe':
        return Icons.fitness_center;
      default:
        return Icons.book;
    }
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'mathematics':
      case 'math':
        return Colors.blue;
      case 'physics':
        return Colors.green;
      case 'chemistry':
        return Colors.purple;
      case 'biology':
        return Colors.teal;
      case 'computer science':
        return Colors.indigo;
      case 'english':
      case 'english literature':
        return Colors.brown;
      case 'history':
        return Colors.amber;
      case 'art':
        return Colors.pink;
      case 'pe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
