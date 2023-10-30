import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertPopup extends StatelessWidget {
  String? title;
  String message;
  Function onBtnPress;
  Color? btnColor;
  String? btnName;
  AlertPopup({
    this.title,
    this.btnColor,
    this.btnName,
    required this.message,
    required this.onBtnPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      title: Text(
        title ?? "Alert",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      content: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: double.infinity,
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.3), borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.left,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9C9EA8),
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onBtnPress();
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: btnColor ?? Colors.teal),
          child: Text(
            btnName ?? "Proceed",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
