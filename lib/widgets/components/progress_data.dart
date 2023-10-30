import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/sprint.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart'; // import the Firebase controller

class MyProgressData extends StatefulWidget {
  int programLeng;
  String topicId;

  MyProgressData({super.key, required this.programLeng, required this.topicId});

  @override
  _MyProgressDataState createState() => _MyProgressDataState();
}

class _MyProgressDataState extends State<MyProgressData> {
  int totalLessons = 1; // set the total lessons here

  // create a function to fetch the current level
  Future<int> _getCurrentLevel() async {
    FirebaseController firebaseController = FirebaseController();
    Sprint? sprint = await firebaseController.getSprint(widget.topicId);
    return sprint.day;
  }

  @override
  void initState() {
    totalLessons = widget.programLeng;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      marginHorizontal: 20,
      paddingVertical: 18,
      backgroundColor: const Color(0xFF66C4BC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                totalLessons.toString(),
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 38,
                ),
              ),
              Text(
                'Total Lessons',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Column(
            children: [
              FutureBuilder<int>(
                future: _getCurrentLevel(),
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data.toString(),
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              Text(
                'Current Level',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
