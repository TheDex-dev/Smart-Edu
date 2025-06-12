import 'package:flutter/material.dart';
import 'optimized_widgets.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? description;
  final String imageUrl;
  final bool isCompleted;
  final List<Widget>? badges;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.description,
    this.imageUrl = 'https://picsum.photos/400/200',
    this.isCompleted = false,
    this.badges,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: isDark ? 8 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: OptimizedNetworkImage(
                      imageUrl: imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholderColor: theme.colorScheme.primary.withValues(
                        alpha: 0.1,
                      ),
                      fadeInDuration: const Duration(milliseconds: 300),
                    ),
                  ),
                  if (isCompleted)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),

              // Content section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and trailing
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration:
                                  isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (trailing != null) trailing!,
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Subtitle
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    if (description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    if (badges != null && badges!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(spacing: 8, children: badges!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
