// filepath: /home/stolas/AndroidStudioProjects/smart_edu/lib/screens/assignment_details_screen.dart
import 'package:flutter/material.dart';

class AssignmentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> assignment;
  final VoidCallback? onStatusToggle;

  const AssignmentDetailsScreen({
    super.key,
    required this.assignment,
    this.onStatusToggle,
  });

  @override
  State<AssignmentDetailsScreen> createState() =>
      _AssignmentDetailsScreenState();
}

class _AssignmentDetailsScreenState extends State<AssignmentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Cache for performance optimization
  late bool _isCompleted;
  late Color _statusColor;
  late Color _statusBackgroundColor;
  late String _statusText;
  late IconData _statusIcon;
  late Color _buttonBackgroundColor;
  late Color _buttonForegroundColor;
  late String _buttonText;
  late IconData _buttonIcon;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuad),
    );

    // Initialize cached values
    _updateCachedValues();

    // Start the animation when the screen loads
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AssignmentDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assignment['isCompleted'] !=
        widget.assignment['isCompleted']) {
      _updateCachedValues();
    }
  }

  void _updateCachedValues() {
    _isCompleted = widget.assignment['isCompleted'] ?? false;
    _statusColor = _isCompleted ? Colors.green : Colors.orange;
    _statusBackgroundColor =
        _isCompleted
            ? const Color.fromRGBO(76, 175, 80, 0.1)
            : const Color.fromRGBO(255, 152, 0, 0.1);
    _statusText = _isCompleted ? 'Completed' : 'Pending';
    _statusIcon = _isCompleted ? Icons.check_circle : Icons.pending;
    _buttonBackgroundColor =
        _isCompleted ? Colors.orange.shade100 : Colors.green.shade100;
    _buttonForegroundColor = _isCompleted ? Colors.deepOrange : Colors.green;
    _buttonText = _isCompleted ? 'Mark as Incomplete' : 'Mark as Complete';
    _buttonIcon = _isCompleted ? Icons.refresh : Icons.check_circle;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildAssignmentCard(context)],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _animationController.value,
                child: child,
              );
            },
            child: ElevatedButton(
              onPressed: () {
                // Play a small animation before popping the screen
                _animationController.reverse().then((_) {
                  if (widget.onStatusToggle != null) {
                    widget.onStatusToggle!();
                  }
                  Navigator.pop(context);
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(_buttonBackgroundColor),
                foregroundColor: WidgetStatePropertyAll(_buttonForegroundColor),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 16),
                ),
                shape: const WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_buttonIcon),
                  const SizedBox(width: 10),
                  Text(
                    _buttonText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: _statusBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(_statusIcon, color: _statusColor, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.assignment['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Subject',
              widget.assignment['subject'],
              Icons.subject,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              context,
              'Due Date',
              widget.assignment['dueDate'],
              Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(context, 'Status', _statusText, Icons.info_outline),
            if (widget.assignment['description'] != null &&
                widget.assignment['description'].isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              _buildDescriptionSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.description, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 4),
              Text(
                widget.assignment['description'],
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    // Cache theme values to avoid multiple lookups
    final ThemeData theme = Theme.of(context);
    final Color primaryWithAlpha = theme.colorScheme.primary.withAlpha(26);
    final Color primaryColor = theme.colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryWithAlpha,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
