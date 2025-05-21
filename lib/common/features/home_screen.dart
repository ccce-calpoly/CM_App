import 'package:ccce_application/common/collections/calevent.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:ccce_application/common/widgets/cal_poly_menu_bar.dart';
import 'package:ccce_application/common/widgets/debug_outline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomeScreen({super.key, required this.scaffoldKey});
  @override
  CalendarScreenState createState() => CalendarScreenState();
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

class CalendarScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  String _name = "";
  DateTime _focusedDay = DateTime.now();
  int _focusedMonth = DateTime.now().month;
  int _focusedYear = DateTime.now().year;
  DateTime? _selectedDay;
  late HashMap<DateTime, List<CalEvent>> eventMap = HashMap();
  List _selectedEvents = [];
  bool _screenBool = false;

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

  void updateFocusedDates(day) {
    _focusedDay = day;
    _focusedMonth = _focusedDay.month;
    _focusedYear = _focusedDay.year;
    return;
  }

  void updateEventsForDay(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
      updateFocusedDates(selectedDay);
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

  List<Container> _getNextEvents(DateTime day) {
    List<CalEvent> nextEvents = [];
    List<Container> eventContainers = [];
    List<MapEntry<DateTime, List<CalEvent>>> sortedEntries =
        eventMap.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    for (var events in sortedEntries) {
      final eventDate = events.key;
      if (eventDate.isAfter(day) && nextEvents.length < 3) {
        // Check for future dates and limit to 3 events
        nextEvents.addAll(events.value); // Add all events for the current date
      }
      if (nextEvents.length >= 3) {
        break; // Stop iterating if we already found 3 events
      }
    }
    int it = 0;
    for (var ev in nextEvents) {
      Color boxColor =
          (it == 0) ? const Color(0xFFAAC9E8) : const Color(0xFFD5E3F4);
      it = it + 1;
      eventContainers.add(Container(
          child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Container(
                  height: 64,
                  width: 80,
                  decoration: BoxDecoration(
                    color: boxColor, // Adjust background color
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust border radius
                  ),
                  padding: const EdgeInsets.only(left: .0),
                  child: Center(
                    child: Text(
                        "${ev.startTime.toString().split(" ")[1].substring(0, 5)}-${ev.endTime.toString().split(" ")[1].substring(0, 5)}",
                        style: const TextStyle(
                            fontFamily: "SansSerifPro", fontSize: 10)),
                  ))),
          const SizedBox(width: 10.0), // Spacing between boxes
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: boxColor, // Adjust background color
                        borderRadius:
                            BorderRadius.circular(10.0), // Adjust border radius
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text(ev.eventName,
                              style: const TextStyle(
                                  fontFamily: "SansSerifProSemiBold",
                                  fontSize: 13)),
                          Text(ev.eventLocation,
                              style: const TextStyle(
                                  fontFamily: "SansSerifPro", fontSize: 10))
                        ],
                      )))) // Content for the second box
              // Optional padding
              ),
        ],
      )));
    }
    return eventContainers;
  }

  List<Widget> _getDayEvents(DateTime day) {
    List<Widget> eventContainers = [];
    List<CalEvent> evs = eventMap[day] ?? [];

    int it = 0;
    for (var ev in evs) {
      Color boxColor =
          (it == 0) ? const Color(0xFFAAC9E8) : const Color(0xFFD5E3F4);
      it = it + 1;
      eventContainers.add(Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: Container(
                  height: 64,
                  width: 80,
                  decoration: BoxDecoration(
                    color: boxColor, // Adjust background color
                    borderRadius:
                        BorderRadius.circular(10.0), // Adjust border radius
                  ),
                  child: Center(
                    child: Text(
                        "${ev.startTime.toString().split(" ")[1].substring(0, 5)}-${ev.endTime.toString().split(" ")[1].substring(0, 5)}",
                        style: const TextStyle(
                            fontFamily: "SansSerifPro", fontSize: 10)),
                  ))),
          const SizedBox(width: 10.0), // Spacing between boxes
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: boxColor, // Adjust background color
                        borderRadius:
                            BorderRadius.circular(10.0), // Adjust border radius
                      ),
                      child: Center(
                          child: Column(
                        children: [
                          Text(ev.eventName,
                              style: const TextStyle(
                                  fontFamily: "SansSerifProSemiBold",
                                  fontSize: 13)),
                          Text(ev.eventLocation,
                              style: const TextStyle(
                                  fontFamily: "SansSerifPro", fontSize: 10))
                        ],
                      )))) // Content for the second box
              // Optional padding
              ),
        ],
      ));
    }
    return eventContainers;
  }

  Widget buildCalendar(context) {
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
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white),
        markerSize: 6,
        markerDecoration:
            BoxDecoration(color: Color(0xFFE4E2D4), shape: BoxShape.circle),
        selectedDecoration:
            BoxDecoration(color: Color(0xFFA9A887), shape: BoxShape.circle),
        todayDecoration:
            BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.white)),
      headerVisible: false,
      availableGestures: AvailableGestures.horizontalSwipe,
      startingDayOfWeek: StartingDayOfWeek.monday,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          // Call `setState()` when updating calendar format
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _selectedDay = focusedDay;
          updateFocusedDates(focusedDay);
        });
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

  String fullDateFormatter(monthInt, year, day) {
    switch (monthInt) {
      case 1:
        return "January $day, ${year.toString()}";
      case 2:
        return "Feburary $day, ${year.toString()}";
      case 3:
        return "March $day, ${year.toString()}";
      case 4:
        return "April $day, ${year.toString()}";
      case 5:
        return "May $day, ${year.toString()}";
      case 6:
        return "June $day, ${year.toString()}";
      case 7:
        return "July $day, ${year.toString()}";
      case 8:
        return "August $day, ${year.toString()}";
      case 9:
        return "September $day, ${year.toString()}";
      case 10:
        return "October $day, ${year.toString()}";
      case 11:
        return "November $day, ${year.toString()}";
      case 12:
        return "December $day, ${year.toString()}";
      default:
        return year.toString();
    }
  }

  List<Widget> buildEventList(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    var eventContainers = _getDayEvents(_focusedDay);

    eventContainers = eventContainers.isEmpty
        ? [
              Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              "There are no events today. Checkout upcoming events below:",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "SansSerifProItalic",
                                  fontSize: 16))))),
              const SizedBox(
                  height: 30.0), // Optional spacing between containers
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // Apply border to the bottom
                        color: Colors.black,
                        width: 1.0, // Adjust line thickness
                      ),
                    ),
                  )),
              const SizedBox(height: 30.0),
            ] +
            _getNextEvents(_focusedDay)
        : eventContainers;

    var fullList = <Widget>[
      SizedBox(height: screenHeight * 0.02),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
            fullDateFormatter(_focusedMonth, _focusedYear, _focusedDay.day),
            style: const TextStyle(
                color: AppColors.tanText,
                fontFamily: "SansSerifPro",
                fontSize: 20)),
      )
    ];
    //eventContainers.toList();
    return fullList;
  }

  Widget buildEventDisplay(context) {
    return Row(children: [
      Expanded(
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildEventList(context))),
      ),
    ]);
  }

  Widget buildAnnouncementList(context) {
    var eventContainers = _getDayEvents(_focusedDay);

    eventContainers = eventContainers.isEmpty
        ? [
              Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              "There are no new announcements at this time.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "SansSerifProItalic",
                                  fontSize: 16))))),
              const SizedBox(
                  height: 30.0), // Optional spacing between containers
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // Apply border to the bottom
                        color: Colors.black,
                        width: 1.0, // Adjust line thickness
                      ),
                    ),
                  )),
              const SizedBox(height: 30.0),
            ] +
            _getNextEvents(_focusedDay)
        : eventContainers;

    var fullList = <Widget>[
          const SizedBox(height: 24),
          const Padding(
              padding: EdgeInsets.only(left: 36, top: 12),
              child: Row(children: [
                Icon(
                  Icons.circle_notifications,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text("Notification Board",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "SansSerifProSemiBold",
                        fontSize: 28)),
              ])),
          SizedBox(height: 10),
        ] +
        eventContainers.toList();
    return ListView(children: fullList);
  }

  Widget buildAnnouncementDisplay(context) {
    return Expanded(
      child: Container(
          decoration: BoxDecoration(
            color: calPolyGreen,
            borderRadius: BorderRadius.circular(40.0),
            // Adjust border radius
          ),
          child: buildAnnouncementList(context)),
    );
    //child: Column(
    //  children: <Widget>[const Text("HI"), buildEventList()])));
  }

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(
          Icons.circle_notifications,
          size: 24,
        );
      }
      return const Icon(Icons.calendar_month, color: Colors.black);
    },
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Widget calWidget = buildCalendar(context);
    Widget eventDisplayWidget = buildEventDisplay(context);
    Widget announcementDisplayWidget = buildAnnouncementDisplay(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          CalPolyMenuBar(scaffoldKey: widget.scaffoldKey),
          SizedBox(height: screenHeight * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  _screenBool ? "Notifications" : "Calendar",
                  style: const TextStyle(
                      color: AppColors.tanText,
                      fontWeight: FontWeight.w600,
                      fontSize: 26),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 20,
                    ),
                    Switch(
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      activeTrackColor: Colors.grey,
                      value: _screenBool,
                      onChanged: (value) {
                        setState(() {
                          _screenBool = value;
                        });
                      },
                    ),
                    const Icon(
                      Icons.circle_notifications,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(_name.isNotEmpty ? "Hi!" : "Hi! $_name",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          color: Colors.white))),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(dateFormatter(_focusedMonth, _focusedYear),
                    style: const TextStyle(
                      fontFamily: "SansSerifProSemiBold",
                      fontSize: 20,
                      color: AppColors.tanText,
                    )),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          _screenBool ? announcementDisplayWidget : calWidget,
          _screenBool ? Container() : eventDisplayWidget
        ]),
      ),
      backgroundColor: AppColors.calPolyGreen,
    );
  }
}
