import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/sprint.dart';

class MyBadgesWidget extends StatelessWidget {
  final String activeTopic; // the active topic ID for the user

  const MyBadgesWidget({Key? key, required this.activeTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseController = Get.put(FirebaseController());

    return FutureBuilder<Sprint?>(
      future: firebaseController.getSprint(activeTopic),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final sprint = snapshot.data!;
        final completedDays = sprint.day;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Badges',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(11, (index) {
                  final milestoneDay = [1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21][index];
                  final isCompleted = milestoneDay <= completedDays;
                  final badgeName = [
                    'Mindful Starter',
                    'Resilience Warrior',
                    'Calm Achiever',
                    'Serenity Seeker',
                    'Balance Champion',
                    'Gratitude Guru',
                    'Focus Master',
                    'Relaxation Expert',
                    'Positivity Ambassador',
                    'Inner Peace Conqueror',
                    'Mental Wellness Champion',
                  ][index];

                  return Center(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              isCompleted ? 'assets/images/badge_1.png' : 'assets/images/badge_greyed.png',
                              height: 75,
                              width: 75,
                            ),
                            Center(
                              child: Text(
                                '$milestoneDay',
                                style: GoogleFonts.bangers(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // Grey out badge if not completed
                          ],
                        ),
                        const SizedBox(height: 8),
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              badgeName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}
