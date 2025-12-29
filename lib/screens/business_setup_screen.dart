import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/theme.dart';
import '../widgets/app_button.dart';
import '../models/simulation.dart';

class BusinessSetupScreen extends StatefulWidget {
  const BusinessSetupScreen({super.key});

  @override
  State<BusinessSetupScreen> createState() => _BusinessSetupScreenState();
}

class _BusinessSetupScreenState extends State<BusinessSetupScreen> {
  BusinessType? selectedType;
  int selectedBudget = 150000; // Default ฿150K
  String selectedLocation = 'Bangkok';

  final List<int> budgetOptions = [100000, 150000, 200000, 300000];
  final List<String> locationOptions = ['Bangkok', 'Chiang Mai', 'Phuket', 'Pattaya'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textBright,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚔️ PLAY Mode',
                          style: AppTextStyles.headline3,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Set up your business',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Business Type
                    _buildSectionHeader('1. CHOOSE YOUR BUSINESS TYPE'),
                    const SizedBox(height: AppSpacing.md),
                    ...BusinessType.values.map((type) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _buildTypeOption(type),
                    )),

                    const SizedBox(height: AppSpacing.xl),

                    // Step 2: Starting Budget
                    _buildSectionHeader('2. STARTING BUDGET'),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: budgetOptions.map((budget) => _buildBudgetChip(budget)).toList(),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Step 3: Location
                    _buildSectionHeader('3. LOCATION'),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: locationOptions.map((loc) => _buildLocationChip(loc)).toList(),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Summary
                    if (selectedType != null)
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.bgDarker,
                          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                          border: Border.all(color: AppColors.purple.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('📋', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: AppSpacing.sm),
                                Text(
                                  'YOUR SETUP',
                                  style: AppTextStyles.tag.copyWith(color: AppColors.gold),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildSummaryRow('Business', '${selectedType!.icon} ${selectedType!.displayName}'),
                            _buildSummaryRow('Budget', '฿${(selectedBudget / 1000).toStringAsFixed(0)}K'),
                            _buildSummaryRow('Location', selectedLocation),
                          ],
                        ),
                      ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppPrimaryButton(
                text: selectedType == null ? 'Select a business type' : 'Start Learning →',
                onPressed: selectedType != null
                    ? () {
                        final setup = BusinessSetup(
                          type: selectedType!,
                          budget: selectedBudget,
                          location: selectedLocation,
                        );
                        Navigator.pushNamed(
                          context,
                          '/module-select',
                          arguments: setup,
                        );
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Text(
      text,
      style: AppTextStyles.tag.copyWith(color: AppColors.textDim),
    );
  }

  Widget _buildTypeOption(BusinessType type) {
    final isSelected = selectedType == type;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => selectedType = type);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple.withValues(alpha: 0.15) : AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(type.icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.displayName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.textBright : AppColors.textMid,
                    ),
                  ),
                  Text(
                    _getTypeDescription(type),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 16, color: AppColors.textBright),
              ),
          ],
        ),
      ),
    );
  }

  String _getTypeDescription(BusinessType type) {
    switch (type) {
      case BusinessType.coffee:
        return 'High foot traffic, competitive market';
      case BusinessType.restaurant:
        return 'Complex operations, higher margins';
      case BusinessType.ecommerce:
        return 'Lower overhead, delivery focused';
      case BusinessType.service:
        return 'Skill-based, relationship driven';
    }
  }

  Widget _buildBudgetChip(int budget) {
    final isSelected = selectedBudget == budget;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => selectedBudget = budget);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gold : AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppBorderRadius.round),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.border,
          ),
        ),
        child: Text(
          '฿${(budget / 1000).toStringAsFixed(0)}K',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? AppColors.bgDeep : AppColors.textMid,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChip(String location) {
    final isSelected = selectedLocation == location;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => selectedLocation = location);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.purple : AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppBorderRadius.round),
          border: Border.all(
            color: isSelected ? AppColors.purple : AppColors.border,
          ),
        ),
        child: Text(
          location,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.textBright : AppColors.textMid,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: AppColors.textDim),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textBright,
            ),
          ),
        ],
      ),
    );
  }
}
