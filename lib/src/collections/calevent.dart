import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CalEvent {
  String id;
  String eventName;
  DateTime startTime;
  DateTime endTime;
  String eventLocation;

  InfoSessionData? isd;

  CalEvent(
      {required this.id,
      required this.eventName,
      required this.startTime,
      required this.endTime,
      required this.eventLocation,
      this.isd});

  @override
  String toString() {
    return eventName;
  }

  factory CalEvent.fromSnapshot(DocumentSnapshot doc) {
    String eventName = doc.get("company");
    String openPositions =
        doc.get("isHiring") == "No" ? "" : doc.get("position");
    DateTime startTime = doc.get("startTime").toDate();

    // Extract data from the snapshot
    return CalEvent(
        id: doc.id,
        eventName: eventName,
        startTime: startTime,
        endTime: startTime.add(const Duration(hours: 1)),
        eventLocation: doc.get("mainLocation"),
        isd: InfoSessionData(
            doc.get("company"),
            doc.get("website"),
            doc.get("interviewLocation"),
            doc.get("contactName"),
            doc.get("contactEmail"),
            openPositions,
            doc.get("jobLocations"),
            doc.get("interviewLink")));
  }
}

class InfoSessionData {
  String? companyName = "";
  String? website = "";
  String? interviewLocation = "";
  String? recruiterName = "";
  String? recruiterEmail = "";
  String? openPositions = "";
  String? jobLocations = "";
  String? interviewLink = "";

  InfoSessionData(
      this.companyName,
      this.website,
      this.interviewLocation,
      this.recruiterName,
      this.recruiterEmail,
      this.openPositions,
      this.jobLocations,
      this.interviewLink);
}
