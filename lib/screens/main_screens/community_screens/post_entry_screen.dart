import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mom/services/controllers/hive_controller.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:random_avatar/random_avatar.dart';

class PostEntryScreen extends StatefulWidget {
  const PostEntryScreen({super.key});

  @override
  _PostEntryScreenState createState() => _PostEntryScreenState();
}

class _PostEntryScreenState extends State<PostEntryScreen> {
  final TextEditingController _postController = TextEditingController();
  HiveController hiveController = Get.put(HiveController());

  String selectedMood = 'normal'; // Default mood is 'normal'

  // List of available moods
  final List<String> moods = [
    'General questions',
    'Anxiety',
    'Depression',
    'Panic attack',
    'Work Life Balance',
    'Burnout',
    'Grateful',
    'Relationship',
    'Concentration',
    'Sleep issues',
  ];

  // Function to save the post to Firebase Firestore
  Future<void> _savePostToFirestore() async {
    String avtarUrl = await getAvatar();

    final newPost = {
      'userName': hiveController.userData.value.firstName,
      'userId': firebaseAuth.currentUser!.uid,
      'avatarUrl': avtarUrl,
      'dateTime': DateTime.now().millisecondsSinceEpoch.toString(),
      'topicName': selectedMood,
      'content': _postController.text,
      'likedUsers': <String>[],
      'comments': <String>[],
      'isVerified': false,
      'timeStamp': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('posts').add(newPost);
      _postController.clear();
      Get.back();
    } catch (error) {
      print('Error saving post: $error');
      // Handle the error as needed
    }
  }

  Future<String> getAvatar() async {
    String ranSvg = RandomAvatarString(firebaseAuth.currentUser!.uid);
    return ranSvg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomHeader(title: "Create"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8.0, // Adjust the spacing between chips
              children: moods.map((mood) {
                return ChoiceChip(
                  label: Text(mood),
                  selected: selectedMood == mood,
                  selectedColor: Colors.orange.shade200,
                  backgroundColor: Colors.grey.shade200,
                  onSelected: (selected) {
                    setState(() {
                      selectedMood = selected ? mood : 'normal';
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _postController,
                  maxLines: 50,
                  decoration: const InputDecoration(
                    hintText: 'Write your thoughts...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ButtonDesign(
                btnText: "Post",
                btnFunction: () {
                  _savePostToFirestore();
                })
          ],
        ),
      ),
    );
  }
}
