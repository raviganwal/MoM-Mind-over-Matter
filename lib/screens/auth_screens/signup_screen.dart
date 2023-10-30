import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/screens/auth_screens/signin_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';
import 'package:mom/widgets/loading_error_widgets/error_alert.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class SignUpScreen extends StatefulWidget {
  String firstName;
  String lastName;
  String gender;
  String country;
  String dateOfBirth;

  SignUpScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.country,
    required this.dateOfBirth,
  });

  // const SignUpScreen({Key? key, required this.title}) : super(key: key);
  // final String title;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SigninController signinController = Get.put(SigninController());
  FirebaseController firebaseController = Get.put(FirebaseController());
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  var rememberValue = false;

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    _rePasswordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: deviceSize.height * 0.98,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                const CustomHeader(title: "Sign Up"),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // MyTextField(
                        //   controller: _firstNameController,
                        //   hintText: "first name",
                        //   iconData: Iconsax.user_tag,
                        // ),
                        // // const SizedBox(height: 20),
                        // MyTextField(
                        //   controller: _lastNameController,
                        //   hintText: "last name",
                        //   iconData: Iconsax.profile_2user,
                        // ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: _emailController,
                          hintText: "Enter your email",
                          // iconData: Iconsax.sms,
                          isEmail: true,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: _passwordController,
                          hintText: "Enter your password",
                          // iconData: Iconsax.lock_1,
                          isObscure: true,
                        ),
                        const SizedBox(height: 20),
                        MyTextField(
                          controller: _rePasswordController,
                          hintText: "Re-enter your password",
                          // iconData: Iconsax.lock_1,
                          isObscure: true,
                        ),
                        const SizedBox(height: 20),
                        const Spacer(),
                        ButtonDesign(
                          btnText: "Sign up",
                          btnFunction: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_passwordController.text.trim() ==
                                  _rePasswordController.text.trim()) {
                                await signinController
                                    .signUpWithEmailAndPassword(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                )
                                    .then((value) async {
                                  //Create user model
                                  User userData = User(
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    email: _emailController.text.trim(),
                                    userId: firebaseAuth.currentUser!.uid,
                                    gender: widget.gender,
                                    country: widget.country,
                                    dateOfBirth: widget.dateOfBirth,
                                    proValidity: "",
                                    enrolledTopic: "1",
                                    activeSprint: "",
                                  );
                                  //Save user data to firebase
                                  await firebaseController
                                      .saveUserData(userData);
                                });
                              } else {
                                Get.dialog(const ErrorAlert(
                                    content: "Password does not match"));
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 36),
                        Text("OR",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF58315A),
                            )),
                        const SizedBox(height: 32),
                        ButtonDesign(
                          btnText: "Signup with Google",
                          prefixWidget: const Icon(
                            FontAwesomeIcons.google,
                            color: Color(0xFF58315A),
                          ),
                          btnFunction: () async {
                            await signinController
                                .signUpWithGoogle()
                                .then((value) async {
                              User userData = User(
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                email: _emailController.text.trim(),
                                userId: firebaseAuth.currentUser!.uid,
                                gender: widget.gender,
                                country: widget.country,
                                dateOfBirth: widget.dateOfBirth,
                                proValidity: "",
                                enrolledTopic: "1",
                                activeSprint: "",
                              );
                              //Save user data to firebase
                              await firebaseController.saveUserData(userData);
                            });
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Already Registered? ",
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        height: 0.1)),
                TextButton(
                  onPressed: () {
                    Get.offAll(() => SignInScreen());
                  },
                  child: Text("Sign In",
                      style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF58315A),
                          height: 0.1)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

// void onProceedPressed(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => PersonalInformationPage()),
//   );
// }
}
