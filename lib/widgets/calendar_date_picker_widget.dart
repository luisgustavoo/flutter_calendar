import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/month_picker_widgetr.dart';

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
      initialMonth: _currentDisplayedMonthDate,
      currentDate: widget.currentDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      onChanged: _handleDayChanged,
      onDisplayedMonthChanged: _handleMonthChanged,
      selectedDate: _selectedDate,
    );
  }

  // PageView.builder(
  //                 key: _pageViewKey,
  //                 controller: _pageController,
  //                 itemBuilder: _buildItems,
  //                 itemCount: DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
  //                 onPageChanged: _handleMonthPageChanged,
  //               ),

  //   void _handleMonthPageChanged(int monthPage) {
  //   setState(() {
  //     final DateTime monthDate = DateUtils.addMonthsToMonthDate(widget.firstDate, monthPage);
  //     if (!DateUtils.isSameMonth(_currentMonth, monthDate)) {
  //       _currentMonth = DateTime(monthDate.year, monthDate.month);
  //       widget.onDisplayedMonthChanged(_currentMonth);
  //       if (_focusedDay != null && !DateUtils.isSameMonth(_focusedDay, _currentMonth)) {
  //         // We have navigated to a new month with the grid focused, but the
  //         // focused day is not in this month. Choose a new one trying to keep
  //         // the same day of the month.
  //         _focusedDay = _focusableDayForMonth(_currentMonth, _focusedDay!.day);
  //       }
  //       SemanticsService.announce(
  //         _localizations.formatMonthYear(_currentMonth),
  //         _textDirection,
  //       );
  //     }
  //   });
  // }

  //   Widget _buildItems(BuildContext context, int index) {
  //   final DateTime month = DateUtils.addMonthsToMonthDate(widget.firstDate, index);
  //   return _DayPicker(
  //     key: ValueKey<DateTime>(month),
  //     selectedDate: widget.selectedDate,
  //     currentDate: widget.currentDate,
  //     onChanged: _handleDateSelected,
  //     firstDate: widget.firstDate,
  //     lastDate: widget.lastDate,
  //     displayedMonth: month,
  //     selectableDayPredicate: widget.selectableDayPredicate,
  //   );
  // }

  //   int day = -dayOffset;
  // while (day < daysInMonth) {
  //   day++;
  //   if (day < 1) {
  //     dayItems.add(Container());
  //   } else {
  //     final DateTime dayToBuild = DateTime(year, month, day);
  //     final bool isDisabled =
  //       dayToBuild.isAfter(widget.lastDate) ||
  //       dayToBuild.isBefore(widget.firstDate) ||
  //       (widget.selectableDayPredicate != null && !widget.selectableDayPredicate!(dayToBuild));
  //     final bool isSelectedDay = DateUtils.isSameDay(widget.selectedDate, dayToBuild);
  //     final bool isToday = DateUtils.isSameDay(widget.currentDate, dayToBuild);

  //     dayItems.add(
  //       _Day(
  //         dayToBuild,
  //         key: ValueKey<DateTime>(dayToBuild),
  //         isDisabled: isDisabled,
  //         isSelectedDay: isSelectedDay,
  //         isToday: isToday,
  //         onChanged: widget.onChanged,
  //         focusNode: _dayFocusNodes[day - 1],
  //       ),
  //     );
  //   }
  // }

  // Widget dayWidget = Container(
  //   decoration: decoration,
  //   child: Center(
  //     child: Text(localizations.formatDecimal(widget.day.day), style: dayStyle?.apply(color: dayForegroundColor)),
  //   ),
  // );

  // if (widget.isDisabled) {
  //   dayWidget = ExcludeSemantics(
  //     child: dayWidget,
  //   );
  // } else {
  //   dayWidget = InkResponse(
  //     focusNode: widget.focusNode,
  //     onTap: () => widget.onChanged(widget.day),
  //     radius: _dayPickerRowHeight / 2 + 4,
  //     statesController: _statesController,
  //     overlayColor: dayOverlayColor,
  //     child: Semantics(
  //       // We want the day of month to be spoken first irrespective of the
  //       // locale-specific preferences or TextDirection. This is because
  //       // an accessibility user is more likely to be interested in the
  //       // day of month before the rest of the date, as they are looking
  //       // for the day of month. To do that we prepend day of month to the
  //       // formatted full date.
  //       label: '${localizations.formatDecimal(widget.day.day)}, ${localizations.formatFullDate(widget.day)}$semanticLabelSuffix',
  //       // Set button to true to make the date selectable.
  //       button: true,
  //       selected: widget.isSelectedDay,
  //       excludeSemantics: true,
  //       child: dayWidget,
  //     ),
  //   );
  // }
}
