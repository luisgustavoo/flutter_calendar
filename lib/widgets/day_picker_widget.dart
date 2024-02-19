import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/day_widget.dart';
import 'package:flutter_calendar/widgets/enum/day_status.dart';

class DayPickerWidget extends StatefulWidget {
  const DayPickerWidget({
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    this.selectedDate,
    super.key,
  });

  final DateTime? selectedDate;

  final DateTime currentDate;

  final ValueChanged<DateTime> onChanged;

  final DateTime firstDate;

  final DateTime lastDate;

  final DateTime displayedMonth;

  @override
  State<DayPickerWidget> createState() => _DayPickerWidgetState();
}

class _DayPickerWidgetState extends State<DayPickerWidget> {
  final _monthPickerHorizontalPadding = 8.0;

  List<Widget> _dayHeaders(
      TextStyle? headerStyle, MaterialLocalizations localizations) {
    final List<Widget> result = <Widget>[];
    for (int i = localizations.firstDayOfWeekIndex;
        result.length < DateTime.daysPerWeek;
        i = (i + 1) % DateTime.daysPerWeek) {
      final String weekday = localizations.narrowWeekdays[i];
      result.add(
        ExcludeSemantics(
          child: Center(child: Text(weekday, style: headerStyle)),
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    const weekdayStyle = TextStyle(
      color: Colors.grey,
      fontSize: 25,
    );

    final List<Widget> dayItems = _dayHeaders(weekdayStyle, localizations);

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final dayToBuild = DateTime(year, month, day);

        // final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
        //     dayToBuild.isBefore(widget.firstDate);

        final bool isSelectedDay =
            DateUtils.isSameDay(widget.selectedDate, dayToBuild);
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);

        final bool isDisabled = dayToBuild.isBefore(widget.currentDate);

        final dayStatus = switch ((isDisabled, isSelectedDay, isToday)) {
          (true, _, _) => DayStatus.isDisabled,
          (_, true, _) => DayStatus.isSelectedDay,
          (_, _, true) => DayStatus.isToday,
          _ => DayStatus.none,
        };

        dayItems.add(
          DayWidget(
            day: dayToBuild,
            dayStatus: dayStatus,
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _monthPickerHorizontalPadding,
      ),
      child: GridView.custom(
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: DateTime.daysPerWeek,
        ),
        childrenDelegate: SliverChildListDelegate(
          dayItems,
          addRepaintBoundaries: false,
        ),
      ),
    );
  }
}
