// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingSubtitle extends StatelessWidget {
  String title;
  SettingSubtitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 25, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.blueGrey, fontWeight: FontWeight.w500),
      ),
    );
  }
}
