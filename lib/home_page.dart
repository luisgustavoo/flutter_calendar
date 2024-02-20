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
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2025),
              );
            },
            icon: const Icon(
              Icons.date_range_rounded,
            ),
          ),
        ],
      ),
      body: CalendarDatePickerWidget(
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        currentDate: DateTime.now(),
        initialDate: DateTime.now(),
        onDateChanged: (value) {
          // setState(() {
          //   _selectedDate = value;
          // });
        },
      ),
    );
  }
}
