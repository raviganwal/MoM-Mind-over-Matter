import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:mom/screens/auth_screens/splashscreen.dart';
import 'package:mom/screens/auth_screens/stepper_screen.dart';
import 'package:mom/screens/auth_screens/welcome_screen.dart';
import 'package:mom/screens/choose_topics/select_topic_screen.dart';
import 'package:mom/screens/main_screens/nav_screen.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/alert_popup.dart';
import 'package:mom/widgets/loading_error_widgets/error_alert.dart';
import 'package:mom/widgets/loading_error_widgets/please_wait.dart';

class SigninController extends GetxController {
  final googleSignIn = GoogleSignIn();
  final box = Hive.box(hCommonBox);

  Future<void> signUpWithGoogle() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        bool isAlreadyRegistered = await isUserNew(googleSignInAccount.email);
        if (!isAlreadyRegistered) {
          Get.back();
          Get.dialog(
            AlertPopup(
                message:
                    "This Email has been registered already, try to login using your Email and Password / with your Google account",
                title: "Email already registered",
                btnName: "Login",
                btnColor: Colors.deepOrange,
                onBtnPress: () {
                  Get.back();
                  Get.offAll(() => SplashScreen());
                }),
          );
          return;
        }
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.back();
          // Sign-in successful, return user ID
          Get.offAll(() => SelectTopicScreen(isBoarding: true));
        } else {
          Get.back();
          Fluttertoast.showToast(msg: "Signin failed");
          // Sign-in failed
          Get.offAll(() => SplashScreen());
        }
      } else {
        Get.back();
        // Sign-in failed
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Something went wrong");
      // Sign-in failed
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Signin failed");
      // Sign-in failed
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        bool isAlreadyRegistered =
            await isUserAlreadyRegisteredGoogle(googleSignInAccount.email);
        if (!isAlreadyRegistered) {
          Get.back();
          Get.dialog(
            AlertPopup(
                message:
                    "This is not a registered google account, click create to setup new account",
                title: "Account register",
                btnName: "Create",
                btnColor: Colors.deepOrange,
                onBtnPress: () {
                  Get.back();
                  Get.to(() => const StepperScreen());
                }),
          );
          return;
        }
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await firebaseAuth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          Get.back();
          // Sign-in successful, return user ID
          Get.offAll(() => NavScreen());
        } else {
          Get.back();
          Fluttertoast.showToast(msg: "Signin failed");
          // Sign-in failed
          Get.offAll(() => SplashScreen());
        }
      } else {
        Get.back();
        // Sign-in failed
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Something went wrong");
      // Sign-in failed
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Signin failed");
      // Sign-in failed
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Get.back();
        // Sign-in successful, return user ID
        Fluttertoast.showToast(msg: "Signin Successful");
        Get.offAll(() => NavScreen());
      } else {
        Get.back();
        Get.offAll(() => SplashScreen());
        // Sign-in failed
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        Get.dialog(const ErrorAlert(content: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        Get.dialog(const ErrorAlert(
            content: "Wrong password provided for that user."));
      } else if (e.code == 'invalid-email') {
        Get.dialog(
            const ErrorAlert(content: "The email address is not valid."));
      } else if (e.code == 'user-disabled') {
        Get.dialog(
            const ErrorAlert(content: "The user account has been disabled."));
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
      // Sign-in failed
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Signup failed");

      // Sign-in failed
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()));
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        Get.back();
        // Sign-up successful
        Fluttertoast.showToast(msg: "Signup Successful");
        Get.offAll(() => SelectTopicScreen(isBoarding: true));
      } else {
        Get.back();
        Get.offAll(() => SplashScreen());
        // Sign-up failed
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'email-already-in-use') {
        Get.dialog(const ErrorAlert(
            content:
                "The account already exists for that email. Try to signin instead."));
      } else if (e.code == 'invalid-email') {
        Get.dialog(const ErrorAlert(content: "The Email address is not valid"));
      } else if (e.code == 'operation-not-allowed') {
        Get.dialog(const ErrorAlert(
            content: "Email/password accounts are not enabled."));
      } else if (e.code == 'weak-password') {
        Get.dialog(
            const ErrorAlert(content: "The password provided is too weak."));
      } else {
        Fluttertoast.showToast(msg: "Something went wrong");
      }
      // Sign-up failed
    } catch (e) {
      Get.back();
      Fluttertoast.showToast(msg: "Signup failed");
      // Sign-up failed
    }
  }

  Future<bool> isUserAlreadyRegisteredGoogle(String email) async {
    final List<String> signInMethods =
        await firebaseAuth.fetchSignInMethodsForEmail(email);
    if (signInMethods.isNotEmpty) {
      //Already registered with Email
      if (signInMethods.contains("password")) {
        return false;
      }
      //Already registered with Google
      if (signInMethods.contains("google.com")) {
        //User not registered
        return true;
      } else {
        return false;
      }
    } else {
      // User is not registered
      return false;
    }
  }

  Future<bool> isUserNew(String email) async {
    final List<String> signInMethods =
        await firebaseAuth.fetchSignInMethodsForEmail(email);
    if (signInMethods.isNotEmpty) {
      //User is already registered
      return false;
    } else {
      //User is not registered
      return true;
    }
  }

  Future<void> signoutUser() async {
    Get.dialog(const PleaseWait());
    try {
      await FirebaseAuth.instance.signOut();
      box.clear();
      Get.back();
      Get.offAll(() => SplashScreen());
    } catch (e) {
      Fluttertoast.showToast(msg: "Oops! Could not signout the user");
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.dialog(
          const ErrorAlert(content: "Error while resetting your password"));
    }
  }
}
