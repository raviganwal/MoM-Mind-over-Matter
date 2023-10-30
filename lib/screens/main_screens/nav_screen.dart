import 'package:flutter/material.dart';
import 'package:mom/screens/main_screens/course_screens/all_topic_screen.dart';
import 'package:mom/screens/main_screens/course_screens/course_screen.dart';
import 'package:mom/screens/feature_screens/track_screens/tracks_screen.dart';
import 'package:mom/screens/home_screen.dart';
import 'package:mom/screens/main_screens/community_screens/community_screen.dart';
import 'package:mom/screens/main_screens/profile_screen.dart';
import 'package:mom/screens/main_screens/wisdom_screens/wisdom_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class NavScreen extends StatefulWidget {
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  late PersistentTabController _controller;
  var _selectedTab = 0;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: const Color(0xFFB9E7E5),
        inactiveColorPrimary: Color(0xFF66C4BC),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.menu_book),
        title: "Wisdom",
        activeColorPrimary: const Color(0xFFB9E7E5),
        inactiveColorPrimary: Color(0xFF66C4BC),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.play_circle_fill_rounded),
        title: "Topics",
        activeColorPrimary: const Color(0xFFB9E7E5),
        // activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color(0xFF66C4BC),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_month),
        title: "Tracks",
        activeColorPrimary: const Color(0xFFB9E7E5),
        inactiveColorPrimary: Color(0xFF66C4BC),
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        title: "Community",
        activeColorPrimary: const Color(0xFFB9E7E5),
        inactiveColorPrimary: Color(0xFF66C4BC),
      ),
    ];
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const WisdomScreen(),
      const AllTopicScreen(),
      const TracksScreen(),
      const CommunityScreen(),
    ];
  }

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = i;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: _selectedTab);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color(0xFF020035),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: const ItemAnimationProperties(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style9,
      ),
    );
  }
}
