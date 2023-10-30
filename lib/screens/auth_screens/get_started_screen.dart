import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/auth_screens/intro_screen.dart';
import 'package:mom/screens/auth_screens/signin_screen.dart';
import 'package:get/get.dart';
import 'package:bordered_text/bordered_text.dart';
import 'package:mom/widgets/components/button_design.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500), // Reduced to 0.5 seconds
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Color(0xFF020035),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Text "Hello"
                const SizedBox(height: 56),
                // Spacer
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                  ).animate(_animationController),
                  child: Text(
                    "Welcome",
                    textAlign: TextAlign.center, // Center text alignment
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Colors.white, // Text color set to white
                        fontSize: 32, // Font size changed to 32
                        fontWeight: FontWeight.w800, // Extra bold
                      ),
                    ),
                  ),
                ),
                isPortrait ? const Spacer() : const SizedBox(height: 48),
                // Column for Mascot, "I am MoM," and "Your wellness companion"
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Second SVG image (Your mascot image)
                    ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.0, // Start with no scale
                        end: 1.0,
                      ).animate(_animationController),
                      child: Image.asset(
                        "assets/images/ui_components/splash_mascot.png",
                        height: 300, // You can adjust the size as needed
                        width: 300,
                      ),
                    ),
                    const SizedBox(height: 80), // Spacer
                    // Text "I am MoM"
                    // SlideTransition(
                    //   position: Tween<Offset>(
                    //     begin: Offset(0, 1),
                    //     end: Offset(0, 0),
                    //   ).animate(_animationController),
                    //   child: Text(
                    //     "I am MoM",
                    //     textAlign: TextAlign.center, // Center text alignment
                    //     style: GoogleFonts.montserrat(
                    //       textStyle: TextStyle(
                    //         color: Colors.white, // Text color set to white
                    //         fontSize: 30, // Font size changed to 30
                    //         fontWeight: FontWeight.bold, // Bold
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                // Text "Your we.llness companion"
                isPortrait ? const Spacer() : const SizedBox(height: 36),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset(0, 0),
                    ).animate(_animationController),
                    child: Text(
                      "Your wellness companion",
                      textAlign: TextAlign.center, // Center text alignment
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: Colors.white, // Text color set to white
                          fontSize: 26, // Font size changed to 26
                          fontWeight: FontWeight.w500, // Medium
                        ),
                      ),
                    ),
                  ),
                ),
                // Get Started Button
                const SizedBox(height: 36),
                // Spacer
                // const Spacer(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 26),
                  child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0, 1),
                        end: Offset(0, 0),
                      ).animate(_animationController),
                      child: ButtonDesign(
                        btnText: "Get Started",
                        bgColor: Color(0xFF80D0DD),
                        // Button color
                        txtColor: Color(0xFF4B3A5A),
                        shadowColor: Color(0xFF4B3A5A),
                        btnFunction: () {
                          // Navigate to IntroScreen
                          Get.offAll(() => IntroScreen());
                        },
                        suffixWidget: SvgPicture.asset(
                          "assets/images/ui_components/arrow-forward.svg",
                          height: 24,
                          width: 24,
                        ),
                        fontSize: 20,
                      )),
                ),
                isPortrait
                    ? const SizedBox(height: 40)
                    : const SizedBox(height: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
