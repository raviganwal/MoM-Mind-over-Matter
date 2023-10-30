import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/sprint.dart';
import 'package:mom/widgets/ui_widgets/sprint_progressbar.dart';

class ProgressBarWidget extends StatelessWidget {
  final String activeTopic;
  final int programLength;

  const ProgressBarWidget(
      {super.key, required this.activeTopic, required this.programLength});

  @override
  Widget build(BuildContext context) {
    final firebaseController = Get.put(FirebaseController());
    return FutureBuilder<Sprint?>(
      future: firebaseController.getSprint(activeTopic),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final sprint = snapshot.data;
          if (sprint != null) {
            return SprintProgressBar(
              sprintDay: sprint.day,
              programLength: programLength,
            );
          } else {
            return const Text('No sprint found for active topic');
          }
        }
      },
    );
  }
}
