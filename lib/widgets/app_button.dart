import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';

/// Primary Button - Solid fill, purple background
class AppPrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  const AppPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: widget.onPressed != null
                ? (_isPressed ? AppColors.purpleDark : AppColors.purple)
                : AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: widget.onPressed == null
                ? Border.all(color: AppColors.border)
                : null,
            boxShadow: widget.onPressed != null ? AppShadows.purpleButtonShadow : null,
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.textBright,
                    ),
                  ),
                )
              : Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.button.copyWith(
                    color: widget.onPressed != null
                        ? AppColors.textBright
                        : AppColors.textDim,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Secondary Button - Border only, transparent background
class AppSecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;

  const AppSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fullWidth = true,
  });

  @override
  State<AppSecondaryButton> createState() => _AppSecondaryButtonState();
}

class _AppSecondaryButtonState extends State<AppSecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _isPressed ? AppColors.purple.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.purple.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}

/// Success Button - Green background
class AppSuccessButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool fullWidth;

  const AppSuccessButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fullWidth = true,
  });

  @override
  State<AppSuccessButton> createState() => _AppSuccessButtonState();
}

class _AppSuccessButtonState extends State<AppSuccessButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              widget.onPressed!();
            }
          : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: _isPressed
                ? AppColors.success.withValues(alpha: 0.8)
                : AppColors.success,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: AppTextStyles.button,
          ),
        ),
      ),
    );
  }
}
