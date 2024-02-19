import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/day_picker_widget.dart';

class MonthPickerWidget extends StatefulWidget {
  const MonthPickerWidget({
    required this.initialMonth,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectedDate,
    this.selectableDayPredicate,
    super.key,
  });

  final DateTime initialMonth;

  final DateTime currentDate;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime? selectedDate;

  final ValueChanged<DateTime> onChanged;

  final ValueChanged<DateTime> onDisplayedMonthChanged;

  final SelectableDayPredicate? selectableDayPredicate;

  @override
  State<MonthPickerWidget> createState() => _MonthPickerWidgetState();
}

class _MonthPickerWidgetState extends State<MonthPickerWidget> {
  late DateTime _currentMonth;
  DateTime? _focusedDay;
  final GlobalKey _pageViewKey = GlobalKey();

  late PageController _pageController;

  void _handleDateSelected(DateTime selectedDate) {
    _focusedDay = selectedDate;
    widget.onChanged(selectedDate);
  }

  void _handleMonthPageChanged(int monthPage) {
    setState(() {
      final DateTime monthDate =
          DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
      if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
        _currentMonth = DateTime(monthDate.year, monthDate.month);
        widget.onDisplayedMonthChanged(_currentMonth);
        if (_focusedDay != null &&
            !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
          _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
        }
      }
    });
  }

  DateTime? _focusableDayForMonth(DateTime month, int preferredDay) {
    final int daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    if (preferredDay <= daysInMonth) {
      final DateTime newFocus = DateTime(month.year, month.month, preferredDay);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }

    // Start at the 1st and take the first selectable date.
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime newFocus = DateTime(month.year, month.month, day);
      if (_isSelectable(newFocus)) {
        return newFocus;
      }
    }
    return null;
  }

  bool _isSelectable(DateTime date) {
    return widget.selectableDayPredicate == null ||
        widget.selectableDayPredicate!.call(date);
  }

  Widget _buildItems(BuildContext context, int index) {
    final DateTime month =
        DateUtils.addMonthsToMonthDate(widget.firstDate, index);
    return DayPickerWidget(
      key: ValueKey<DateTime>(month),
      selectedDate: widget.selectedDate,
      currentDate: widget.currentDate,
      onChanged: _handleDateSelected,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      displayedMonth: month,
      // selectableDayPredicate: widget.selectableDayPredicate,
    );
  }

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.firstDate;
    _pageController = PageController(
        initialPage: DateUtils.monthDelta(widget.firstDate, _currentMonth));
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      key: _pageViewKey,
      controller: _pageController,
      itemBuilder: _buildItems,
      itemCount: DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
      onPageChanged: _handleMonthPageChanged,
    );
  }
}
