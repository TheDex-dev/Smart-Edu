import 'package:flutter/material.dart';
import '../../../core/constants/subject_images.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                backgroundColor: WidgetStateProperty.all(_buttonBackgroundColor),
                foregroundColor: WidgetStateProperty.all(_buttonForegroundColor),
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
    final String subject = widget.assignment['subject'] ?? 'General';
    final String dueDate = widget.assignment['dueDate'] ?? '';
    final String description = widget.assignment['description'] ?? 'No description available';
    
    // Get subject-specific styling
    final String imageUrl = SubjectUtils.getImageForSubject(subject);
    final Color subjectColor = SubjectUtils.getColorForSubject(subject);
    final String formattedDueDate = SubjectUtils.formatDueDate(dueDate);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header image with title overlay
        Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      SubjectUtils.getTransparentColor(Colors.black, 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assignment['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: SubjectUtils.getTransparentColor(subjectColor, 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            subject,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isCompleted ? 
                              SubjectUtils.getTransparentColor(Colors.green, 0.8) : 
                              SubjectUtils.getTransparentColor(Colors.orange, 0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isCompleted ? Icons.check : Icons.calendar_today,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isCompleted ? 'Completed' : formattedDueDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
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
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Details section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details header
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Subject info row
              _buildInfoRow(
                context,
                'Subject',
                subject,
                Icons.subject,
                backgroundColor: SubjectUtils.getTransparentColor(subjectColor, 0.1),
                iconColor: subjectColor,
              ),
              
              // Due date info row
              _buildInfoRow(
                context,
                'Due Date',
                dueDate,
                Icons.calendar_today,
                backgroundColor: SubjectUtils.getTransparentColor(Colors.orange, 0.1),
                iconColor: Colors.orange,
              ),
              
              // Status info row
              _buildInfoRow(
                context,
                'Status',
                _statusText,
                _statusIcon,
                backgroundColor: _statusBackgroundColor,
                iconColor: _statusColor,
              ),
              
              // Description section
              if (widget.assignment['description'] != null &&
                  widget.assignment['description'].isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
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
    IconData icon, {
    Color? backgroundColor,
    Color? iconColor,
  }) {
    // Use provided colors or default theme colors
    final ThemeData theme = Theme.of(context);
    final Color bgColor = backgroundColor ?? SubjectUtils.getTransparentColor(theme.colorScheme.primary, 0.1);
    final Color icColor = iconColor ?? theme.colorScheme.primary;

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
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Icon(icon, size: 20, color: icColor),
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
