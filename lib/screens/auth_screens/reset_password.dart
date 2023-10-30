import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/services/controllers/signin_controller.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/components/my_textfield.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    SigninController signinController = Get.put(SigninController());
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Reset password"),
      // ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            children: [
              const CustomHeader(title: "Reset"),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 15),
                    Text("Enter Email",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _emailController,
                      hintText: "Enter your email",
                      iconData: Iconsax.sms,
                      isEmail: true,
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 10),
                    ButtonDesign(
                      btnText: "Reset Password",
                      bgColor: const Color(0xFF80D0DD),
                      txtColor: Colors.black,
                      btnFunction: () async {
                        if (_formKey.currentState!.validate()) {
                          await signinController
                              .resetPassword(
                                  email: _emailController.text.trim())
                              .then((value) {
                            Fluttertoast.showToast(
                                msg: "Check your email inbox");
                          });
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
