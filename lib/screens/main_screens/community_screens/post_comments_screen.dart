import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/main_screens/community_screens/components/comment_bottomsheet.dart';
import 'package:mom/screens/main_screens/community_screens/components/post_item.dart';
import 'package:mom/services/models/comment.dart';
import 'package:mom/services/models/post.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCommentsPage extends StatefulWidget {
  final Post post;

  const PostCommentsPage({super.key, required this.post});

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  bool isLiked = false;

  void handleLikeButtonPress() {
    final currentUserId = firebaseAuth.currentUser!.uid;

    try {
      setState(() {
        if (isLiked) {
          // Remove current user's ID from likedUsers list
          widget.post.likedUsers.remove(currentUserId);
        } else {
          // Add current user's ID to likedUsers list
          widget.post.likedUsers.add(currentUserId);
        }
        isLiked = !isLiked;
      });
      // Update the likedUsers in Firebase Firestore
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(widget.post.id);
      postRef.update({'likedUsers': widget.post.likedUsers});
    } catch (e) {}
  }

  void _handleShareButtonPress() {
    // Define the text you want to share
    const promotionalText =
        "Check out this awesome post on MoM! Download the app now: https://play.google.com/store/apps/details?id=com.appfactory.momapp";

    // Combine the promotional text and post content
    final shareText = "$promotionalText\n\n${widget.post.content}";

    // Use the Share.share method to share the text
    Share.share(shareText);
  }

  void _handleCommentButtonPress() {
    // Show the CommentModalBottomSheet when the comment icon is pressed
    Get.bottomSheet(
      CommentModalBottomSheet(post: widget.post),
    );
  }

  @override
  void initState() {
    if (widget.post.likedUsers.contains(firebaseAuth.currentUser!.uid)) {
      isLiked = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomHeader(title: "Post"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton.filledTonal(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostItem(post: widget.post),

            const SizedBox(height: 21),
            widget.post.comments.isNotEmpty
                ? const Text(
                    "Comments",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  )
                : const SizedBox(),

            // Display the list of comments
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.post.comments.length,
              itemBuilder: (context, index) {
                // Convert the JSON comment to a Comment model
                Comment comment = Comment.fromJson(
                    jsonDecode(widget.post.comments[index])
                        as Map<String, dynamic>);

                return CustomContainer(
                  marginHorizontal: 16,
                  marginVertical: 12,
                  paddingHorizontal: 12,
                  paddingVertical: 12,
                  backgroundColor: Colors.white,
                  borderColor: Colors.blueGrey,
                  child: Column(
                    children: [
                      // Display profile pic, username, date time
                      Row(
                        children: [
                          Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: RandomAvatar(comment.userImgUrl),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.name,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  comment.isVerified
                                      ? Image.asset(
                                          "assets/images/verified.png",
                                          height: 20,
                                          width: 20,
                                        )
                                      : const SizedBox()
                                ],
                              ),

                              const SizedBox(height: 4),
                              Text(timeago.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(widget.post.dateTime)),
                              )),
                              // Format date as needed
                            ],
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: 40.0,
                      //       height: 40.0,
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade100,
                      //         borderRadius: BorderRadius.circular(16),
                      //       ),
                      //       child: ClipOval(
                      //         child: CachedNetworkImage(
                      //           imageUrl: comment.userImgUrl,
                      //           fit: BoxFit.cover,
                      //           placeholder: (context, url) =>
                      //               const Icon(Icons.person),
                      //           errorWidget: (context, url, error) =>
                      //               const Icon(Icons.person),
                      //         ),
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8.0),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(comment.name),
                      //         Text(
                      //           DateFormat('dd MMM yy - HH:mm a').format(
                      //             DateTime.fromMillisecondsSinceEpoch(
                      //                 int.parse(comment.datetime)),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                      // Display comment content
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Text(
                          comment.comment,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
