import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ui/ui.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    required this.label,
    required this.initialDate,
    required this.onDateChanged,
    super.key,
  });

  final String label;
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onPressed: () async {
        final selectedDateTime =
            await _selectDateTime(context, initialDate: initialDate);
        if (selectedDateTime != null) {
          onDateChanged(selectedDateTime);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style:
                  AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_formatDateTime(initialDate), style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectDateTime(
    BuildContext context, {
    required DateTime initialDate,
  }) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null && context.mounted) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (selectedTime == null) return null;

      return DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    }

    return null;
  }

  String _formatDateTime(DateTime dateTime) {
    final date = DateFormat('MMM dd, yyyy').format(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);
    return '$date  $time';
  }
}
