import 'package:flutter/material.dart';
import 'package:flutter_calendar/widgets/calendar_date_picker_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _selectedDate = DateTime(
    //   DateTime.now().year,
    //   DateTime.now().month,
    //   DateTime.now().day,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarDatePickerWidget(
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        currentDate: DateTime.now(),
        initialDate: DateTime.now(),
        onDateChanged: (value) {
          // setState(() {
          //   _selectedDate = value;
          // });
        },
        onDisplayedMonthChanged: (value) {
          // setState(() {
          //   _selectedDate = value;
          // });
        },
      ),
    );
  }
}
