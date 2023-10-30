import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mom/screens/feature_screens/track_screens/checkin_screen.dart';
import 'package:mom/services/functions/helper_function.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/alert_popup.dart';

class AwesomeNotify extends GetxController {
  // TimerController timerController = Get.put(TimerController());

  static ReceivedAction? receivedAction;

  Future<void> initiliseNotifications() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              // channelGroupKey: 'basic_channel_group',
              channelKey: nBasicChannel,
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: const Color(0xFF9D50DD),
              importance: NotificationImportance.Max,
              playSound: true,
              ledColor: Colors.white),
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: 'basic_channel_group',
              channelGroupName: 'Basic notification'),
        ],
        debug: true);

    // Get initial notification action is optional
    receivedAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: true);
    if (receivedAction != null) {
      if (receivedAction!.channelKey == nBasicChannel) {
        // Map<String, String?>? payloadReceived = receivedAction!.payload;
        if (receivedAction!.body == "Checkin your sleep and mood") {
          Future.delayed(const Duration(seconds: 3), () async {
            // Fluttertoast.showToast(msg: "Notification aciton is here");
            Get.to(() => CheckinScreen());
          });
        }
      }
    }
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  Future<void> startListeningNotificationEvents() async {
    await AwesomeNotifications().setListeners(
        onActionReceivedMethod: ((receivedAction) {
      return AwesomeNotify.onActionReceivedMethod(receivedAction);
    }));
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    if (receivedAction.channelKey! == nBasicChannel) {
      // Map<String, String?>? payloadReceived = receivedAction.payload;
      if (receivedAction.body == "Checkin your sleep and mood") {
        Future.delayed(const Duration(seconds: 3), () async {
          // Fluttertoast.showToast(msg: "Notification aciton is here");
          Get.to(() => CheckinScreen());
        });
      }
    }
  }

  Future<bool> notifyPermission() async {
    bool isUserAllowed = false;
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
          isUserAllowed = isAllowed,
          if (!isAllowed)
            {
              Get.dialog(AlertPopup(
                  message: "Do you like to enable notifications",
                  title: "Notifications",
                  btnName: "Allow",
                  onBtnPress: () async {
                    isUserAllowed = await AwesomeNotifications()
                        .requestPermissionToSendNotifications();
                    Get.back();
                  }))
            }
        });
    return isUserAllowed;
  }

  ///  *********************************************
  ///     NOTIFICATION SETTING METHODS
  ///  *********************************************

  RxString checkinTime =
      timeOfDayToString(const TimeOfDay(hour: 20, minute: 0)).obs;
  RxString programTime =
      timeOfDayToString(const TimeOfDay(hour: 18, minute: 0)).obs;
  RxString dailyTime =
      timeOfDayToString(const TimeOfDay(hour: 10, minute: 0)).obs;
  var box = Hive.box(hCommonBox);

  //When reminder is toggled off cancel all the notification

  cancelNotifyChannel() async {
    await AwesomeNotifications().cancelNotificationsByChannelKey(nBasicChannel);
  }

  //Initialise the notifications at Start

  //Save and retrive time from Hive for all the three notifications
  Future<void> putDailyTime(TimeOfDay time) async {
    await box.put(hDailyTime, timeOfDayToString(time));
    dailyTime.value = timeOfDayToString(time);
  }

  Future<void> putProgramTime(TimeOfDay time) async {
    await box.put(hProgramTime, timeOfDayToString(time));
    programTime.value = timeOfDayToString(time);
  }

  Future<void> putCheckInTime(TimeOfDay time) async {
    await box.put(hCheckinTime, timeOfDayToString(time));
    checkinTime.value = timeOfDayToString(time);
  }

  Future<TimeOfDay> getDailyTime() async {
    final time = await box.get(hDailyTime,
        defaultValue: timeOfDayToString(const TimeOfDay(hour: 10, minute: 0)));
    final timeDay = stringToTimeofday(time);
    dailyTime.value = time;
    return timeDay;
  }

  Future<TimeOfDay> getProgramTime() async {
    final time = await box.get(hProgramTime,
        defaultValue: timeOfDayToString(const TimeOfDay(hour: 10, minute: 0)));
    final timeDay = stringToTimeofday(time);
    programTime.value = time;
    return timeDay;
  }

  Future<TimeOfDay> getCheckInTime() async {
    final time = await box.get(hCheckinTime,
        defaultValue: timeOfDayToString(const TimeOfDay(hour: 10, minute: 0)));
    final timeDay = stringToTimeofday(time);
    checkinTime.value = time;
    return timeDay;
  }

  //If a notification type time is changed cancel the notifications and recreate all the notifications

  Future<void> scheduleNotifications() async {
    await cancelNotifyChannel();
    await scheduleDailyNotify();
    await scheduleProgramNotify();
    await scheduleCheckinNotify();
  }

  Future<void> scheduleDailyNotify() async {
    final tempTime = await getDailyTime();

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await notifyPermission();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(),
            channelKey: nBasicChannel,
            title: 'Start your Day',
            body: "Checkout today's story",
            color: Colors.teal.shade100,
            actionType: ActionType.Default),
        schedule: NotificationCalendar(
            repeats: true,
            preciseAlarm: true,
            allowWhileIdle: true,
            hour: tempTime.hour,
            minute: tempTime.minute,
            second: 0,
            millisecond: 0));
  }

  Future<void> scheduleProgramNotify() async {
    final tempTime = await getProgramTime();

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await notifyPermission();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(),
            channelKey: nBasicChannel,
            title: 'Program',
            body: 'Continue my program',
            color: Colors.teal.shade100,
            actionType: ActionType.Default),
        schedule: NotificationCalendar(
            repeats: true,
            preciseAlarm: true,
            allowWhileIdle: true,
            hour: tempTime.hour,
            minute: tempTime.minute,
            second: 0,
            millisecond: 0));
  }

  Future<void> scheduleCheckinNotify() async {
    final tempTime = await getCheckInTime();

    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await notifyPermission();
    }
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: createUniqueId(),
            channelKey: nBasicChannel,
            title: 'Daily Check-in',
            body: 'Checkin your sleep and mood',
            color: Colors.teal.shade100,
            payload: {"type": "checkin"},
            actionType: ActionType.Default),
        schedule: NotificationCalendar(
            repeats: true,
            preciseAlarm: true,
            allowWhileIdle: true,
            hour: tempTime.hour,
            minute: tempTime.minute,
            second: 0,
            millisecond: 0));
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(1000000);
  }
}
