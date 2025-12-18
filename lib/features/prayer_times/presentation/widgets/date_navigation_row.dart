import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateNavigationRow extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const DateNavigationRow({
    super.key,
    required this.selectedDate,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          DateFormat('EEE dd MMM yyyy', 'ar').format(selectedDate),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.navigate_next),
        ),
      ],
    );
  }
}
