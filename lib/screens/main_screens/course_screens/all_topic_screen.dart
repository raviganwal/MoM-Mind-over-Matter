import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/screens/main_screens/course_screens/components/topic_card.dart';
import 'package:mom/services/models/topic.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class AllTopicScreen extends StatefulWidget {
  const AllTopicScreen({super.key});

  @override
  _AllTopicScreenState createState() => _AllTopicScreenState();
}

class _AllTopicScreenState extends State<AllTopicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomHeader(title: "Topics"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder(
        future:
            fetchTopicsFromFirebase(), // Create this function to fetch topics from Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // Show a loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (!snapshot.hasData ||
              (snapshot.data as List<Topic>).isEmpty) {
            return const Text("No topics available."); // Handle no topics case
          } else {
            // Display topics as a GridView
            List<Topic> topics = snapshot.data as List<Topic>;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    2, // You can adjust the number of columns as needed
              ),
              itemCount: topics.length,
              itemBuilder: (context, index) {
                Topic topic = topics[index];
                return TopicCard(topic: topic);
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Topic>> fetchTopicsFromFirebase() async {
    // Fetch topics from Firebase and return a list of Topic objects
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('topics').get();

    List<Topic> topics = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      Topic topic = Topic.fromJson(doc.data());
      topics.add(topic);
    }

    return topics;
  }
}
