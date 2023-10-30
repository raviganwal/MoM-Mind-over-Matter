import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:regexed_validator/regexed_validator.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? iconData;
  final bool? isObscure;
  final bool? isEmail;
  final double? padding;

  const MyTextField({
    required this.controller,
    required this.hintText,
    this.iconData,
    this.isEmail,
    this.isObscure,
    this.padding,
    super.key,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _validator(String value) {
    if (value.trim().isEmpty) {
      return 'field cannot be empty';
    }
    //Check for password
    if (widget.isObscure != null) {
      if (widget.isObscure!) {
        if (value.length < 6) {
          return 'Password must be atleast 6 characters';
        }
        // else if (!validator.password(value)) {
        //   return "Password should contain Upper, Lower, Numbers, Symbol";
        // }
      }
    }
    //Check for email
    if (widget.isEmail != null) {
      if (widget.isEmail!) {
        if (!validator.email(value)) {
          return "Enter a valid email";
        }
      }
    }

    return null;
  }

  @override
  void initState() {
    _obscureText = widget.isObscure ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) => _validator(value ?? ""),
      maxLines: 1,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        hintStyle: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        prefix: widget.iconData != null
            ? Icon(
                widget.iconData,
                color: Colors.black,
                size: 20,
              )
            : const SizedBox(
                width: 16,
              ),
        // suffixIcon: widget.isObscure != null
        //     ? IconButton(
        //         onPressed: _toggleObscureText,
        //         icon: Icon(_obscureText ? Iconsax.eye : Iconsax.eye_slash))
        //     : const SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            width: 2,
            color: Colors.black,
            // style: BorderStyle.none,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: widget.padding ?? 20.0),
      ),
    );
  }
}
