import 'package:firebase_auth/firebase_auth.dart';
import 'package:mom/services/models/story.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//Mongo URL
const mongoURL =
    "mongodb+srv://dummyuser:helloworld@cluster0.mph1uoc.mongodb.net/momapp?retryWrites=true&w=majority";

const mongoUserCollection = "";

//Variables used
List<int> selectedTopics = [];

//Hive box names
String hCommonBox = "common";
String hIsNotify = "isNotify";
String hDailyTime = "notifyTime";
String hCheckinTime = "checkintime";
String hProgramTime = "programtime";
String hFirstName = "firstname";
String hLastName = "lastname";
String hEmail = "userEmail";
String hUserId = "user_id";
String hDob = "dob";
String hGender = "gender";
String hCountry = "country";
String hProvalidity = "pro_validity";
String hEnrolledTopic = "enrolled_topic";
String hActiveSprint = "active_sprint";

//Notifications
String nBasicChannel = 'basic_channel';

//Login type
enum LoginOption {
  google,
  email,
  apple,
}

//Common URLs
final Uri privacyurl =
    Uri.parse('https://openmindovermatter.com/privacy-policy/');
final Uri moreappsurl = Uri.parse('https://play.google.com/');
final Uri playStoreUrl = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.appfactory.momapp');
final Uri mailUrl = Uri(
  scheme: 'mailto',
  path: 'momsocial08@gmail.com',
  query:
      'subject= MoM App Feedback&body=App Feedback', //add subject and body here
);
final Uri termsurl =
    Uri.parse('https://openmindovermatter.com/terms-conditions/');
final Uri coffeeUrl = Uri.parse('https://www.buymeacoffee.com/');
final Uri podcastStory = Uri.parse('https://forms.gle/LqwVfsKaoafgoUtX7');

//Dummy Story Data
// {imgUrl: https:
//images.pexels.com/photos/15286/pexels-photo.jpg, shareCount: 0, quote: Begin at once to live and count each separate day as a separate life., videoUrl: https://youtu.be/m98mG0ToBSE, author: Seneca the Younger, podcastUrl: https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37, lastModified: Timestamp(seconds=1679133176, nanoseconds=388000000), id: 1679077800000, day: 18}
// Story dummyStory = Story(
//   id: '1679077800000',
//   day: 18,
//   quote: 'Begin at once to live and count each separate day as a separate life.',
//   author: 'Seneca the Younger',
//   imgUrl: 'https:images.pexels.com/photos/15286/pexels-photo.jpg',
//   videoUrl: 'https://youtu.be/m98mG0ToBSE',
//   podcastUrl:
//       'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37',
//   shareCount: 0,
// );
