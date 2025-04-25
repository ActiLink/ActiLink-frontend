import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {

  const CustomBottomSheet({
    required this.child, super.key,
    this.initialSize = 0.8,
    this.minSize = 0.6,
    this.maxSize = 0.95,
    this.backgroundColor = Colors.white,
  });
  final Widget child;
  final double initialSize;
  final double minSize;
  final double maxSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

void showCustomBottomSheet(
  BuildContext context,
  Widget screen, {
  double initialSize = 0.8,
  double minSize = 0.6,
  double maxSize = 0.95,
  Color backgroundColor = Colors.white,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => CustomBottomSheet(
      initialSize: initialSize,
      minSize: minSize,
      maxSize: maxSize,
      backgroundColor: backgroundColor,
      child: screen,
    ),
  );
}
