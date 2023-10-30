import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class SprintProgressBar extends StatelessWidget {
  final int sprintDay;
  final int programLength;

  const SprintProgressBar(
      {super.key, required this.sprintDay, required this.programLength});

  @override
  Widget build(BuildContext context) {
    double percentage = sprintDay / programLength;
    final firebaseController = Get.put(FirebaseController());

    return CustomContainer(
      backgroundColor: Colors.white,
      marginHorizontal: 20,
      marginVertical: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String>(
            future: firebaseController.fetchTopicName(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    snapshot.data as String,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                );
              } else {
                return const Text('Error fetching topic name');
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Progress",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: Colors.white54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    '${(percentage * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            height: 25,
            child: Stack(
              children: [
                Container(
                  width: percentage * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFF58315A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: const SizedBox()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
