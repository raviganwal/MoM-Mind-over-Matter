import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/auth_screens/splashscreen.dart';
import 'package:mom/screens/main_screens/nav_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/services/models/topic.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/no_network_popup.dart';

class SelectTopicScreen extends StatefulWidget {
  bool isBoarding = false;

  SelectTopicScreen({super.key, required this.isBoarding});

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  String activeTopicId = "1";
  bool _isLoading = false;
  late Stream<QuerySnapshot> _topicsStream;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _topicsStream = FirebaseFirestore.instance.collection('topics').snapshots();
  }

  void _loadUserData() async {
    User? userData = await FirebaseController.fetchUserDataFromFirebase();
    if (userData != null) {
      setState(() {
        activeTopicId = userData.enrolledTopic;
      });
    } else {
      activeTopicId = "1";
    }
  }

  void _startButtonPressed() async {
    Fluttertoast.showToast(msg: "Topic picked successfully");
    bool networkState = await checkConnectivity();
    if (networkState) {
      // try {
      //   await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(firebaseAuth.currentUser!.uid)
      //       .update({'enrolledTopic': activeTopicId});

      //   //Fetch the topic again
      //   FirebaseController.getActiveTopic();
      // } catch (e) {
      //   Fluttertoast.showToast(msg: "Something went wrong");
      //   debugPrint(e.toString());
      // }
      if (widget.isBoarding) {
        Get.to(() => NavScreen());
      } else {
        Get.back();
        Get.offAll(() => SplashScreen());
      }
    } else {
      Get.dialog(const NoNetworkPopup());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: ButtonDesign(
          btnText: "Start",
          height: 68,
          btnFunction: _isLoading ? () {} : _startButtonPressed,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          Container(
            margin:
                EdgeInsets.only(top: 0),
            child: Image.asset(
              "assets/images/ui_components/union.png",
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeatX,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "What brings you",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "to Mind over Matter?",
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Choose a topic to focus on...",
                      style: GoogleFonts.openSans(
                        color: const Color(0xFF555555),
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TopicGridView(
                        activeTopicId: activeTopicId,
                        topicsStream: _topicsStream,
                        onTopicSelected: (String topicId) {
                          setState(() {
                            activeTopicId = topicId;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 125),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopicGridView extends StatelessWidget {
  final String activeTopicId;
  final Stream<QuerySnapshot> topicsStream;
  final Function(String) onTopicSelected;

  const TopicGridView({
    super.key,
    required this.activeTopicId,
    required this.topicsStream,
    required this.onTopicSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: topicsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final List<QueryDocumentSnapshot> topics = snapshot.data!.docs;
        final List<Topic> topicList = [];
        for (var eachTopic in topics) {
          if (eachTopic.data() != null) {
            Topic topicData =
                Topic.fromJson(eachTopic.data() as Map<String, dynamic>);
            topicList.add(topicData);
          }
        }
        return GridView.count(
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: topicList
              .map(
                (Topic doc) => TopicCard(
                  topicId: doc.topicId,
                  title: doc.title,
                  description: doc.description,
                  imgUrl: doc.imgUrl,
                  isActive: doc.topicId == activeTopicId,
                  backgroundColor:
                      Color(int.parse(doc.color!.replaceAll("#", "0xFF"))),
                  onPressed: () {
                    onTopicSelected(doc.topicId);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class TopicCard extends StatelessWidget {
  final String topicId;
  final String title;
  final String description;
  final String imgUrl;
  final bool isActive;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const TopicCard({
    super.key,
    required this.topicId,
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.isActive,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
          border: Border.all(
            width: isActive ? 6.0 : 2.0,
            color: isActive ? Color(0xFF80D0DD) : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                imgUrl,
                fit: BoxFit.contain,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
