import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({required this.children, super.key});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }
}
