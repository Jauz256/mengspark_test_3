import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';

/// Choice/Option Button - For decision screens
/// Left side: Circle with letter (A/B/C/D)
class ChoiceButton extends StatefulWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isConfirmed;
  final bool isDisabled;
  final VoidCallback? onTap;

  const ChoiceButton({
    super.key,
    required this.index,
    required this.text,
    this.isSelected = false,
    this.isConfirmed = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  bool _isPressed = false;

  String get _letterIndicator => String.fromCharCode(65 + widget.index); // A, B, C, D

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.isDisabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.isConfirmed
                ? AppColors.gold.withValues(alpha: 0.1)
                : widget.isSelected
                    ? AppColors.purple.withValues(alpha: 0.15)
                    : AppColors.purple.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: widget.isConfirmed
                  ? AppColors.gold
                  : widget.isSelected
                      ? AppColors.purple
                      : AppColors.border,
              width: widget.isSelected || widget.isConfirmed ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Letter indicator circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.isSelected || widget.isConfirmed
                      ? AppColors.purple
                      : AppColors.bgDarker,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected || widget.isConfirmed
                        ? AppColors.purple
                        : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    _letterIndicator,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.isSelected || widget.isConfirmed
                          ? AppColors.textBright
                          : AppColors.textDim,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Choice text
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isSelected || widget.isConfirmed
                        ? AppColors.textBright
                        : AppColors.textMid,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Flashcard Choice Button - For AI Quiz multiple choice
class QuizChoiceButton extends StatefulWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool? isCorrect; // null = not revealed, true = correct, false = wrong
  final bool isDisabled;
  final VoidCallback? onTap;

  const QuizChoiceButton({
    super.key,
    required this.index,
    required this.text,
    this.isSelected = false,
    this.isCorrect,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  State<QuizChoiceButton> createState() => _QuizChoiceButtonState();
}

class _QuizChoiceButtonState extends State<QuizChoiceButton> {
  bool _isPressed = false;

  String get _letterIndicator => String.fromCharCode(65 + widget.index);

  Color get _borderColor {
    if (widget.isCorrect == true) return AppColors.success;
    if (widget.isCorrect == false && widget.isSelected) return AppColors.danger;
    if (widget.isSelected) return AppColors.purple;
    return AppColors.border;
  }

  Color get _bgColor {
    if (widget.isCorrect == true) return AppColors.success.withValues(alpha: 0.15);
    if (widget.isCorrect == false && widget.isSelected) return AppColors.danger.withValues(alpha: 0.15);
    if (widget.isSelected) return AppColors.purple.withValues(alpha: 0.15);
    return AppColors.purple.withValues(alpha: 0.08);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isDisabled ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.isDisabled ? null : () => setState(() => _isPressed = false),
      onTap: widget.isDisabled
          ? null
          : () {
              HapticFeedback.lightImpact();
              widget.onTap?.call();
            },
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            children: [
              // Letter indicator
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: widget.isSelected ? _borderColor : AppColors.bgDarker,
                  shape: BoxShape.circle,
                  border: Border.all(color: _borderColor),
                ),
                child: Center(
                  child: widget.isCorrect != null
                      ? Icon(
                          widget.isCorrect == true ? Icons.check : Icons.close,
                          size: 16,
                          color: AppColors.textBright,
                        )
                      : Text(
                          _letterIndicator,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: widget.isSelected
                                ? AppColors.textBright
                                : AppColors.textDim,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isSelected ? AppColors.textBright : AppColors.textMid,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
