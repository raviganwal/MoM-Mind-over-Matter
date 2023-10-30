import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/story.dart';
import 'package:mom/services/models/story_data.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final List<StoryContent> _storyContentList = [];
  Story? receivedStory;
  int _currentIndex = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Timer _timer;
  int _audioTimerDuration = 0;
  int _audioTimerElapsed = 0;

  YoutubePlayerController? _youtubePlayerController;
  final firebaseController = Get.put(FirebaseController());

  @override
  void initState() {
    super.initState();
    _loadStoryContent();
  }

  void _startTimer() {
    _audioTimerDuration = _audioPlayer.duration!.inSeconds;
    _audioTimerElapsed = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _audioTimerElapsed++;
      });

      if (_audioTimerElapsed >= _audioTimerDuration) {
        _timer.cancel();
      }
    });
  }

  void _updateTimer() {
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _audioTimerElapsed = position.inSeconds;
      });
    });
  }

  void _loadStoryContent() async {
    // Load story content from API or local storage
    Story story = firebaseController.story.value;
    receivedStory = story;
    // Story(
    //   id: '1684521000000',
    //   day: '2023-05-20T00:00:00.000',
    //   quote: 'They say that time changes things, but you actually have to change them yourself.',
    //   author: 'Andy Warhol',
    //   imgUrl: 'https://images.pexels.com/photos/15286/pexels-photo.jpg',
    //   videoUrl: 'https://youtu.be/m98mG0ToBSE',
    //   podcastUrl:
    //       'https://firebasestorage.googleapis.com/v0/b/momapp-wellbeing.appspot.com/o/podcasts_daily%2Fpodcast-mom.mp3?alt=media&token=5b985c06-3838-40f1-909f-334333592b37',
    //   shareCount: 0,
    // );

    // Add story content to the list
    _storyContentList.add(StoryContent(
      type: StoryContentType.QUOTE,
      content: story.quote,
    ));
    _storyContentList.add(StoryContent(
      type: StoryContentType.VIDEO,
      content: story.videoUrl,
    ));
    _storyContentList.add(StoryContent(
      type: StoryContentType.PODCAST,
      content: story.podcastUrl,
    ));
    _storyContentList.add(StoryContent(
      type: StoryContentType.COMPLETION,
    ));

    // Initialize the YoutubePlayerController
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(story.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    // Initialize the AudioPlayer
    await _audioPlayer.setUrl(story.podcastUrl);
  }

  void _previousContent() {
    setState(() {
      _currentIndex--;
    });
  }

  void _nextContent() {
    if (_currentIndex < _storyContentList.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildTopProgressBar(),
            Expanded(
              child: CustomContainer(
                backgroundColor: Colors.white,
                marginHorizontal: 20,
                marginVertical: 20,
                // paddingHorizontal: 10,
                // paddingVertical: 10,
                child: _buildContent(),
              ),
            ),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    double progress = _audioTimerElapsed / _audioTimerDuration;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: LinearPercentIndicator(
        percent: progress,
        lineHeight: 10,
        progressColor: Colors.blue,
        backgroundColor: Colors.grey,
      ),
    );
  }

  Widget _buildContent() {
    StoryContent content = _storyContentList[_currentIndex];

    switch (content.type) {
      case StoryContentType.QUOTE:
        return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF90DBF4),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(receivedStory!.imgUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  receivedStory!.quote,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "- ${receivedStory!.author}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ));
      case StoryContentType.VIDEO:
        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFEB18F),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: YoutubePlayer(
              controller: _youtubePlayerController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
            ),
          ),
        );
      case StoryContentType.PODCAST:
        return Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFCFBAF0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 100,
                    lineWidth: 16.0,
                    percent: _audioTimerElapsed / _audioTimerDuration,
                    center: Container(),
                    progressColor: Colors.green,
                    backgroundColor: Colors.green.shade100,
                    circularStrokeCap: CircularStrokeCap.round,
                    reverse: true,
                  ),
                  Text(
                    '${(_audioTimerDuration - _audioTimerElapsed) ~/ 60}:${(_audioTimerDuration - _audioTimerElapsed) % 60}',
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_audioPlayer.playing) {
                        _audioPlayer.pause();
                        _timer.cancel();
                      } else {
                        _audioPlayer.play();
                        _startTimer();
                      }
                    });
                  },
                  child: Icon(
                    _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
        );
      case StoryContentType.COMPLETION:
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFCFD2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Lottie.asset("assets/animations/tick.json"),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Story Completed!',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  // Widget _buildContent() {
  //   StoryContent content = _storyContentList[_currentIndex];
  //   switch (content.type) {
  //     case StoryContentType.QUOTE:
  //       return Center(
  //         child: Text(
  //           content.content!,
  //           style: const TextStyle(fontSize: 24),
  //         ),
  //       );
  //     case StoryContentType.VIDEO:
  //       return YoutubePlayer(
  //         controller: _youtubePlayerController!,
  //         showVideoProgressIndicator: true,
  //         progressIndicatorColor: Colors.amber,
  //       );
  //     case StoryContentType.PODCAST:
  //       return Center(
  //         child: IconButton(
  //           icon: Icon(
  //             _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
  //             size: 50,
  //           ),
  //           onPressed: () {
  //             if (_audioPlayer.playing) {
  //               _audioPlayer.pause();
  //             } else {
  //               _audioPlayer.play();
  //             }
  //           },
  //         ),
  //       );
  //     case StoryContentType.COMPLETION:
  //       return Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: const [
  //             Icon(
  //               Icons.check_circle_outline,
  //               size: 100,
  //               color: Colors.green,
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'Story Completed!',
  //               style: TextStyle(fontSize: 24),
  //             ),
  //           ],
  //         ),
  //       );
  //     default:
  //       return Container();
  //   }
  // }

  Widget _buildTopProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      height: 10,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 2 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _currentIndex == 3 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _currentIndex == _storyContentList.length - 1
              ? const SizedBox()
              : ButtonDesign(
                  btnText: "Share",
                  paddingValue: 8,
                  marginVertical: 10,
                  suffixWidget: const Icon(
                    Icons.share,
                    size: 18,
                    color: Color(0xFF58315A),
                  ),
                  btnFunction: () {
                    StoryContent content = _storyContentList[_currentIndex];
                    String stdText =
                        "MoM - Mind over Matter: The best app to improve your mental health. \n";
                    //  "Here's you story, \n\nQuote:${firebaseController.story.value.quote}\n\nAuthor:${firebaseController.story.value.author}\n\nVideo:${firebaseController.story.value.videoUrl}\n\nPodcast:${firebaseController.story.value.podcastUrl}");
                    switch (content.type) {
                      case StoryContentType.QUOTE:
                        Share.share(
                            stdText + firebaseController.story.value.quote);
                        break;
                      case StoryContentType.VIDEO:
                        Share.share(
                            "$stdText  Watch the video using this link: ${firebaseController.story.value.videoUrl}");
                        break;
                      case StoryContentType.PODCAST:
                        Share.share(
                            "$stdText  Listen to Podcast using this link: ${firebaseController.story.value.podcastUrl}");
                        break;
                      default:
                        Share.share(
                            "${stdText}Share the app with your friends and family!");
                        break;
                    }
                  }),
          const Spacer(),
          if (_currentIndex > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _previousContent,
            ),
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _currentIndex == _storyContentList.length - 1
                ? () => Navigator.pop(context)
                : _nextContent,
          ),
        ],
      ),
    );
  }
}
