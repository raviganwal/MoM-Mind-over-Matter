import 'package:flutter/material.dart';
import 'package:mom/utils/my_enums.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizButton extends StatefulWidget {
  final String topicId;
  final QuizAction action;

  const QuizButton({Key? key, required this.topicId, required this.action}) : super(key: key);

  @override
  State<QuizButton> createState() => _QuizButtonState();
}

class _QuizButtonState extends State<QuizButton> {
  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('topics').where('topicId', isEqualTo: widget.topicId).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Text('No data found for topic ID ${widget.topicId}');
        } else {
          String quizId = (widget.action == QuizAction.start
              ? snapshot.data!.docs[0]['startQuiz']
              : snapshot.data!.docs[0]['endQuiz']) as String;
          return ButtonDesign(
            btnText: widget.action == QuizAction.start ? "Start Quiz" : "End Quiz",
            btnFunction: () async {
              await _launchUrl(Uri.parse(quizId));
              // Navigate to the quiz page using quizId
            },
            marginHorizontal: 20,
            marginVertical: 12,
            bgColor: const Color(0xFF80D0DD),
          );
        }
      },
    );
  }
}
