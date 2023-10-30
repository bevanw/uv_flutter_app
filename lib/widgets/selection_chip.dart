import 'package:flutter/material.dart';

class SelectionChip extends StatelessWidget {
  final Widget label;
  final ValueChanged<bool>? onSelected;
  final bool selected;

  const SelectionChip({
    super.key,
    required this.label,
    required this.onSelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: label,
      onSelected: onSelected,
      selected: selected,
      showCheckmark: false,
    );
  }
}
