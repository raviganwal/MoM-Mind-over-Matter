import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mom/services/models/checkin.dart';
import 'package:mom/services/models/program.dart';
import 'package:mom/services/models/sprint.dart';
import 'package:mom/services/models/story.dart';
import 'package:mom/services/models/topic.dart';
import 'package:mom/services/models/user.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/loading_error_widgets/please_wait.dart';
import 'package:mom/widgets/ui_widgets/loading_screen.dart';

class FirebaseController extends GetxController {
  //Variables
  var story = Story(
    id: '1684521000000',
    day: '2023-05-20T00:00:00.000',
    quote:
        'They say that time changes things, but you actually have to change them yourself.',
    author: 'Andy Warhol',
    imgUrl: 'https://images.pexels.com/photos/15286/pexels-photo.jpg',
    videoUrl: 'https://youtu.be/m98mG0ToBSE',
    podcastUrl:
        'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37',
    shareCount: 0,
  ).obs;

  //Save user information to firebase
  Future<void> saveUserData(User user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "email": user.email,
      "userId": user.userId,
      "gender": user.gender,
      "country": user.country,
      "dateOfBirth": user.dateOfBirth,
      "proValidity": "",
      "enrolledTopic": user.enrolledTopic,
      "activeSprint": user.activeSprint,
    });
  }

//Check pro validity
  Future<bool> checkProValidity() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        final proValidity = userDoc.data()!['proValidity'] as String?;
        if (proValidity != null) {
          final currentDateTime = DateTime.now();
          final proValidityDateTime =
              DateTime.fromMillisecondsSinceEpoch(int.parse(proValidity));
          if (currentDateTime.isBefore(proValidityDateTime)) {
            // The proValidity period is still valid
            return true;
          }
        }
      }
    } catch (e) {
      print('Error checking proValidity: $e');
    }
    // The proValidity period is expired or not found
    return false;
  }

  //Save user information to firebase
  Future<void> updateUserData(User user) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      "firstName": user.firstName,
      "lastName": user.lastName,
      "gender": user.gender,
      "country": user.country,
      "dateOfBirth": user.dateOfBirth,
    });
  }

  static Future<User?> fetchUserDataFromFirebase() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid);
    final userDocSnapshot = await userDocRef.get();
    if (userDocSnapshot.exists) {
      final userData =
          User.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
      return userData;
    } else {
      return null;
    }
  }

  static Future<String?> getActiveTopic() async {
    final snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid);
    final userDocSnapshot = await snapshot.get();
    if (userDocSnapshot.exists) {
      final userData =
          User.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
      return userData.enrolledTopic;
    }
    return null;
  }

  Future<Sprint> getSprint(String topic) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('sprint')
        .where('topicId', isEqualTo: topic)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final sprintDoc = snapshot.docs.first;
      return Sprint(
        userId: sprintDoc['userId'],
        topicId: sprintDoc['topicId'],
        day: sprintDoc['day'],
        isCompleted: sprintDoc['isCompleted'],
        completedOn: sprintDoc['completedOn'],
      );
    } else {
      final newSprint = Sprint(
        userId: firebaseAuth.currentUser!.uid,
        topicId: topic,
        day: 1,
        isCompleted: false,
        completedOn: DateTime.now().toString(),
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('sprint')
          .add(newSprint.toJson());
      return newSprint;
    }
  }

  // void addParametersToTopics() async {
  //   final CollectionReference topicsCollection = FirebaseFirestore.instance.collection('topics');

  //   // Get all the documents in the topics collection
  //   final QuerySnapshot topicsSnapshot = await topicsCollection.get();
  //   final List<DocumentSnapshot> topicDocuments = topicsSnapshot.docs;

  //   // Loop through each document and add the parameters
  //   for (final DocumentSnapshot topicDocument in topicDocuments) {
  //     await topicDocument.reference
  //         .update({'startQuiz': 'https://docs.google.com/forms/u/0/', 'endQuiz': 'https://docs.google.com/forms/u/0/'});
  //   }
  // }

  Future<String> fetchTopicName() async {
    try {
      // Get enrolled topic ID from Firebase users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      final enrolledTopicId = userDoc.get('enrolledTopic');

      // Find the topic document in Firebase topics collection with matching ID
      final topicQuerySnapshot = await FirebaseFirestore.instance
          .collection('topics')
          .where('topicId', isEqualTo: enrolledTopicId)
          .get();
      final topicDoc = topicQuerySnapshot.docs.first;
      final topicData = topicDoc.data();

      // Convert topic document to Topic model
      final topic = Topic.fromJson(topicData);

      // Return topic title
      return topic.title;
    } catch (error) {
      // Return empty string on error
      return '';
    }
  }

  static Future<List<Program>> getProgramsForTopic(String topicId) async {
    final programs = <Program>[];
    final topicQuerySnapshot = await FirebaseFirestore.instance
        .collection('topics')
        .where('topicId', isEqualTo: topicId)
        .get();
    final topicDocSnapshot = topicQuerySnapshot.docs.first;
    final programCollectionSnapshot = await topicDocSnapshot.reference
        .collection('program')
        .orderBy('day', descending: false)
        .get();
    final queryList = programCollectionSnapshot.docs;
    for (var i = 0; i < queryList.length; i++) {
      final program = Program.fromJson(queryList[i].data());
      programs.add(program);
    }
    return programs;
  }

  // static Future<void> updateProgramsWithTopicIds() async {
  //   final topicsSnapshot = await FirebaseFirestore.instance.collection('topics').get();
  //   for (final topicDocSnapshot in topicsSnapshot.docs) {
  //     final topicId = topicDocSnapshot.get('topicId');
  //     final programCollectionSnapshot = await topicDocSnapshot.reference.collection('program').get();
  //     for (final programDocSnapshot in programCollectionSnapshot.docs) {
  //       await programDocSnapshot.reference.update({'topicId': topicId});
  //     }
  //   }
  // }

  Future<void> fetchStory1() async {
    final DateTime now = DateTime.now();
    final DateTime today =
        DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    final String todayId = today.millisecondsSinceEpoch.toString();

    final collection = FirebaseFirestore.instance.collection('stories');
    final querySnapshot =
        await collection.where('id', isEqualTo: todayId).get();

    if (querySnapshot.docs.isNotEmpty) {
      story.value = Story.fromJson(querySnapshot.docs.first.data());
      print(querySnapshot.docs.first.data());
    }
  }

  Future<void> fetchStory() async {
    final now = DateTime.now();
    final documentName =
        '${now.year} ${now.month.toString().padLeft(2, '0')} ${now.day.toString().padLeft(2, '0')}';
    final storiesCollection = FirebaseFirestore.instance.collection('stories');
    final querySnapshot = await storiesCollection.doc(documentName).get();
    if (querySnapshot.exists) {
      story.value = Story.fromJson(querySnapshot.data()!);
    } else {
      Fluttertoast.showToast(
          msg:
              "Problem fetching today's story. Check your internet conneciton");
    }
  }

  Future<void> populateStoriesCollection() async {
    // Initialize the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Sample story data
    String videoUrl = 'https://youtu.be/m98mG0ToBSE';
    String imgUrl = 'https://images.pexels.com/photos/15286/pexels-photo.jpg';
    String podcastUrl =
        'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37';
    String quote = "You can win";

    // Loop through all the 365 days
    for (int i = 1; i <= 365; i++) {
      // Create a new story object
      Story story = Story(
        id: i.toString(),
        day: DateTime.now().add(Duration(days: i)).toString().substring(0, 10),
        quote:
            "$quote ${DateTime.now().add(Duration(days: i)).toString().substring(0, 10)}",
        author: "Anonymous",
        imgUrl: imgUrl,
        videoUrl: videoUrl,
        podcastUrl: podcastUrl,
        shareCount: 0,
      );

      // Add the story to Firestore
      await firestore
          .collection('stories')
          .doc(story.day.replaceAll('-', ' '))
          .set(story.toMap());
    }
  }

  Future<void> saveCheckinData(Checkin checkin) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection("checkin");
    await collection.doc(checkin.datetime).set({
      "mood": checkin.mood,
      "sleep": checkin.sleep,
      "datetime": checkin.datetime,
      "userId": checkin.userId,
      "sleepStart": checkin.sleepStart,
      "sleepEnd": checkin.sleepEnd,
    });
  }

  Future<void> markAsComplete(Sprint sprint) async {
    // Create a reference to the user's sprints collection
    final sprintCollectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('sprint');

    // Query for existing sprints with the same topicId
    final existingSprintQuery = await sprintCollectionRef
        .where('topicId', isEqualTo: sprint.topicId)
        .get();

    if (existingSprintQuery.docs.isNotEmpty) {
      // There is an existing sprint for this topicId
      final existingSprintDoc = existingSprintQuery.docs.first;
      final existingSprint = Sprint.fromJson(existingSprintDoc.data());

      if (sprint.day > existingSprint.day) {
        // The new sprint is for a later day, update the existing sprint
        existingSprint.isCompleted = true;
        existingSprint.day = sprint.day;
        existingSprint.completedOn =
            DateTime.now().millisecondsSinceEpoch.toString();
        await existingSprintDoc.reference.update(existingSprint.toJson());
      } else {
        // The new sprint is for the same or earlier day, do not update
        Get.back();
        Fluttertoast.showToast(msg: "Already completed");
        return;
      }
    } else {
      // There is no existing sprint for this topicId, create a new one
      final newSprint = Sprint(
        userId: sprint.userId,
        topicId: sprint.topicId,
        day: sprint.day,
        isCompleted: true,
        completedOn: DateTime.now().toString(),
      );
      await sprintCollectionRef.add(newSprint.toJson());
    }

    // Update the user's active sprint
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid);
    await userRef.update({
      'activeSprint':
          sprint.topicId, // Update with topicId instead of sprintRef.id
    });

    // Navigate back to the previous screen
    Get.back();
  }

  Future<double> fetchProgressPercentage() async {
    // 1. Fetch user data from Firebase
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid);
    final userDocSnapshot = await userDocRef.get();
    if (!userDocSnapshot.exists) {
      // If user document doesn't exist, return 0 progress
      return 0.0;
    }
    User? userData = await fetchUserDataFromFirebase();

    // 2. Fetch topic data from Firebase
    final topicDocRef = FirebaseFirestore.instance
        .collection('topics')
        .doc(userData!.enrolledTopic);
    final topicDocSnapshot = await topicDocRef.get();
    if (!topicDocSnapshot.exists) {
      // If topic document doesn't exist, return 0 progress
      return 0.0;
    }
    final topicData =
        Topic.fromJson(topicDocSnapshot.data() as Map<String, dynamic>);

    // 3. Fetch maximum day value for the enrolled topic's program
    final programDocsSnapshot = await topicDocRef.collection('program').get();
    final maxDay = programDocsSnapshot.docs
        .map((doc) => Program.fromJson(doc.data() as Map<String, dynamic>).day)
        .reduce((value, element) => value > element ? value : element);

    // 4. Fetch the user's active sprint
    final activeSprintDocRef =
        userDocRef.collection('sprint').doc(userData.activeSprint);
    final activeSprintDocSnapshot = await activeSprintDocRef.get();
    if (!activeSprintDocSnapshot.exists) {
      // If active sprint document doesn't exist, return 0 progress
      return 0.0;
    }
    final activeSprintData =
        Sprint.fromJson(activeSprintDocSnapshot.data() as Map<String, dynamic>);

    // 5. Filter sprints by topicId and get the highest day value
    final sprintsQuerySnapshot = userDocRef
        .collection('sprint')
        .where('topicId', isEqualTo: userData.enrolledTopic)
        .get();
    final highestDay = (await sprintsQuerySnapshot)
        .docs
        .map((doc) => Sprint.fromJson(doc.data() as Map<String, dynamic>))
        .where((sprint) => sprint.day <= maxDay)
        .map((sprint) => sprint.day)
        .reduce((value, element) => value > element ? value : element);

    // 6. Calculate progress percentage
    final progressPercentage = highestDay / maxDay;

    return progressPercentage;
  }

  Future<bool> isCheckinAvailableForToday() async {
    Get.dialog(const PleaseWait());
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);

      final checkinRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('checkin');

      final querySnapshot = await checkinRef.get();

      final isTodayCheckinAvailable = querySnapshot.docs.any((doc) {
        final timestampInMillis = int.parse(doc['datetime'] as String);
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestampInMillis);
        final dateWithoutTime =
            DateTime(dateTime.year, dateTime.month, dateTime.day);
        return dateWithoutTime == todayDate;
      });

      Get.back();
      return isTodayCheckinAvailable;
    }
    Get.back();
    return false;
  }
}
