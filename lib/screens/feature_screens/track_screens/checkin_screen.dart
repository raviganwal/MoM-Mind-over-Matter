import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/services/models/checkin.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/no_network_popup.dart';
import 'package:mom/widgets/loading_error_widgets/please_wait.dart';
import 'package:mom/widgets/ui_widgets/close_button.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({Key? key}) : super(key: key);

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final firebaseController = Get.put(FirebaseController());
  double happinessValue = 20;
  String happinessText = 'neutral';
  double sleepValue = 8;
  String sleepText = 'great';
  DateTime dateSelected = DateTime.now();
  DateTime sleepStartTime = DateTime.now().subtract(const Duration(hours: 8));
  DateTime sleepEndTime = DateTime.now();

  setMoodImageAndValue(double index) {
    int indexVal = index.toInt();
    switch (indexVal) {
      case 0:
        {
          happinessValue = 0;
          happinessText = 'depressed';
        }
        break;

      case 10:
        {
          happinessValue = 10;
          happinessText = 'sad';
        }
        break;

      case 20:
        {
          happinessValue = 20;
          happinessText = 'neutral';
        }
        break;

      case 30:
        {
          happinessValue = 30;
          happinessText = 'happy';
        }
        break;
      case 40:
        {
          happinessValue = 40;
          happinessText = 'blissful';
        }
        break;

      default:
        {}
        break;
    }
  }

  editMoodImageAndValue() {
    String indexVal = happinessText;

    switch (indexVal) {
      case 'depressed':
        {
          happinessValue = 0;
          happinessText = 'depressed';
        }
        break;

      case 'sad':
        {
          happinessValue = 10;
          happinessText = 'sad';
        }
        break;

      case 'neutral':
        {
          happinessValue = 20;
          happinessText = 'neutral';
        }
        break;

      case 'happy':
        {
          happinessValue = 30;
          happinessText = 'happy';
        }
        break;
      case 'blissful':
        {
          happinessValue = 40;
          happinessText = 'blissful';
        }
        break;

      default:
        {}
        break;
    }
  }

  setUrgeImageAndValue(double index) {
    int indexVal = index.toInt();
    switch (indexVal) {
      case 4:
        {
          sleepValue = 4;
          sleepText = 'poor';
        }
        break;

      case 5:
        {
          sleepValue = 5;
          sleepText = 'fair';
        }
        break;

      case 6:
        {
          sleepValue = 6;
          sleepText = 'adequate';
        }
        break;

      case 7:
        {
          sleepValue = 7;
          sleepText = 'good';
        }
        break;
      case 8:
        {
          sleepValue = 8;
          sleepText = 'great';
        }
        break;
      case 9:
        {
          sleepValue = 9;
          sleepText = 'excellent';
        }
        break;
      case 10:
        {
          sleepValue = 10;
          sleepText = 'superb';
        }
        break;

      default:
        {}
        break;
    }
  }

  editUrgeImageAndValue() {
    String indexVal = sleepText;
    switch (indexVal) {
      case 'poor':
        {
          sleepValue = 4;
          sleepText = 'poor';
        }
        break;

      case 'fair':
        {
          sleepValue = 5;
          sleepText = 'fair';
        }
        break;

      case 'adequate':
        {
          sleepValue = 6;
          sleepText = 'adequate';
        }
        break;

      case 'good':
        {
          sleepValue = 7;
          sleepText = 'good';
        }
        break;
      case 'great':
        {
          sleepValue = 8;
          sleepText = 'great';
        }
        break;
      case 'excellent':
        {
          sleepValue = 9;
          sleepText = 'excellent';
        }
        break;
      case 'superb':
        {
          sleepValue = 10;
          sleepText = 'superb';
        }
        break;

      default:
        {}
        break;
    }
  }

  void showCustomDatePicker(BuildContext context, DateTime initialDate,
      Function(DateTime) onDateSelected) {
    DateTime dateSelected = initialDate;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: initialDate,
                maximumDate: DateTime.now(),
                backgroundColor: Theme.of(context).cardColor,
                onDateTimeChanged: (val) {
                  dateSelected = val;
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF80D0DD),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onPressed: () {
                onDateSelected(dateSelected);
                Get.back(); // Assuming you are using GetX to navigate back
              },
              child: Text(
                "SAVE",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // void _showDatePicker(ctx) {
  //   // showCupertinoModalPopup is a built-in function of the cupertino library
  //   showCupertinoModalPopup(
  //     context: ctx,
  //     builder: (_) => Container(
  //       height: 300,
  //       color: Theme.of(context).cardColor,
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           Expanded(
  //             child: CupertinoDatePicker(
  //                 initialDateTime: dateSelected,
  //                 maximumDate: DateTime.now(),
  //                 backgroundColor: Theme.of(context).cardColor,
  //                 onDateTimeChanged: (val) {
  //                   setState(() {
  //                     dateSelected = val;
  //                   });
  //                 }),
  //           ),
  //           ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.teal,
  //                 elevation: 1,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(15.0),
  //                 ),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   dateSelected;
  //                 });
  //                 Get.back();
  //               },
  //               child: Text(
  //                 "SAVE",
  //                 style: GoogleFonts.poppins(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.white,
  //                 ),
  //               )),
  //           const SizedBox(height: 15),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomHeader(title: "Check-in"),
                  MyCloseButton(),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  showCustomDatePicker(context, dateSelected, (val) {
                    setState(() {
                      dateSelected = val;
                    });
                  });
                  // _showDatePicker(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Iconsax.calendar_tick4,
                      color: Colors.blue,
                      size: 22,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        DateFormat('dd MMMM yy').format(dateSelected),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    const Icon(
                      Iconsax.arrow_down_1,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                  ],
                ),
              ),
              CustomContainer(
                backgroundColor: Colors.white,
                marginVertical: 15,
                paddingHorizontal: 10,
                paddingVertical: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Mood',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/mood/$happinessText.png',
                              height: 75,
                              width: 75,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(happinessText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  )),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.teal[700],
                            inactiveTrackColor: Colors.teal[100],
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 5.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12.0),
                            thumbColor: Colors.green,
                            overlayColor: Colors.teal.withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 28.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.teal[700],
                            inactiveTickMarkColor: Colors.teal[100],
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.green,
                            valueIndicatorTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 0.0,
                            max: 40.0,
                            value: happinessValue,
                            divisions: 4,
                            label: happinessText,
                            onChanged: (value) {
                              setState(() {
                                setMoodImageAndValue(value);
                              });
                            },
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
              CustomContainer(
                backgroundColor: Colors.white,
                marginVertical: 15,
                paddingHorizontal: 10,
                paddingVertical: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Sleep',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset('assets/images/sleep/$sleepText.png',
                                height: 75, width: 75),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(sleepText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade400,
                                  )),
                            ),
                          ],
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.red[700],
                            inactiveTrackColor: Colors.red[100],
                            trackShape: const RoundedRectSliderTrackShape(),
                            trackHeight: 5.0,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 12.0),
                            thumbColor: Colors.redAccent,
                            overlayColor: Colors.red.withAlpha(32),
                            overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 28.0),
                            tickMarkShape: const RoundSliderTickMarkShape(),
                            activeTickMarkColor: Colors.red[700],
                            inactiveTickMarkColor: Colors.red[100],
                            valueIndicatorShape:
                                const PaddleSliderValueIndicatorShape(),
                            valueIndicatorColor: Colors.redAccent,
                            valueIndicatorTextStyle: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          child: Slider(
                            min: 4.0,
                            max: 10.0,
                            value: sleepValue,
                            divisions: 6,
                            // label: "${sleepValue.toInt()} hours",
                            onChanged: (value) {
                              setState(() {
                                setUrgeImageAndValue(value);
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Bedtime"),
                                GestureDetector(
                                  onTap: () {
                                    showCustomDatePicker(
                                      context,
                                      sleepStartTime,
                                      (val) {
                                        setState(() {
                                          sleepStartTime = val;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      DateFormat('hh:mm a')
                                          .format(sleepStartTime),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                const Text("Wakeup time"),
                                GestureDetector(
                                  onTap: () {
                                    showCustomDatePicker(
                                      context,
                                      sleepEndTime,
                                      (val) {
                                        setState(() {
                                          sleepEndTime = val;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Text(
                                      DateFormat('hh:mm a')
                                          .format(sleepEndTime),
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                  ],
                ),
              ),
              ButtonDesign(
                btnText: "Save",
                bgColor: const Color(0xFF96D1BD),
                btnFunction: () async {
                  //Create a checkin instance
                  final checkinData = Checkin(
                    mood: happinessText,
                    sleep: sleepText,
                    userId: firebaseAuth.currentUser!.uid,
                    datetime: dateSelected.millisecondsSinceEpoch.toString(),
                    sleepStart:
                        sleepStartTime.millisecondsSinceEpoch.toString(),
                    sleepEnd: sleepEndTime.millisecondsSinceEpoch.toString(),
                  );

                  bool isNetworkOn = await checkConnectivity();
                  if (isNetworkOn) {
                    Get.dialog(const PleaseWait());
                    //Save to firebase if there is connectivity
                    firebaseController.saveCheckinData(checkinData);
                    Get.back();
                    Get.back();
                  } else {
                    Get.dialog(const NoNetworkPopup());
                  }
                },
              ),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
