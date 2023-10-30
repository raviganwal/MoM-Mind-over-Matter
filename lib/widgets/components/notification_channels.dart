// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/services/controllers/notification_controller.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/utils/my_enums.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';

class NotificationChannels extends StatefulWidget {
  NotifyType option;
  NotificationChannels({
    Key? key,
    required this.option,
  }) : super(key: key);

  @override
  State<NotificationChannels> createState() => _NotificationChannelsState();
}

class _NotificationChannelsState extends State<NotificationChannels> {
  String notifyText = "";

  @override
  void initState() {
    switch (widget.option) {
      case NotifyType.dayStart:
        notifyText = 'Start your Day with MoM';
        break;
      case NotifyType.programNotify:
        notifyText = 'Continue my program';
        break;
      case NotifyType.dailyCheckin:
        notifyText = 'Daily check-in reminder';
        break;
      default:
        notifyText = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotify notifyController = Get.put(AwesomeNotify());
    return CustomContainer(
      marginVertical: 10,
      paddingHorizontal: 10,
      backgroundColor: Colors.white,
      child: ListTile(
        // horizontalTitleGap: 3,
        leading: const Icon(
          Iconsax.clock,
          size: 26,
          color: Color(0xFFCFBAF0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        title: Text(
          notifyText,
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        subtitle: Text("Preferred notification time",
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                )),

        trailing: Obx(
          () {
            NotifyType notifyType = widget.option;
            switch (notifyType) {
              case NotifyType.dayStart:
                return Text(stringToTimeofday(notifyController.dailyTime.value).format(context));
              case NotifyType.programNotify:
                return Text(stringToTimeofday(notifyController.programTime.value).format(context));
              case NotifyType.dailyCheckin:
                return Text(stringToTimeofday(notifyController.checkinTime.value).format(context));
              default:
                return const Text('');
            }
          },
        ),
        onTap: () async {
          TimeOfDay? pickedTime =
              await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 20, minute: 00));
          final tempTime = pickedTime;
          if (tempTime != null) {
            //Just update the new notification time in Hive
            NotifyType notifyType = widget.option;
            switch (notifyType) {
              case NotifyType.dayStart:
                await notifyController.putDailyTime(tempTime);
                break;
              case NotifyType.programNotify:
                await notifyController.putProgramTime(tempTime);
                break;
              case NotifyType.dailyCheckin:
                await notifyController.putCheckInTime(tempTime);
                break;
              default:
                "";
            }
            //Call schedule notifications functions
            await notifyController.scheduleNotifications();
          }
        },
      ),
    );
  }
}
