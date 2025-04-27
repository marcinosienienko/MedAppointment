import 'package:flutter/material.dart';
import 'package:medical_app/core/theme/app_colors.dart';

class FilterChoiceChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FilterChoiceChip({
    Key? key,
    required this.label,
    this.count = 0,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        '$label ($count)',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.primaryLighter,
    );
  }
}
