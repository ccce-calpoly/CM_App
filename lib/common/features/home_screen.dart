import 'package:ccce_application/common/collections/calevent.dart';
import 'package:ccce_application/common/theme/colors.dart';
import 'package:ccce_application/common/widgets/cal_poly_menu_bar.dart';
import 'package:ccce_application/common/widgets/debug_outline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'package:intl/intl.dart';

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

class NotificationItem {
  final String title;
  final String message;
  final DateTime dateTime;
  NotificationItem(
      {required this.title, required this.message, required this.dateTime});
}

List<NotificationItem> mockNotifications = [
  NotificationItem(
    title: 'Jeong Woo',
    message: 'Remember to bring hard hats on February 23rd!',
    dateTime: DateTime(2024, 2, 14, 9, 0),
  ),
  NotificationItem(
    title: 'HITT Info Session',
    message: 'Please submit all senior photos by this Friday!',
    dateTime: DateTime(2024, 2, 14, 10, 0),
  ),
  NotificationItem(
    title: 'Emma Blair',
    message: 'Pick up keycards for Construction Management room.',
    dateTime: DateTime(2024, 2, 13, 8, 0),
  ),
  NotificationItem(
    title: 'Jeong Woo',
    message: 'Bring graduation cords Tuesday.',
    dateTime: DateTime(2024, 2, 13, 11, 0),
  ),
];

Map<String, List<NotificationItem>> groupNotifications(
    List<NotificationItem> notifications) {
  Map<String, List<NotificationItem>> grouped = {};
  for (var n in notifications) {
    String dateKey = DateFormat('yyyy-MM-dd').format(n.dateTime);
    if (!grouped.containsKey(dateKey)) {
      grouped[dateKey] = [];
    }
    grouped[dateKey]!.add(n);
  }
  return grouped;
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

  List<Widget> _getNextEvents(DateTime day) {
    List<CalEvent> nextEvents = [];
    List<Widget> eventContainers = [];
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
      Color boxColor = Colors.white;
      it = it + 1;
      eventContainers.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
          child: Row(
            children: [
              Container(
                  height: 65,
                  width: 80,
                  decoration: BoxDecoration(
                    color: boxColor, // Adjust background color
                  ),
                  child: Center(
                    child: Text(
                      "${DateFormat('hh:mm a').format(ev.startTime)}-${DateFormat('hh:mm a').format(ev.endTime)}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: "SansSerifPro", fontSize: 10),
                    ),
                  )),
              const SizedBox(width: 1),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color:
                              boxColor // Adjust background color, // Adjust border radius
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
                      ))) // Content for the second box
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
      Color boxColor = Colors.white;
      it = it + 1;
      eventContainers.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1.0),
        child: Row(
          children: [
            Container(
                height: 65,
                width: 80,
                decoration: BoxDecoration(
                  color: boxColor, // Adjust background color
                ),
                child: Center(
                  child: Text(
                    "${DateFormat('hh:mm a').format(ev.startTime)}\n-\n${DateFormat('hh:mm a').format(ev.endTime)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "SansSerifPro",
                      fontSize: 11,
                    ),
                  ),
                )),
            const SizedBox(width: 1), // Spacing between boxes
            const SizedBox(width: 1),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: boxColor, // Adjust background color
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
                    ))) // Content for the second box
                // Optional padding
                ),
          ],
        ),
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

    if (eventContainers.isEmpty) {
      return [
        SizedBox(height: screenHeight * 0.02),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
              fullDateFormatter(_focusedMonth, _focusedYear, _focusedDay.day),
              style: const TextStyle(
                  color: AppColors.tanText,
                  fontFamily: "SansSerifPro",
                  fontSize: 20)),
        ),
        SizedBox(height: screenHeight * 0.01),
        Container(
            height: screenHeight * 0.08,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: const Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        "There are no events today.\nCheckout upcoming events below:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "SansSerifProItalic", fontSize: 14))))),
        const SizedBox(height: 10.0),
        ..._getNextEvents(_focusedDay),
        const SizedBox(height: 20.0),
      ];
    }

    return [
      SizedBox(height: screenHeight * 0.02),
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
            fullDateFormatter(_focusedMonth, _focusedYear, _focusedDay.day),
            style: const TextStyle(
                color: AppColors.tanText,
                fontFamily: "SansSerifPro",
                fontSize: 20)),
      ),
      SizedBox(height: screenHeight * 0.01),
      ...eventContainers,
      const SizedBox(height: 20.0),
    ];
  }

  Widget buildEventDisplay(context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildEventList(context)),
      ),
    );
  }

  Widget buildAnnouncementList(context) {
    final now = DateTime.now();
    List<NotificationItem> upcoming = mockNotifications
        .where(
            (n) => !n.dateTime.isBefore(DateTime(now.year, now.month, now.day)))
        .toList();
    List<NotificationItem> past = mockNotifications
        .where(
            (n) => n.dateTime.isBefore(DateTime(now.year, now.month, now.day)))
        .toList();
    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    past.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    Widget sectionHeader(String text, {bool italic = false}) => Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.tanText,
              fontFamily: italic ? "SansSerifProItalic" : "SansSerifPro",
              fontSize: 24,
              fontStyle: italic ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        );

    Widget dateHeader(DateTime date) => Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            DateFormat('EEEE, MMMM d').format(date),
            style: const TextStyle(
              color: AppColors.tanText,
              fontFamily: "SansSerifPro",
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

    Widget notificationRow(NotificationItem n) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
          child: Row(
            children: [
              Container(
                height: 70,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    right: BorderSide(color: Color(0xFFE4E2D4), width: 2),
                  ),
                ),
                child: Center(
                  child: Text(
                    DateFormat('h:mm a\nMMM d').format(n.dateTime),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "SansSerifPro",
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 1),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.notifications_active,
                          color: Color(0xFF003831), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.title,
                              style: const TextStyle(
                                fontFamily: "SansSerifProSemiBold",
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              n.message,
                              style: const TextStyle(
                                fontFamily: "SansSerifPro",
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

    List<Widget> buildSection(String sectionTitle, List<NotificationItem> items,
        {bool italic = false}) {
      if (items.isEmpty) return [];
      final grouped = groupNotifications(items);
      final sortedKeys = grouped.keys.toList()
        ..sort((a, b) => DateTime.parse(a).compareTo(DateTime.parse(b)));
      return [sectionHeader(sectionTitle, italic: italic)] +
          [
            for (final dateKey in sortedKeys) ...[
              dateHeader(DateTime.parse(dateKey)),
              ...grouped[dateKey]!.map(notificationRow).toList(),
            ]
          ];
    }

    return ListView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      children: [
        ...buildSection('Upcoming', upcoming),
        ...buildSection('Past', past, italic: true),
      ],
    );
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
