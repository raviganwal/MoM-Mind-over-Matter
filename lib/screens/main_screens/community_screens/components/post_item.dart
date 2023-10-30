import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:mom/screens/main_screens/community_screens/components/comment_bottomsheet.dart';
import 'package:mom/screens/main_screens/community_screens/post_comments_screen.dart';
import 'package:mom/services/models/post.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostItem extends StatefulWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
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
      // isScrollControlled: true,
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
    final avatarUrl = widget.post.avatarUrl;

    return GestureDetector(
      onTap: () {
        Get.to(() => PostCommentsPage(post: widget.post));
      },
      child: CustomContainer(
        marginHorizontal: 4,
        marginVertical: 12,
        paddingHorizontal: 12,
        paddingVertical: 12,
        backgroundColor: Colors.white,
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
                    child: RandomAvatar(avatarUrl),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: Colors.brown.shade100,
                                borderRadius: BorderRadius.circular(16)),
                            child: Text(
                              widget.post.topicName,
                              style: GoogleFonts.montserrat(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const SizedBox(width: 8),
                        widget.post.isVerified
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
            // Display post content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                widget.post.content,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown,
                ),
              ),
            ),
            // Display like, share, and comment buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Iconsax.like_15 : Iconsax.like_1,
                    color: isLiked ? Colors.pink : Colors.grey,
                  ),
                  onPressed: () {
                    handleLikeButtonPress();
                  },
                ),
                Text(
                  widget.post.likedUsers.length.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.message),
                  onPressed: () {
                    _handleCommentButtonPress();
                  },
                ),
                Text(
                  widget.post.comments.length.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.share),
                  onPressed: () {
                    _handleShareButtonPress();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
