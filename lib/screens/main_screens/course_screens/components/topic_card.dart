import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/main_screens/course_screens/course_screen.dart';
import 'package:mom/services/models/topic.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class TopicCard extends StatelessWidget {
  final Topic topic;

  TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.to(() => CourseScreen(topicId: topic.topicId));
        },
        child: CustomContainer(
          backgroundColor:
              Color(int.parse(topic.color!.replaceAll("#", "0xFF"))),
          marginHorizontal: 12,
          marginVertical: 12,
          paddingHorizontal: 12,
          paddingVertical: 12,
          // padding: const EdgeInsets.all(12),
          // margin: const EdgeInsets.all(8),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(12),
          //   color: Color(int.parse(topic.color!.replaceAll("#", "0xFF"))),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  topic.imgUrl,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  topic.title,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
