import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/main_screens/community_screens/components/post_item.dart';
import 'package:mom/screens/main_screens/community_screens/post_entry_screen.dart';
import 'package:mom/services/models/post.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({Key? key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String selectedTopic = ''; // Store the selected topic
  String selectedFilter = ''; // Store the selected filter

  // Function to clear the selected topic and filter
  void clearSelection() {
    setState(() {
      selectedTopic = ''; // Clear the selected topic
      selectedFilter = ''; // Clear the selected filter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomHeader(title: "Community"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts exist...'),
            );
          }
          final posts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Post.fromJson(doc.id, data);
          }).toList();

          // Extract unique topicNames from the posts
          final uniqueTopics = Set<String>();
          for (final post in posts) {
            uniqueTopics.add(post.topicName);
          }

          // Convert the set to a list for building the topic buttons
          final uniqueTopicList = uniqueTopics.toList();

          // Filter posts based on the selected topic
          final filteredPosts = selectedTopic.isEmpty
              ? posts
              : posts.where((post) => post.topicName == selectedTopic).toList();

          // Apply filters
          switch (selectedFilter) {
            case 'recent':
              filteredPosts.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
              break;
            case 'oldest':
              filteredPosts.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
              break;
            case 'favorites':
              filteredPosts.sort(
                  (a, b) => b.likedUsers.length.compareTo(a.likedUsers.length));
              break;
            case 'my_posts':
              filteredPosts.retainWhere(
                  (post) => post.userId == firebaseAuth.currentUser!.uid);
              break;
            default:
              break;
          }

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filters",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF957D95),
                        ),
                      ),
                      TextButton.icon(
                        label: const Text("Clear"),
                        icon: const Icon(Icons.clear),
                        onPressed: clearSelection,
                      ),
                    ],
                  ),
                  // Section for filters
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        buildFilterButton("Recent", 'recent'),
                        buildFilterButton("Oldest", 'oldest'),
                        buildFilterButton("Favorites", 'favorites'),
                        buildFilterButton("My Posts", 'my_posts'),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Topics",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF957D95),
                        ),
                      ),
                      TextButton.icon(
                        label: const Text("Clear"),
                        icon: const Icon(Icons.clear),
                        onPressed: clearSelection,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: uniqueTopicList.length,
                      itemBuilder: (context, index) {
                        final topic = uniqueTopicList[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedTopic = topic; // Set the selected topic
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                color: selectedTopic == topic
                                    ? Color(0xFF4B3A5A)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16)),
                            child: Center(child: Text(topic)),
                          ),
                        );
                      },
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredPosts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < filteredPosts.length) {
                        final post = filteredPosts[index];
                        return PostItem(post: post);
                      } else {
                        return const SizedBox(height: 36.0);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const PostEntryScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildFilterButton(String label, String filter) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = filter; // Set the selected filter
        });
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: selectedFilter == filter
                  ? Colors.orange
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)),
          child: Center(child: Text(label))),
    );
  }
}
