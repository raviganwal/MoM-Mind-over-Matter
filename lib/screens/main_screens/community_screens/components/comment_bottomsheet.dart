import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/services/models/comment.dart';
import 'package:mom/services/models/post.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:random_avatar/random_avatar.dart';

class CommentModalBottomSheet extends StatefulWidget {
  final Post post;

  const CommentModalBottomSheet({super.key, required this.post});

  @override
  _CommentModalBottomSheetState createState() =>
      _CommentModalBottomSheetState();
}

class _CommentModalBottomSheetState extends State<CommentModalBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  HiveController hiveController = Get.put(HiveController());

  void _handleSaveComment() async {
    // Get the comment text from the controller
    final String commentText = _commentController.text.trim();

    Future<String> getAvatar() async {
      String ranSvg = RandomAvatarString(firebaseAuth.currentUser!.uid);
      return ranSvg;
    }

    final img = await getAvatar();

    if (commentText.isNotEmpty) {
      Comment newComment = Comment(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // You can generate a unique ID here
        userId: firebaseAuth.currentUser!.uid,
        name: hiveController
            .userData.value.firstName, // Replace with actual user name
        datetime: DateTime.now().millisecondsSinceEpoch.toString(),
        comment: commentText,
        userImgUrl: img,
        isVerified: false,
      );

      // Convert the comment to a JSON map
      Map<String, dynamic> commentMap = newComment.toJson();

      // Add the comment to the post's comments list in Firebase Firestore
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(widget.post.id);
      postRef.update({
        'comments': FieldValue.arrayUnion([jsonEncode(commentMap)]),
      });

      // Clear the comment input field
      _commentController.clear();

      // Close the bottom sheet
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                controller: _commentController,
                maxLines: null, // Allow multi-line input
                decoration: const InputDecoration(
                  hintText: 'Write a comment...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ButtonDesign(
              btnText: "Comment",
              btnFunction: () {
                _handleSaveComment();
              })
        ],
      ),
    );
  }
}
