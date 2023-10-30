import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/screens/main_screens/wisdom_screens/categroy_item_screen.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/wisdom.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:mom/widgets/ui_widgets/wisdom_tile.dart';

class WisdomScreen extends StatefulWidget {
  const WisdomScreen({Key? key}) : super(key: key);

  @override
  _WisdomScreenState createState() => _WisdomScreenState();
}

class _WisdomScreenState extends State<WisdomScreen> {
  late Future<List<Wisdom>> _futureWisdom;
  late Future<bool> _proValidity;

  @override
  void initState() {
    super.initState();
    _futureWisdom = _fetchWisdom();
    _proValidity = checkProValidity();
  }

  Future<bool> checkProValidity() async {
    // Implement the logic to check the user's pro validity using the Firebase database
    // Return true if the user is a pro user, false otherwise
    return await FirebaseController().checkProValidity();
  }

  Future<List<Wisdom>> _fetchWisdom() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('wisdom').get();
      final List<Wisdom> wisdomList =
          snapshot.docs.map((doc) => Wisdom.fromJson(doc.data())).toList();
      return wisdomList;
    } catch (e) {
      throw Exception('Failed to fetch wisdom: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          const CustomHeader(title: "Wisdom"),
          Expanded(
            child: FutureBuilder<List<Wisdom>>(
              future: _futureWisdom,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Wisdom>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final Map<String, List<Wisdom>> groupedWisdom = {};
                    for (var wisdom in snapshot.data!) {
                      if (!groupedWisdom.containsKey(wisdom.category)) {
                        groupedWisdom[wisdom.category] = [];
                      }
                      groupedWisdom[wisdom.category]!.add(wisdom);
                    }
                    // // create a list of titles
                    List<String> titles = groupedWisdom.keys.toList();
                    return ListView.builder(
                      itemCount: titles.length,
                      itemBuilder: (BuildContext context, int index) {
                        String category = titles[index];
                        List<Wisdom> categoryList = groupedWisdom[category]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    category,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.to(() => CategoryItemsScreen(
                                            categoryList: categoryList,
                                            category: category,
                                          ));
                                    },
                                    child: const Text(
                                      'See more',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: categoryList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Wisdom wisdom = categoryList[index];
                                  return FutureBuilder<bool>(
                                    future: _proValidity,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool> proSnapshot) {
                                      final bool isProUser =
                                          proSnapshot.hasData &&
                                              proSnapshot.data == true;
                                      bool isLocked = !isProUser &&
                                          index >
                                              0; // Lock all tiles except the first for non-pro users
                                      return WisdomTile(
                                        wisdom: wisdom,
                                        isLocked: isLocked,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('Error fetching wisdom: ${snapshot.error}'));
                  } else {
                    return const Center(child: Text('No wisdom found.'));
                  }
                } else {
                  return Center(
                      child: Text(
                          'Connection state: ${snapshot.connectionState}'));
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
