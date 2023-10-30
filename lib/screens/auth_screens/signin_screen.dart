import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/screens/auth_screens/reset_password.dart';
import 'package:mom/screens/auth_screens/signup_screen.dart';
import 'package:mom/screens/auth_screens/stepper_screen.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:regexed_validator/regexed_validator.dart';

class SignInScreen extends StatefulWidget {
  // const LoginUI({Key? key, required this.title}) : super(key: key);
  // final String title;

  @override
  State<SignInScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<SignInScreen> {
  SigninController signinController = Get.put(SigninController());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var rememberValue = false;
  bool isAPIcallProcess = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: _formKey,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Center(child: CustomHeader(title: "Hey there")),
                const SizedBox(
                  height: 32,
                ),
                Text("Welcome back!\nWe missed you",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                const SizedBox(
                  height: 32,
                ),
                MyTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  // iconData: Iconsax.sms,
                  isEmail: true,
                ),
                const SizedBox(height: 24),
                MyTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  // iconData: Iconsax.lock_1,
                  isObscure: true,
                ),
                const SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        Get.to(() => const ResetPasswordScreen());
                      },
                      child: Text("Forgot Password?",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ))),
                ),
                const SizedBox(height: 16),
                ButtonDesign(
                  btnText: "Sign in",
                  bgColor: const Color(0xFF80D0DD),
                  btnFunction: () async {
                    if (_formKey.currentState!.validate()) {
                      await signinController.signInWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 28),
                Center(
                  child: Text("OR",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF58315A),
                      )),
                ),
                const SizedBox(height: 24),
                ButtonDesign(
                  btnText: "Continue with Google",
                  marginVertical: 21,
                  // bgColor: Colors.white,
                  prefixWidget: const Icon(
                    FontAwesomeIcons.google,
                    color: Color(0xFF58315A),
                  ),
                  btnFunction: () async {
                    await signinController.signInWithGoogle();
                  },
                ),
                const SizedBox(height: 36),
                Center(
                  child: Text("Not registered yet? ",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.0,
                      )),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const StepperScreen());
                  },
                  child: Text("Create an Account",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 0.1,
                        color: const Color(0xFF58315A),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
