import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/day_picker_widget.dart';

class MonthPickerWidget extends StatefulWidget {
  const MonthPickerWidget({
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    required this.onDisplayedMonthChanged,
    this.selectedDate,
    this.selectableDayPredicate,
    super.key,
  });

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
      displayedMonth: month,
    );
  }

  String _getMonthDescription(int month) {
    return switch (month) {
      DateTime.january => 'Janeiro',
      DateTime.february => 'Fevereiro',
      DateTime.march => 'Março',
      DateTime.april => 'Abril',
      DateTime.may => 'Maio',
      DateTime.june => 'Junho',
      DateTime.july => 'Julho',
      DateTime.august => 'Agosto',
      DateTime.september => 'Setembro',
      DateTime.october => 'Outubro',
      DateTime.november => 'Novembro',
      DateTime.december => 'Dezembro',
      _ => 'Desconhecido'
    };
  }

  void _changeMonth(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();

    _currentMonth = widget.firstDate;
    _pageController = PageController(
      initialPage: DateUtils.monthDelta(
        widget.firstDate,
        _currentMonth,
      ),
    );

    Future.delayed(
      const Duration(seconds: 2),
    ).whenComplete(
      () {
        // monthAndYearToPageList = _monthAndYearToPage();
        // final date = monthAndYearToPageList.firstWhere(
        //     (element) => element.month == 2 && element.year == 2040);
        setState(
          () {
            // _handleMonthPageChanged(date.page);
            _pageController.jumpToPage(
              DateUtils.monthDelta(
                _currentMonth,
                DateTime(2040, 2),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeaderMonth(),
        Expanded(
          child: PageView.builder(
            key: _pageViewKey,
            controller: _pageController,
            itemBuilder: _buildItems,
            itemCount:
                DateUtils.monthDelta(widget.firstDate, widget.lastDate) + 1,
            onPageChanged: _handleMonthPageChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderMonth() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            _getMonthDescription(_currentMonth.month),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            _currentMonth.year.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final currentPage = _pageController.page?.toInt() ?? 0;
                  _changeMonth(currentPage - 1);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              IconButton(
                onPressed: () {
                  final currentPage = _pageController.page?.toInt() ?? 0;
                  _changeMonth(currentPage + 1);
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
