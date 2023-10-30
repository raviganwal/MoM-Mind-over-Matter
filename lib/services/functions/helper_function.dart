import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mom/services/models/story.dart';
import 'package:mom/services/models/wisdom.dart';

Future<void> addStoriesToFirebase() async {
  const String quoteUrl = 'https://api.quotable.io/random';
  const String videoUrl = 'https://youtu.be/m98mG0ToBSE';
  const String podcastUrl =
      'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37';

  final DateTime now = DateTime.now();
  final DateTime startDate = DateTime(now.year, 1, 1, 0, 0, 0, 0, 0);
  final DateTime endDate = startDate.add(const Duration(days: 365));

  for (DateTime date = startDate;
      date.isBefore(endDate);
      date = date.add(const Duration(days: 1))) {
    // Fetch the quote and author from the quotable API
    final quoteResponse = await http.get(Uri.parse(quoteUrl));
    final quoteData = json.decode(quoteResponse.body);
    final String quote = quoteData['content'];
    final String author = quoteData['author'];

    final String imgUrl = await getRandomNatureImage();

    // Create the story object
    final story = Story(
      id: date.millisecondsSinceEpoch.toString(),
      day: date.toIso8601String(),
      quote: quote,
      author: author,
      videoUrl: videoUrl,
      podcastUrl: podcastUrl,
      shareCount: 0,
      imgUrl: imgUrl,
    );

    // Add the story object to the Firebase collection
    await FirebaseFirestore.instance.collection('stories').doc(story.id).set({
      ...story.toMap(),
      "lastModified": FieldValue.serverTimestamp(),
    });
    print("Story added for ${date.toIso8601String()}");
  }
}

Future<String> getRandomNatureImage() async {
  const String apiKey =
      '563492ad6f91700001000001214c0de2ec184a94ac73d0490ade7abb'; // Replace with your Pexels API key
  const String apiUrl =
      'https://api.pexels.com/v1/search?query=nature&per_page=1&page=1';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {'Authorization': apiKey},
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final photo = data['photos'][0];
    final imgUrl = photo['src']['medium'];

    return imgUrl;
  } else {
    throw Exception('Failed to load image');
  }
}

void pushDummyDataToFirebase() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference wisdomCollection = firestore.collection('wisdom');
  final Random random = Random();

  const String pexelsApiKey =
      '563492ad6f91700001000001214c0de2ec184a94ac73d0490ade7abb';
  const String pexelsUrl =
      'https://api.pexels.com/v1/search?query=nature&per_page=1&page=1';

  for (int i = 1; i <= 5; i++) {
    String currentTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const String contentUrl = 'https://youtu.be/lhK_RKcVdf4';
    // Fetch a nature image URL from the Pexels API
    final pexelsResponse = await http.get(
      Uri.parse(pexelsUrl),
      headers: {'Authorization': pexelsApiKey},
    );
    final pexelsData = json.decode(pexelsResponse.body);
    final String imgUrl = pexelsData['photos'][0]['src']['original'];

    Wisdom dummyWisdom = Wisdom(
        id: currentTimestamp,
        category: 'Video',
        content: contentUrl,
        imgUrl: imgUrl,
        title: 'Mind over Matter become confident',
        contentType: 'youtube',
        description: "");
    await wisdomCollection.add(dummyWisdom.toJson());
  }
}

TimeOfDay stringToTimeofday(String time) {
  List<String> listItem = time.split("|");
  TimeOfDay timeData = TimeOfDay(
    hour: int.parse(listItem[0]),
    minute: int.parse(listItem[1]),
  );
  return timeData;
}

String timeOfDayToString(TimeOfDay time) {
  String oneLine = "${time.hour}|${time.minute}";
  return oneLine;
}

Future<bool> checkConnectivity() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // I am connected to a mobile network
    return false;
  } else {
    return true;
  }
}

void pushTopicsToFirebase() async {
  final topicsCollection = FirebaseFirestore.instance.collection('topics');

  final topics = [
    {
      'id': 1,
      'title': 'Focus',
      'description': 'Improve your focus and concentration',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/4126/4126353.png',
    },
    {
      'id': 2,
      'title': 'Perform Better',
      'description': 'Achieve your goals and improve your performance',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/939/939354.png',
    },
    {
      'id': 3,
      'title': 'Reduce Anxiety',
      'description': 'Find calm and reduce anxiety',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/7145/7145095.png',
    },
    {
      'id': 4,
      'title': 'Reduce Stress',
      'description': 'Relax and reduce stress in your life',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/9306/9306403.png',
    },
    {
      'id': 5,
      'title': 'Sleep',
      'description': 'Improve your sleep quality and quantity',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/3094/3094837.png',
    },
    {
      'id': 6,
      'title': 'Personal Growth',
      'description': 'Grow and develop as a person',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/3406/3406999.png',
    },
    {
      'id': 7,
      'title': 'Happiness',
      'description': 'Find joy and happiness in your life',
      'imgUrl': 'https://cdn-icons-png.flaticon.com/512/9569/9569023.png',
    },
  ];

  for (final topic in topics) {
    await topicsCollection.add(topic);
  }

  print('Topics added to Firebase!');
}

Future<void> addProgramDataToFirebase() async {
  final CollectionReference topicsCollection =
      FirebaseFirestore.instance.collection('topics');

  // Iterate through all the topics documents
  final QuerySnapshot topicsSnap = await topicsCollection.get();
  for (final DocumentSnapshot topicDoc in topicsSnap.docs) {
    // Create the program collection for this topic document
    final CollectionReference programCollection =
        topicDoc.reference.collection('program');

    // Iterate through the 21 program documents
    for (int i = 1; i <= 21; i++) {
      // Create a new program document
      final DocumentReference programDoc = programCollection.doc('program$i');

      // Add the program data to the document
      await programDoc.set({
        'title': 'Program $i',
        'description': 'This is the description for Program $i',
        'day': i,
        'isAudio': true,
        'isVideo': true,
        'isText': true,
        'videoUrl': 'https://youtu.be/m98mG0ToBSE',
        'audioUrl':
            'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37',
        'textContent': 'This is the text content for Program $i',
      });
    }
  }
}
