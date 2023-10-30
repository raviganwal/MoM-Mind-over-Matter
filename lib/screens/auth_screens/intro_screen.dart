import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:mom/screens/auth_screens/signin_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String title = "Welcome";
  final List<PageViewModel> pages = [
    PageViewModel(
      // title: "Welcome to Mind over Matter",
      title: "",
      body: "Embark on a Journey to Mental Well-Being with MoM",
      image: Container(
        width: 300.0,
        height: 300.0,
        padding:
            const EdgeInsets.only(top: 20.0, bottom: 0, left: 40, right: 40),
        child: Lottie.asset(
          "assets/animations/intro_1.json",
          fit: BoxFit.cover,
        ),
      ),
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w800, // Extra bold
          fontSize: 32, // Font size
        ),
        bodyTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w500, // Medium
          fontSize: 20, // Font size
        ),
      ),
    ),
    PageViewModel(
      // title: "Track Your Progress",
      title: "",
      body: "Witness Your Mental Wellness Flourish Every Step of the Way!",
      image: Container(
        width: 300.0,
        height: 300.0,
        padding:
            const EdgeInsets.only(top: 20.0, bottom: 0, left: 30, right: 30),
        child: Lottie.asset(
          "assets/animations/intro_2.json",
          fit: BoxFit.cover,
        ),
      ),
      // Use your Lottie animation asset for page 2
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w800, // Extra bold
          fontSize: 32, // Font size
        ),
        bodyTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w500, // Medium
          fontSize: 20, // Font size
        ),
      ),
    ),
    PageViewModel(
      // title: "Get Support",
      title: "",
      body: "Where Empathy Meets Expertise, Your Journey to Healing Begins!",
      image: Container(
          width: 400.0,
          height: 400.0,
          padding:
              const EdgeInsets.only(top: 20.0, bottom: 40, left: 40, right: 40),
          child: Lottie.asset(
            "assets/animations/intro_11.json",
            fit: BoxFit.cover,
          )),
      // Use your Lottie animation asset for page 3
      decoration: PageDecoration(
        titleTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w800, // Extra bold
          fontSize: 32, // Font size
        ),
        bodyTextStyle: GoogleFonts.montserrat(
          color: const Color(0xFFFFFFFF), // Text color in hex
          fontWeight: FontWeight.w500, // Medium
          fontSize: 20, // Font size
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020035),
      // Background color for the whole page
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // Spacer to push content to the top
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: IntroductionScreen(
              pages: pages,
              onDone: () {
                Get.offAll(() => SignInScreen());
              },
              onSkip: () {
                Get.offAll(() => SignInScreen());
              },
              onChange: (value) {
                print("value $value");
                if (value == 0) {
                  title = "Welcome";
                } else if (value == 1) {
                  title = "Track Your Journey";
                } else if (value == 2) {
                  title = "Get Support";
                }
                setState(() {});
              },
              next: Text(
                "Next",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFFFFFFF), // Plain text color in hex
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 24, // Font size
                ),
              ),
              showBackButton: false,
              showSkipButton: true,
              skip: Text(
                "Skip",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFFFFFFF), // Plain text color in hex
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 24, // Font size
                ),
              ),
              done: Text(
                "Done",
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFFFFFFF), // Plain text color in hex
                  fontWeight: FontWeight.w500, // Medium
                  fontSize: 24, // Font size
                ),
              ),
              dotsDecorator: DotsDecorator(
                size: const Size(10.0, 10.0),
                color: const Color(0xFFFFFFFF),
                // Dot color in hex
                activeSize: const Size(22.0, 10.0),
                activeColor: const Color(0xFF80D0DD),
                // Active dot color in hex
                spacing: const EdgeInsets.all(4.0),
              ),
              globalBackgroundColor: const Color(0xFF020035),
            ),
          ),
        ],
      ),
    );
  }
}
