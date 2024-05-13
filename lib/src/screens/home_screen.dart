import 'package:ccce_application/src/collections/calevent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

Future<HashMap<DateTime, List<CalEvent>>> fetchEvents() async {
  final snapshot = await FirebaseFirestore.instance.collection('events').get();
  HashMap<DateTime, List<CalEvent>> events = HashMap();

  for (final doc in snapshot.docs) {
    final event = CalEvent.fromSnapshot(doc);
    var start = event.startTime;
    final date = DateTime.utc(
      start.year,
      start.month,
      start.day,
    ); // Format date as YYYY-MM-DD

    events.update(date, (value) {
      value.add(event);
      return value;
    }, ifAbsent: () => <CalEvent>[event]);
  }

  return events;
}

class _CalendarScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _name = "";
  DateTime _focusedDay = DateTime.now();
  int _focusedMonth = DateTime.now().month;
  int _focusedYear = DateTime.now().year;
  DateTime? _selectedDay;
  late HashMap<DateTime, List<CalEvent>> eventMap = HashMap();
  List _selectedEvents = [];

  static const calPolyGreen = Color(0xFF003831);
  static const appBackgroundColor = Color(0xFFE4E3D3);

  @override
  void initState() {
    super.initState();
    _focusedMonth = _focusedDay.month;
    _focusedYear = _focusedDay.year;
    fetchEvents().then((events) {
      setState(() {
        eventMap = events;
      });
    });
  }

  void updateEventsForDay(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay;
      // _focusedMonth = _focusedDay.month;
      // _focusedYear = _focusedDay.year;
      //print(selectedDay);
      _selectedEvents = _eventLoader(selectedDay);
    });
  }

  List<CalEvent> _eventLoader(DateTime day) {
    final events = _getEventsForDay(day);
    //print('${day} ${events}');
    return events;
  }

  var events = fetchEvents();

  List<CalEvent> _getEventsForDay(DateTime day) {
    return eventMap.putIfAbsent(day, () => <CalEvent>[]);
    //return events.values.expand((list) => list).where((event) => isSameDay(event.startTime, day)).toList();
  }

  Widget buildCalendar() {
    return TableCalendar<CalEvent>(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        updateEventsForDay(selectedDay);
      },
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(day);

            return Center(
              child: Text(
                text,
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
      headerVisible: false,
      // headerStyle: const HeaderStyle(
      //   titleCentered: true,
      //   formatButtonVisible: false, // Hide the format button
      // ),
      availableGestures: AvailableGestures.horizontalSwipe,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        // No need to call `setState()` here
        _focusedDay = focusedDay;
      },
      eventLoader: (day) => _eventLoader(day),
    );
  }

  String dateFormatter(monthInt, year) {
    switch (monthInt) {
      case 1:
        return "January ${year.toString()}";
      case 2:
        return "Feburary ${year.toString()}";
      case 3:
        return "March ${year.toString()}";
      case 4:
        return "April ${year.toString()}";
      case 5:
        return "May ${year.toString()}";
      case 6:
        return "June ${year.toString()}";
      case 7:
        return "July ${year.toString()}";
      case 8:
        return "August ${year.toString()}";
      case 9:
        return "September ${year.toString()}";
      case 10:
        return "October ${year.toString()}";
      case 11:
        return "November ${year.toString()}";
      case 12:
        return "December ${year.toString()}";
      default:
        return year.toString();
    }
  }

  Widget buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  //onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 36.0, bottom: 4.0),
                child: Text(_name.isNotEmpty ? "Hi!" : "Hi! ${_name}",
                    style: const TextStyle(
                        fontFamily: "SansSerifProSemiBold",
                        fontSize: 36,
                        color: Colors.white)))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 36.0, bottom: 24.0),
                child: Text(dateFormatter(_focusedMonth, _focusedYear),
                    style: const TextStyle(
                        fontFamily: "SansSerifProSemiBold",
                        fontSize: 20,
                        color: Colors.white)))
          ],
        ),
        buildCalendar(),
        Expanded(
          child: buildEventList(),
        )
      ]),
      backgroundColor: Color(0xffcecca0),
    );
  }
}
