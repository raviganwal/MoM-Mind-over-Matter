import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mom/screens/feature_screens/track_screens/checkin_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/program.dart';
import 'package:mom/widgets/components/alert_popup.dart';
import 'package:mom/widgets/components/badges_widget.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/progress_bar.dart';
import 'package:mom/widgets/components/progress_data.dart';

class TrackDashboardScreen extends StatelessWidget {
  const TrackDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseController firebaseController = FirebaseController();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ButtonDesign(
            btnText: "Check-in",
            width: 165,
            height: 48,
            paddingValue: 7,
            prefixWidget: const Icon(
              Icons.check_circle_outline_outlined,
              color: Color(0xFF58315A),
            ),
            btnFunction: () async {
              final isCheckinDataAlreadyPresent =
                  await firebaseController.isCheckinAvailableForToday();
              if (isCheckinDataAlreadyPresent) {
                // Check-in already available for today, show AlertDialog
                Get.dialog(AlertPopup(
                    message: "You have already done a check-in today.",
                    btnName: "Okay",
                    onBtnPress: () {
                      Get.back();
                    }));
              } else {
                // No check-in for today, navigate to the check-in screen
                Get.to(() => const CheckinScreen(),
                    transition: Transition.downToUp);
              }
            }),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<String?>(
              future: FirebaseController.getActiveTopic(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final activeTopicId = snapshot.data!;
                  return FutureBuilder<List<Program>>(
                    future:
                        FirebaseController.getProgramsForTopic(activeTopicId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // While the future is still resolving
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        // When the future has successfully resolved and there is data
                        final programs = snapshot.data!;
                        return Column(
                          children: [
                            ProgressBarWidget(
                              activeTopic: activeTopicId,
                              programLength: programs.length,
                            ),
                            MyProgressData(
                              topicId: activeTopicId,
                              programLeng: programs.length,
                            ),
                            MyBadgesWidget(activeTopic: activeTopicId),
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        // When the future has successfully resolved but there is no data
                        return const Text('No programs found.');
                      } else {
                        // When there is an error or the future has not yet resolved
                        return const Text('Error fetching programs.');
                      }
                    },
                  );
                } else {
                  return Center(
                      child: ButtonDesign(
                    btnText: "Something went wrong",
                    btnFunction: () {},
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
