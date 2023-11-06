import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/auth_screens/intro_screen.dart';
import 'package:mom/screens/feature_screens/story_page.dart';
import 'package:mom/screens/main_screens/profile_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/home_subtitle.dart';
import 'package:mom/widgets/components/no_network_popup.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firebaseController = Get.put(FirebaseController());
  final hiveController = Get.put(HiveController());

  @override
  void initState() {
    initOptions();
    super.initState();
  }

  initOptions() async {
    await firebaseController.fetchStory();
    await hiveController.getUserInfoHive();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                alignment: Alignment.center,
                child: const CustomHeader(title: "Let's Begin"),
              ),
              const SizedBox(height: 24),
              // ElevatedButton(
              //     onPressed: () {
              //       // firebaseController.addParametersToTopics();
              //       Get.to(() => IntroScreen());
              //     },
              //     child: const Text("Button")),
              InkWell(
                onTap: (){
                  Get.to(() => const ProfileScreen());
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => Text(
                                "Hello, ${hiveController.userData.value.firstName}",
                                style: GoogleFonts.montserrat(
                                  fontSize: 25,
                                  color: const Color(0xFF58315A),
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          Text(
                            "Ready to start your day with MoM?",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                              ,
                            ),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () => Get.to(() => const ProfileScreen()),
                      //   child: Container(
                      //     padding: const EdgeInsets.all(8),
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.shade100,
                      //       borderRadius: BorderRadius.circular(16),
                      //     ),
                      //     child: CachedNetworkImage(
                      //       imageUrl: firebaseAuth.currentUser!.photoURL ?? "",
                      //       height: 35,
                      //       width: 35,
                      //       placeholder: (context, url) =>
                      //           const CircularProgressIndicator(), // Placeholder widget
                      //       errorWidget: (context, url, error) => const Icon(
                      //           Icons.person,
                      //           size: 32), // Error widget
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => CustomContainer(
                    // height: deviceSize.height * 0.4,
                    width: double.infinity,
                    backgroundColor: const Color(0xFFB9E7E5),
                    marginHorizontal: 30,
                    marginVertical: 10,
                    paddingVertical: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            "\"${firebaseController.story.value.quote}\"",
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "- ${firebaseController.story.value.author}",
                          style: GoogleFonts.montserrat(
                            fontSize: 24,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 24),
                          child: ButtonDesign(
                            btnText: "Start your Day",
                            fontSize: 18,
                            marginHorizontal: 12,
                            marginVertical: 12,
                            bgColor: Color(0xFF80D0DD),
                            btnFunction: () async {
                              if (await checkConnectivity()) {
                                Get.to(() => const StoryPage());
                              } else {
                                Get.dialog(const NoNetworkPopup());
                              }
                            },
                            suffixWidget: const Icon(
                              Icons.play_arrow_rounded,
                              size: 32,
                              color: Color(0xFF58315A),
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () async {
                        // if (await checkConnectivity()) {
                        //   Get.to(() => const StoryPage());
                        // } else {
                        //   Get.dialog(const NoNetworkPopup());
                        // }
                        //   },
                        //   child: Container(
                        //     alignment: Alignment.centerRight,
                        //     child: Container(
                        //       margin: const EdgeInsets.only(right: 15),
                        //       padding: const EdgeInsets.all(8),
                        //       decoration: BoxDecoration(
                        //         color: const Color(0xFF58315A),
                        //         borderRadius: BorderRadius.circular(35),
                        //       ),
                        //       child: const Icon(
                        //         Icons.play_arrow_rounded,
                        //         size: 38,
                        //         color: Colors.amber,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    )),
              ),
              const SizedBox(height: 24),
              const Divider(indent: 30, endIndent: 30, thickness: 3),
              // const SizedBox(height: 25.0),
              // HomeSubtitle(
              //   title: "Continue program in topics section, else ⬇️",
              // ),
              // CustomContainer(
              //   marginHorizontal: 30,
              //   marginVertical: 10,
              //   paddingHorizontal: 15,
              //   paddingVertical: 15,
              //   width: double.infinity,
              //   backgroundColor: const Color(0xFFCFBAF0),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Change topic!",
              //         style: GoogleFonts.openSans(
              //           fontSize: 25,
              //           color: Colors.black,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       const SizedBox(height: 20),
              //       Container(
              //         alignment: Alignment.centerRight,
              //         child: ButtonDesign(
              //           btnText: "Start",
              //           bgColor: const Color(0xFF96D1BD),
              //           width: deviceSize.width * 0.4,
              //           height: 60,
              //           btnFunction: () async {
              //             Get.to(() => SelectTopicScreen(isBoarding: false));
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // HomeBtn(
              //     topicTitle: "Choose your topic",
              //     btnFunction: () {
              //       Get.to(() => SelectTopicScreen(isBoarding: false));
              //     }),
              // const SizedBox(height: 20.0),
              // HomeSubtitle(title: "My Daily Checkin"),
              // CustomContainer(
              //   marginHorizontal: 30,
              //   marginVertical: 10,
              //   paddingHorizontal: 15,
              //   paddingVertical: 15,
              //   width: double.infinity,
              //   backgroundColor: const Color.fromARGB(255, 240, 192, 197),
              //   child: Column(
              //     children: [
              //       Text(
              //         "How are you feeling today?",
              //         style: GoogleFonts.openSans(
              //           fontSize: 25,
              //           color: Colors.black,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //       const SizedBox(height: 20),
              //       Container(
              //         alignment: Alignment.center,
              //         child: ButtonDesign(
              //           btnText: "Check-in",
              //           bgColor: const Color(0xFF96D1BD),
              //           height: 60,
              //           btnFunction: () async {
              //             Get.to(() => CheckinScreen());
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 24),
              HomeSubtitle(title: "Get Therapy"),
              CustomContainer(
                marginHorizontal: 30,
                marginVertical: 10,
                paddingHorizontal: 15,
                paddingVertical: 15,
                width: double.infinity,
                backgroundColor: const Color(0xFF66C4BC),
                child: Column(
                  children: [
                    Text(
                      "Your first therapy session is on us",
                      style: GoogleFonts.openSans(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: ButtonDesign(
                        btnText: "Get now",
                        bgColor: const Color(0xFF80D0DD),
                        // width: deviceSize.width * 0.4,
                        height: 60,
                        btnFunction: () async {
                          await launchUrl(Uri.parse("https://docs.google.com/forms/d/e/1FAIpQLSf7yeXaGZbo4CpTwg4w4Oy3oOhFFsdJVqqMtbCVtgzXgfAcDw/viewform?usp=sf_link"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              HomeSubtitle(title: "My Graphalogy"),
              CustomContainer(
                marginHorizontal: 30,
                marginVertical: 10,
                paddingHorizontal: 15,
                paddingVertical: 15,
                width: double.infinity,
                backgroundColor: const Color(0xFFB9E7E5),
                child: Column(
                  children: [
                    Text(
                      "Want to know more about the unique skills of everyone in your team?",
                      style: GoogleFonts.openSans(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: ButtonDesign(
                        btnText: "Check now",
                        bgColor: const Color(0xFF80D0DD),
                        // width: deviceSize.width * 0.4,
                        height: 60,
                        btnFunction: () async {
                          await launchUrl(Uri.parse("https://google.com"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // HomeBtn(
              //     topicTitle: "How are you feeling today?",
              //     btnFunction: () {
              //       Get.to(() => CheckinScreen());
              //     }),
              const SizedBox(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }
}
