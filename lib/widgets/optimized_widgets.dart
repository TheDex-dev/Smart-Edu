import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Optimized image widget with improved caching and performance
class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? placeholderColor;
  final Widget? errorWidget;
  final Duration fadeInDuration;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderColor,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) => _buildPlaceholder(context),
      errorWidget: (context, url, error) => _buildErrorWidget(context),
      // Performance optimizations
      memCacheWidth: _getOptimalCacheWidth(),
      memCacheHeight: _getOptimalCacheHeight(),
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        placeholderColor ?? theme.colorScheme.primary.withValues(alpha: 0.1);

    return Container(
      width: width,
      height: height,
      color: color,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      color: theme.colorScheme.primary.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          color: theme.colorScheme.primary,
          size: 40,
        ),
      ),
    );
  }

  int? _getOptimalCacheWidth() {
    if (width != null && width!.isFinite) {
      return (width! * 2).round(); // 2x for high DPI displays
    }
    return 800; // Default cache width
  }

  int? _getOptimalCacheHeight() {
    if (height != null && height!.isFinite) {
      return (height! * 2).round(); // 2x for high DPI displays
    }
    return 600; // Default cache height
  }
}

/// Memory-efficient list tile for large lists
class OptimizedListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;

  const OptimizedListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: contentPadding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 16)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null) title!,
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        subtitle!,
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 16), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Cached and optimized icon widget
class OptimizedIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const OptimizedIcon(this.icon, {super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: Icon(icon, size: size, color: color));
  }
}
