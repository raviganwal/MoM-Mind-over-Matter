import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/widgets/ui_widgets/close_button.dart';

AppBar appBarDesign({
  required String title,
  required bool isLeading,
  Color? bgColor,
}) {
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.poppins(
        color: Colors.blueGrey,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
    ),
    backgroundColor: bgColor ?? Colors.transparent,
    centerTitle: false,
    elevation: 0,
    automaticallyImplyLeading: false,
    leading: isLeading
        ? const Padding(
            padding: EdgeInsets.all(12.0),
            child: MyCloseButton(),
          )
        : null,
  );
}
