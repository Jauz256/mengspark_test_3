import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';

/// Standard Card - Dark background with subtle purple border
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null
          ? () {
              HapticFeedback.lightImpact();
              onTap!();
            }
          : null,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgDarker,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: AppColors.border),
          // NO shadow - as per design specs
        ),
        child: child,
      ),
    );
  }
}

/// Mode Card - For Home Screen mode selection
class ModeCard extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final String badgeText;
  final bool isPro;
  final bool isLocked;
  final VoidCallback? onTap;

  const ModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.badgeText,
    this.isPro = false,
    this.isLocked = false,
    this.onTap,
  });

  @override
  State<ModeCard> createState() => _ModeCardState();
}

class _ModeCardState extends State<ModeCard> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.isLocked) return;
    HapticFeedback.lightImpact();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.isLocked ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.isLocked ? null : (_) => setState(() => _isPressed = true),
        onTapUp: widget.isLocked ? null : (_) {
          setState(() => _isPressed = false);
          _handleTap();
        },
        onTapCancel: widget.isLocked ? null : () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedOpacity(
            opacity: widget.isLocked ? 0.6 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.bgDarker,
                    borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                    border: Border.all(
                      color: _isPressed ? AppColors.purple : AppColors.border,
                      width: _isPressed ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Icon Container
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.purple,
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            ),
                            child: Center(
                              child: Text(
                                widget.icon,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textBright,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.subtitle,
                                  style: AppTextStyles.subtitle,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  widget.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textMid,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Start Button
                      if (!widget.isLocked) ...[
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              onTap: _handleTap,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Start ${widget.title} →',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textBright,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Badge
                Positioned(
                  top: AppSpacing.md,
                  right: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isPro ? AppColors.gold : AppColors.success,
                      borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                    ),
                    child: Text(
                      widget.badgeText,
                      style: AppTextStyles.tag.copyWith(
                        color: AppColors.bgDeep,
                      ),
                    ),
                  ),
                ),
                // Lock Overlay
                if (widget.isLocked)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgDeep.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      ),
                      child: Center(
                        child: Text(
                          '🔒 Coming Soon',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMid,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Founder Card - For founder selection list
class FounderCard extends StatefulWidget {
  final String name;
  final String company;
  final String photoUrl;
  final String startedWith;
  final String nowWorth;
  final VoidCallback? onTap;

  const FounderCard({
    super.key,
    required this.name,
    required this.company,
    required this.photoUrl,
    required this.startedWith,
    required this.nowWorth,
    this.onTap,
  });

  @override
  State<FounderCard> createState() => _FounderCardState();
}

class _FounderCardState extends State<FounderCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgDarker,
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Photo placeholder (circle with icon)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.purple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                ),
                child: const Center(
                  child: Text('👤', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBright,
                      ),
                    ),
                    Text(
                      widget.company,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        _buildStatChip('Started: ${widget.startedWith}'),
                        const SizedBox(width: AppSpacing.sm),
                        _buildStatChip('Now: ${widget.nowWorth}', isHighlight: true),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow
              Icon(
                Icons.chevron_right,
                color: AppColors.textDim,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(String text, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.gold.withValues(alpha: 0.15)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isHighlight ? AppColors.gold : AppColors.textMid,
        ),
      ),
    );
  }
}
