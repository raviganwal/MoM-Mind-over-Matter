import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/services/models/checkin.dart';
import 'package:mom/utils/global_const.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

class TrackHistoryScreen extends StatefulWidget {
  const TrackHistoryScreen({super.key});

  @override
  State<TrackHistoryScreen> createState() => _TrackHistoryScreenState();
}

class _TrackHistoryScreenState extends State<TrackHistoryScreen> {
  int totalCheckins = 0;

  Map<DateTime, String> dateToImage = {};
  Map<DateTime, String> dateToSleep = {};

  List<String> _getEventForTheDay(DateTime day) {
    final formattedDateKey = DateTime(day.year, day.month, day.day);
    final events = dateToImage.entries
        .where((entry) =>
            DateTime(entry.key.year, entry.key.month, entry.key.day)
                .isAtSameMomentAs(formattedDateKey))
        .map((entry) => entry.value)
        .toList();

    return events.isNotEmpty ? events : [''];
  }

  List<String> _getSleepEventForTheDay(DateTime day) {
    final formattedDateKey = DateTime(day.year, day.month, day.day);
    final events = dateToSleep.entries
        .where((entry) =>
            DateTime(entry.key.year, entry.key.month, entry.key.day)
                .isAtSameMomentAs(formattedDateKey))
        .map((entry) => entry.value)
        .toList();

    return events.isNotEmpty ? events : [''];
  }

  @override
  void initState() {
    _getCheckins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Checkin>>(
        future: _getCheckins(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              // Empty state text when no data is available
              return const Center(
                child: Text(
                  'No entries available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              );
            } else {
              final moodData = snapshot.data!
                  .map((checkin) => checkin.mood)
                  .fold<Map<String, int>>(
                    {},
                    (Map<String, int> map, String mood) => map
                      ..update(mood, (count) => count + 1, ifAbsent: () => 1),
                  )
                  .entries
                  .toList();

              final sleepData = snapshot.data!
                  .map((checkin) => checkin.sleep)
                  .fold<Map<String, int>>(
                    {},
                    (Map<String, int> map, String sleep) => map
                      ..update(sleep, (count) => count + 1, ifAbsent: () => 1),
                  )
                  .entries
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Mood Statistics",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2100, 3, 14),
                        focusedDay: DateTime.now(),
                        eventLoader: _getEventForTheDay,
                        calendarBuilders: CalendarBuilders<String>(
                          markerBuilder: (context, day, events) {
                            if (events.isNotEmpty) {
                              if (events.first.isNotEmpty) {
                                return Center(
                                  child: Image.asset(events.first,
                                      height: 30, width: 30),
                                );
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      series: <CircularSeries>[
                        PieSeries<MapEntry<String, int>, String>(
                          dataSource: moodData,
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) => entry.value,
                          dataLabelMapper: (datum, index) {
                            return '${(datum.value / totalCheckins * 100).toStringAsFixed(0)}%';
                          },
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Update the colors for mood data
                          pointColorMapper: (entry, _) {
                            switch (entry.key) {
                              case 'depressed':
                                return Colors.red;
                              case 'sad':
                                return Colors.blue;
                              case 'neutral':
                                return Colors.purple;
                              case 'happy':
                                return Colors.green;
                              case 'blissful':
                                return Colors.yellow;
                              default:
                                return Colors.black;
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Sleep statistics",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2100, 3, 14),
                        focusedDay: DateTime.now(),
                        eventLoader:
                            _getSleepEventForTheDay, // Use sleep event loader
                        calendarBuilders: CalendarBuilders<String>(
                          markerBuilder: (context, day, events) {
                            if (events.isNotEmpty) {
                              if (events.first.isNotEmpty) {
                                return Center(
                                  child: Image.asset(events.first,
                                      height: 30, width: 30),
                                );
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SfCircularChart(
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                      ),
                      series: <CircularSeries>[
                        DoughnutSeries<MapEntry<String, int>, String>(
                          dataSource: sleepData,
                          xValueMapper: (entry, _) => entry.key,
                          yValueMapper: (entry, _) => entry.value,
                          dataLabelMapper: (datum, index) {
                            return '${(datum.value / totalCheckins * 100).toStringAsFixed(0)}%';
                          },
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.inside,
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Update the colors for sleep data
                          pointColorMapper: (entry, _) {
                            switch (entry.key) {
                              case 'poor':
                                return Colors.red;
                              case 'fair':
                                return Colors.blue;
                              case 'adequate':
                                return Colors.indigo;
                              case 'good':
                                return Colors.green;
                              case 'great':
                                return Colors.yellow;
                              case 'excellent':
                                return Colors.purple;
                              case 'superb':
                                return Colors.teal;
                              default:
                                return Colors.black;
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Checkin>> _getCheckins() async {
    QuerySnapshot checkinSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('checkin')
        .get();

    List<Checkin> checkins = [];
    for (var doc in checkinSnapshots.docs) {
      final newValue = doc.data() as Map<String, dynamic>;
      checkins.add(Checkin.fromJson(newValue));
    }
    totalCheckins = checkins.length;

    //Mood Calendar Data
    for (var doc in checkins) {
      final datetime = doc.datetime;
      final tempImg = doc.mood;
      final imageFilename = 'assets/images/mood/$tempImg.png';
      dateToImage.assign(
          DateTime.fromMillisecondsSinceEpoch(int.parse(datetime)),
          imageFilename);
    }

    // Sleep Calendar Data
    for (var doc in checkins) {
      final datetime = doc.datetime;
      final tempSleep = doc.sleep;
      final sleepFilename = 'assets/images/sleep/$tempSleep.png';
      dateToSleep.assign(
          DateTime.fromMillisecondsSinceEpoch(int.parse(datetime)),
          sleepFilename);
    }

    return checkins;
  }
}
