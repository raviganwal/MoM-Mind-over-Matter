import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/screens/choose_topics/select_topic_screen.dart';
import 'package:mom/screens/feature_screens/paywall_screen.dart';
import 'package:mom/screens/main_screens/sub_screens/profile_edit_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/services/controllers/notification_controller.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/utils/my_enums.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/notification_channels.dart';
import 'package:mom/widgets/components/setting_subtitle.dart';
import 'package:mom/widgets/components/setting_tile_item.dart';
import 'package:mom/widgets/components/setting_toggle_tile.dart';
import 'package:mom/widgets/components/social_icons.dart';
import 'package:mom/widgets/ui_widgets/close_button.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PackageInfo? _packageInfo;
  // int _longbreakValue = 20;
  SigninController signinController = Get.put(SigninController());
  AwesomeNotify notifyController = Get.put(AwesomeNotify());
  HiveController hiveController = Get.put(HiveController());
  final TimeOfDay _selectedTime = TimeOfDay.now();
  String userFirstName = "";
  String userLastName = "";
  String userCountry = "";
  String userDob = "";
  String userGender = "";

  bool isNotificationEnabled = false;

  final box = Hive.box(hCommonBox);

  @override
  void initState() {
    checkNotificationSettings();
    // checkUserInHive();
    super.initState();
  }

  checkNotificationSettings() async {
    bool isNotifyEnabled = await box.get(hIsNotify) ?? true;
    if (isNotifyEnabled) {
      notifyController.scheduleNotifications();
      setState(() {
        isNotificationEnabled = true;
      });
    } else {
      notifyController.cancelNotifyChannel();
      setState(() {
        isNotificationEnabled = false;
      });
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // checkUserInHive() async {
  //   if (box.containsKey(hFirstName)) {
  //     userFirstName = await box.get(hFirstName);
  //     userLastName = await box.get(hLastName);
  //     userGender = await box.get(hGender);
  //     userDob = await box.get(hDob);
  //     userCountry = await box.get(hCountry);
  //     setState(() {});
  //   } else {
  //     User? userReceived = await FirebaseController.fetchUserDataFromFirebase();
  //     if (userReceived != null) {
  //       //Save the user Data
  //       await box.put(hFirstName, userReceived.firstName);
  //       await box.put(hLastName, userReceived.lastName);
  //       await box.put(hGender, userReceived.gender);
  //       await box.put(hDob, userReceived.dateOfBirth);
  //       await box.put(hCountry, userReceived.country);
  //       await box.put(hEnrolledTopic, userReceived.enrolledTopic);
  //       await box.put(hActiveSprint, userReceived.activeSprint);
  //       setState(() {
  //         userFirstName = userReceived.firstName;
  //         userLastName = userReceived.lastName;
  //         userGender = userReceived.gender;
  //         userDob = userReceived.dateOfBirth;
  //         userCountry = userReceived.country;
  //       });
  //     } else {
  //       Fluttertoast.showToast(msg: "Error getting the user data");
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    //firebase Auth Values
    final userImg = firebaseAuth.currentUser!.photoURL ?? "";
    final userEmail = firebaseAuth.currentUser!.email ?? "Email not Avalilable";
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 25),
                const CustomHeader(title: "Profile"),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Get.to(() => ProfileEditScreen(
                          firstName: hiveController.userData.value.firstName,
                          lastName: hiveController.userData.value.lastName,
                          country: hiveController.userData.value.country,
                          gender: hiveController.userData.value.gender,
                          dob: DateTime.fromMillisecondsSinceEpoch(
                            int.parse(hiveController.userData.value.dateOfBirth),
                          ),
                        ));
                  },
                  child: CustomContainer(
                    paddingHorizontal: 5,
                    paddingVertical: 5,
                    backgroundColor: const Color(0xFFB9E7E5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: userImg.isEmpty
                                ? Container(
                                    height: 100,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.person,
                                    ))
                                : Container(
                                    padding: const EdgeInsets.all(8),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(firebaseAuth.currentUser!.photoURL!)),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    "${hiveController.userData.value.firstName} ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(userEmail),
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                // Container(
                //   height: 75,
                //   padding: const EdgeInsets.all(8),
                //   margin: const EdgeInsets.symmetric(vertical: 10),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).cardColor,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: ListTile(
                //     // horizontalTitleGap: 3,
                //     leading: const Icon(
                //       Iconsax.clock,
                //       size: 26,
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                //     title: Text(
                //       "Select time".tr,
                //       style: Theme.of(context).textTheme.headlineMedium,
                //     ),
                //     subtitle: Text("Preferred notification time".tr,
                //         style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12)),

                //     trailing: Obx(
                //       () {
                //         // return Text(stringToTimeofday(notifyController.scheuleTimeofDay.value).format(context));
                //         return Text("12 Mar 2023");
                //       },
                //     ),
                //     onTap: () async {
                //       TimeOfDay? pickedTime =
                //           await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 20, minute: 00));
                //       // final tempTime = pickedTime ?? await notifyController.getDailyNotificationTime();
                //       // await notifyController.dailyNotifySteps(notifyTime: tempTime);
                //     },
                //   ),
                // ),

                const SizedBox(height: 10),
                FutureBuilder<bool>(
                  future: FirebaseController().checkProValidity(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(); // Placeholder widget while waiting for the future to complete
                    } else if (snapshot.hasData && snapshot.data == true) {
                      return ButtonDesign(
                        btnText: "Premium User",
                        btnFunction: () {},
                        bgColor: Colors.amber,
                        prefixWidget: const Icon(
                          Iconsax.crown1,
                          color: Colors.brown,
                          size: 24,
                        ),
                      );
                    } else {
                      return const SizedBox(); // Placeholder widget when the user is not a pro user
                    }
                  },
                ),

                const SizedBox(height: 10),
                SettingToggleTile(
                  title: "Reminder",
                  iconData: Iconsax.notification,
                  toggleValue: isNotificationEnabled,
                  proRequired: false,
                  onPressFunc: (bool isOn) async {
                    await box.put(hIsNotify, isOn);
                    if (isOn) {
                      notifyController.scheduleNotifications();
                    } else {
                      notifyController.cancelNotifyChannel();
                    }
                    setState(() {
                      isNotificationEnabled = isOn;
                    });
                  },
                ),
                isNotificationEnabled
                    ? Column(
                        children: [
                          NotificationChannels(option: NotifyType.dayStart),
                          NotificationChannels(option: NotifyType.programNotify),
                          NotificationChannels(option: NotifyType.dailyCheckin),
                        ],
                      )
                    : const SizedBox(),
                // HomeBtn(
                //     topicTitle: "Choose your topic",
                //     btnFunction: () {
                //       Get.to(() => SelectTopicScreen(isBoarding: false));
                //     }),
                ButtonDesign(
                    btnText: "Subscribe Premium",
                    marginVertical: 16,
                    btnFunction: () {
                      Get.to(() => const PaywallScreen());
                    }),
                SettingSubtitle(title: "Feedback".tr.toUpperCase()),
                SettingTileItem(
                  title: "Change topic".tr,
                  subtitle: "Change your topic".tr,
                  iconData: Iconsax.book,
                  onPressFunc: () async {
                    Get.to(() => SelectTopicScreen(isBoarding: false));
                    // await _launchUrl(playStoreUrl);
                  },
                ),
                SettingTileItem(
                  title: "Rate app".tr,
                  subtitle: "Rate the app in playstore".tr,
                  iconData: Iconsax.cup,
                  onPressFunc: () async {
                    await _launchUrl(playStoreUrl);
                  },
                ),
                SettingTileItem(
                  title: "Send feedback".tr,
                  subtitle: "Share your suggestion, bugs or feature requests".tr,
                  iconData: Iconsax.send_1,
                  onPressFunc: () async {
                    await _launchUrl(mailUrl);
                  },
                ),
                SettingTileItem(
                  title: "More apps".tr,
                  subtitle: "Other apps from us".tr,
                  iconData: Iconsax.more_circle,
                  onPressFunc: () async {
                    await _launchUrl(moreappsurl);
                  },
                ),
                SettingTileItem(
                  title: "Share app".tr,
                  subtitle: "Share with friends and bring to the community".tr,
                  iconData: Iconsax.share,
                  onPressFunc: () async {
                    await Share.share(
                        'Best app to transform your life for good, checkout at https://play.google.com/store/apps/details?id=com.appfactory.momapp');
                  },
                ),
                SettingSubtitle(title: "Policy".tr.toUpperCase()),
                SettingTileItem(
                  title: "Privacy Policy".tr,
                  iconData: Iconsax.document_text,
                  onPressFunc: () {
                    _launchUrl(privacyurl);
                  },
                ),
                SettingTileItem(
                  title: "Terms & Conditions".tr,
                  iconData: Iconsax.message_question,
                  onPressFunc: () {
                    _launchUrl(termsurl);
                  },
                ),
                SettingTileItem(
                  title: "Submit your podcast story".tr,
                  iconData: Iconsax.audio_square,
                  onPressFunc: () {
                    _launchUrl(podcastStory);
                  },
                ),
                SettingTileItem(
                  title: "${"Buy me a coffee".tr}☕",
                  iconData: Iconsax.coffee,
                  onPressFunc: () {
                    _launchUrl(coffeeUrl);
                  },
                ),
                SettingTileItem(
                  title: "More Info".tr,
                  iconData: Iconsax.information,
                  onPressFunc: () {
                    showAboutDialog(
                        context: context,
                        applicationName: "MoM",
                        applicationVersion: _packageInfo == null ? "" : _packageInfo!.version,
                        applicationLegalese: "This app ensures you that your data is private and secure.");
                  },
                ),
                SettingSubtitle(title: "Social".tr.toUpperCase()),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SocialsIcons(
                      icon: FontAwesomeIcons.youtube,
                      color: const Color.fromARGB(255, 221, 76, 76),
                      socialUrl: "https://www.youtube.com/",
                    ),
                    SocialsIcons(
                      icon: FontAwesomeIcons.facebook,
                      color: const Color.fromARGB(255, 82, 125, 218),
                      socialUrl: "https://www.facebook.com/",
                    ),
                    SocialsIcons(
                      icon: FontAwesomeIcons.twitter,
                      color: const Color(0xFF00acee),
                      socialUrl: "https://twitter.com/",
                    ),
                    SocialsIcons(
                      icon: FontAwesomeIcons.telegram,
                      color: const Color(0xFF0088cc),
                      socialUrl: "https://t.me/",
                    ),
                    SocialsIcons(
                      icon: FontAwesomeIcons.instagram,
                      color: const Color.fromARGB(255, 218, 112, 63),
                      socialUrl: "https://www.instagram.com/",
                    ),
                  ],
                ),
                ButtonDesign(
                    btnText: "Logout",
                    bgColor: Colors.redAccent,
                    txtColor: Colors.white,
                    marginVertical: 42,
                    btnFunction: () async {
                      await signinController.signoutUser();
                    }),

                Text(
                  "Made with ❤️ from India",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                const SizedBox(height: 15),
                Text(
                  _packageInfo == null ? "" : 'Version: ${_packageInfo!.version}',
                ),
                const SizedBox(height: 125),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
