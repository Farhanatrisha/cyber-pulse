import 'package:flutter/material.dart';

class DateField extends StatefulWidget {
  final ValueChanged<DateTime?> onDateChanged;
  int? selectedDay;
  int? selectedMonth;
  int? selectedYear;

  DateField({required this.onDateChanged});

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text('Date of Birth*'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: widget.selectedDay,
                      decoration: InputDecoration(
                        labelText: 'Day',
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedDay = value;
                          _updateDate();
                        });
                      },
                      items: List.generate(
                        31,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: widget.selectedMonth,
                      decoration: InputDecoration(
                        labelText: 'Month',
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedMonth = value;
                          _updateDate();
                        });
                      },
                      items: List.generate(
                        12,
                            (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: widget.selectedYear,
                      decoration: InputDecoration(
                        labelText: 'Year',
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.selectedYear = value;
                          _updateDate();
                        });
                      },
                      items: List.generate(
                        123,
                            (index) => DropdownMenuItem(
                          value: DateTime.now().year - index,
                          child: Text('${DateTime.now().year - index}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateDate() {
    if (widget.selectedDay != null && widget.selectedMonth != null && widget.selectedYear != null) {
      final selectedDate = DateTime(widget.selectedYear!, widget.selectedMonth!, widget.selectedDay!);
      widget.onDateChanged(selectedDate);
    } else {
      widget.onDateChanged(null);
    }
    print("0---------------0:",);
  }


}