import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mom/screens/feature_screens/track_screens/track_dashboard.dart';
import 'package:mom/screens/feature_screens/track_screens/track_history.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class TracksScreen extends StatefulWidget {
  const TracksScreen({Key? key}) : super(key: key);

  @override
  _TracksScreenState createState() => _TracksScreenState();
}

class _TracksScreenState extends State<TracksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          child: Column(children: [
            const SizedBox(height: 10),
            const CustomHeader(title: "Check-in"),
            const SizedBox(height: 10),
            Container(
              height: 45,
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF66C4BC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 5),
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: const Color(0xFF020035),
                  borderRadius: BorderRadius.circular(20),
                ),
                labelStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                tabs: const <Widget>[
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.calendar_1,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.chart_2,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'History',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // Tab(
                  //   child: Row(
                  //     children: const [
                  //       Icon(Iconsax.medal_star, size: 16),
                  //       SizedBox(width: 3),
                  //       Text('Daily Checkins'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  TrackDashboardScreen(),
                  TrackHistoryScreen(),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
