import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/month_picker_widget.dart';

class CalendarDatePickerWidget extends StatefulWidget {
  const CalendarDatePickerWidget({
    required this.firstDate,
    required this.lastDate,
    required this.currentDate,
    required this.onDateChanged,
    this.initialDate,
    this.onDisplayedMonthChanged,
    this.selectableDayPredicate,
    super.key,
  });

  final DateTime? initialDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onDateChanged;

  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  final SelectableDayPredicate? selectableDayPredicate;

  @override
  State<CalendarDatePickerWidget> createState() =>
      _CalendarDatePickerWidgetState();
}

class _CalendarDatePickerWidgetState extends State<CalendarDatePickerWidget> {
  late DateTime _selectedDate;
  late DateTime _currentDisplayedMonthDate;

  void _handleMonthChanged(DateTime date) {
    setState(() {
      if (_currentDisplayedMonthDate.year != date.year ||
          _currentDisplayedMonthDate.month != date.month) {
        _currentDisplayedMonthDate = DateTime(date.year, date.month);
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthDate);
      }
    });
  }

  void _handleDayChanged(DateTime value) {
    // _vibrate();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(_selectedDate);
    });
  }

  @override
  void initState() {
    super.initState();

    final DateTime currentDisplayedDate =
        widget.initialDate ?? widget.currentDate;
    _currentDisplayedMonthDate =
        DateTime(currentDisplayedDate.year, currentDisplayedDate.month);
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate ?? DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MonthPickerWidget(
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onChanged: _handleDayChanged,
      onDisplayedMonthChanged: _handleMonthChanged,
      selectedDate: _selectedDate,
      selectableDayPredicate: (day) {
        return day.isAfter(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        );
      },
    );
  }
}
