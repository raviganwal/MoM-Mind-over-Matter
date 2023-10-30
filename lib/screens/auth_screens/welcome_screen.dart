import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:meditation_app/src/common_widgets/app_logo.dart';
import 'package:mom/common_widgets/app_text.dart';
import 'package:mom/screens/choose_topics/select_topic_screen.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
//import 'package:mom/themes/themes.dart';

class WelcomeScreen extends StatelessWidget {
  // final User user;

  const WelcomeScreen({
    super.key,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final userName = firebaseAuth.currentUser?.displayName ?? "";
    return Scaffold(
      //backgroundColor: Color(0xFF98ACF8),
      //backgroundColor: Color(0xFFA5DEE5),
      //backgroundColor: AppTheme.of(context).theme.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  //const AppLogoLight(),
                  const Spacer(),
                  AppText.normalText(
                    "Hi $userName, Welcome",
                    fontSize: 30,
                    isBold: true,
                    color: const Color(0xff4B3A5A),
                  ),

                  AppText.normalText(
                    "to MOM - Mind Over Matter",
                    fontSize: 30,
                    color: const Color(0xff4B3A5A),
                  ),
                  const SizedBox(height: 15),

                  AppText.normalText(
                    "Prepare to Live your life to the fullest with our App",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: const Color(0xff4B3A5A),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: Image.asset(
                      'assets/images/mom-mascot.png',
                      //semanticsLabel: 'A red up arrow',
                      fit: BoxFit.contain,
                    ),
                  ),
                  ButtonDesign(
                    btnText: "Pick your topic",
                    bgColor: const Color(0xFFFEB150),
                    txtColor: Colors.black,
                    btnFunction: () async {
                      Get.to(() => SelectTopicScreen(isBoarding: true));
                    },
                  ),

                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
