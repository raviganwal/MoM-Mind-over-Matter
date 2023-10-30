import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/choose_topics/select_topic_screen.dart';
import 'package:mom/screens/feature_screens/paywall_screen.dart';
import 'package:mom/screens/feature_screens/program_detail_screen.dart';
import 'package:mom/screens/feature_screens/quiz_action.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/services/models/program.dart';
import 'package:mom/utils/my_enums.dart';
import 'package:mom/widgets/components/appbar_design.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/no_network_popup.dart';
import 'package:mom/widgets/components/progress_bar.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class CourseScreen extends StatefulWidget {
  String topicId;

  CourseScreen({super.key, required this.topicId});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final hiveController = Get.put(HiveController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomHeader(title: "Topics"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton.filledTonal(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Obx(() => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        "Hello, ${hiveController.userData.value.firstName}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Text(
                    "Here's your program ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                StreamBuilder<List<Program>>(
                  stream: FirebaseController.getProgramsForTopic(widget.topicId)
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While the stream is still resolving
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      // When the stream has successfully resolved and there is data
                      final programs = snapshot.data!;
                      return Column(
                        children: [
                          ProgressBarWidget(
                            activeTopic: widget.topicId,
                            programLength: programs.length,
                          ),
                          const Divider(
                              thickness: 3, endIndent: 30, indent: 30),
                          QuizButton(
                              topicId: widget.topicId,
                              action: QuizAction.start),
                          ProgramList(programs: programs),
                          const Divider(
                              thickness: 3, endIndent: 30, indent: 30),
                          QuizButton(
                              topicId: widget.topicId, action: QuizAction.end),
                          const SizedBox(height: 100),
                        ],
                      );
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      // When the stream has successfully resolved but there is no data
                      return const Text('No programs found.');
                    } else {
                      // When there is an error or the stream has not yet resolved
                      return const Text('Error fetching programs.');
                    }
                  },
                )
                // StreamBuilder<String?>(
                //   stream: FirebaseController.getActiveTopic().asStream(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     } else if (snapshot.hasData) {
                //       final activeTopicId = snapshot.data!;
                //       return
                //     } else {
                //       return Center(
                //           child: ButtonDesign(
                //               btnText: "Select Topic",
                //               btnFunction: () {
                //                 Get.to(() => SelectTopicScreen(isBoarding: false));
                //               }));
                //     }
                //   },
                // ),
              ],
            ),
          ),
        ));
  }
}

class ProgramList extends StatelessWidget {
  final List<Program> programs;

  const ProgramList({Key? key, required this.programs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: programs.length,
      itemBuilder: (context, index) {
        final program = programs[index];
        return FutureBuilder<bool>(
          future: FirebaseController()
              .checkProValidity(), // Assuming you have implemented checkProValidity function
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final bool isProUser = snapshot.hasData && snapshot.data == true;
            final bool isLocked = !isProUser &&
                index > 0; // Lock all cards except the first for non-pro users

            return CustomContainer(
              marginHorizontal: 20,
              marginVertical: 12,
              paddingHorizontal: 12,
              paddingVertical: 12,
              backgroundColor: const Color(0xFF66C4BC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DAY ${program.day}",
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            program.title,
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            program.description,
                            style: GoogleFonts.openSans(
                              fontWeight: FontWeight.normal,
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      isLocked
                          ? // Hide lock icon for pro users or only show it for the first card for non-pro users
                          Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.lock,
                                size: 18,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ButtonDesign(
                      btnText: "Start",
                      bgColor: const Color(0xFF80D0DD),
                      marginHorizontal: 24,
                      marginVertical: 12,
                      width: 125,
                      paddingValue: 8,
                      btnFunction: () async {
                        bool networkState = await checkConnectivity();
                        if (networkState) {
                          if (!isProUser && index > 0) {
                            // Navigate to PaywallScreen for non-pro users on locked cards
                            Get.to(() => const PaywallScreen());
                          } else {
                            // Navigate to ProgramDetailScreen for all other cases
                            Get.to(() => ProgramDetailScreen(program: program));
                          }
                        } else {
                          Get.dialog(const NoNetworkPopup());
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
