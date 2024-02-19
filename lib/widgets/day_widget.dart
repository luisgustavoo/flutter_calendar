import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/enum/day_status.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    required this.day,
    required this.dayStatus,
    required this.onChanged,
    super.key,
  });

  final DateTime day;
  final DayStatus dayStatus;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final textStyle = switch (dayStatus) {
      DayStatus.isDisabled => const TextStyle(color: Colors.grey),
      DayStatus.isSelectedDay => const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      _ => const TextStyle(color: Colors.black),
    };

    final backgroundColor = switch (dayStatus) {
      DayStatus.isSelectedDay || DayStatus.isToday => Colors.orange,
      _ => null,
    };

    final dayToBuild = day.day;

    return GestureDetector(
      onTap: () {
        onChanged(day);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          // shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Text(
            dayToBuild.toString(),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
