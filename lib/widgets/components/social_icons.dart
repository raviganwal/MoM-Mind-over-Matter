import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialsIcons extends StatefulWidget {
  IconData icon;
  Color color;
  String socialUrl;
  SocialsIcons({required this.icon, required this.color, required this.socialUrl});

  @override
  State<SocialsIcons> createState() => _SocialsIconsState();
}

class _SocialsIconsState extends State<SocialsIcons> {
  Future<void> _launchSocialUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchSocialUrl(Uri.parse(widget.socialUrl));
      },
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(15)),
        child: Icon(
          widget.icon,
          size: 32,
          color: widget.color,
        ),
      ),
    );
  }
}
