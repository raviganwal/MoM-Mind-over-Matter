import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';

class HiveController extends GetxController {
  Rx<User> userData = User(
    firstName: firebaseAuth.currentUser!.displayName ?? "",
    lastName: firebaseAuth.currentUser!.displayName ?? "",
    email: firebaseAuth.currentUser!.email ?? "",
    userId: firebaseAuth.currentUser!.uid,
    gender: "",
    country: "",
    dateOfBirth: "",
    proValidity: "",
    enrolledTopic: "",
    activeSprint: "",
  ).obs;

  final box = Hive.box(hCommonBox);

  Future<void> getUserInfoHive() async {
    final userReceived = await FirebaseController.fetchUserDataFromFirebase();
    if (userReceived == null) {
      // User doesn't exist in Firebase, so we don't have to update Hive
      return;
    }
    // User exists in Firebase, so we need to update Hive
    await box.put(hFirstName, userReceived.firstName);
    await box.put(hLastName, userReceived.lastName);
    await box.put(hEmail, userReceived.email);
    await box.put(hUserId, userReceived.userId);
    await box.put(hGender, userReceived.gender);
    await box.put(hDob, userReceived.dateOfBirth);
    await box.put(hCountry, userReceived.country);
    await box.put(hEnrolledTopic, userReceived.enrolledTopic);
    await box.put(hActiveSprint, userReceived.activeSprint);
    await box.put(hProvalidity, userReceived.proValidity);
    final userModel = User(
        firstName: userReceived.firstName,
        lastName: userReceived.lastName,
        email: userReceived.email,
        userId: userReceived.userId,
        gender: userReceived.gender,
        country: userReceived.country,
        dateOfBirth: userReceived.dateOfBirth,
        proValidity: userReceived.proValidity,
        enrolledTopic: userReceived.enrolledTopic,
        activeSprint: userReceived.activeSprint);
    userData.value = userModel;
  }
}
