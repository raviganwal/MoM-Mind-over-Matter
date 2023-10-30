import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mom/screens/feature_screens/summernote_screen.dart';
import 'package:mom/screens/feature_screens/youtube_player.dart';
import 'package:mom/services/controllers/firebase_controller.dart';
import 'package:mom/services/models/program.dart';
import 'package:mom/services/models/sprint.dart';
import 'package:mom/utils/global_const.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/ui_widgets/close_button.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:just_audio/just_audio.dart';

class ProgramDetailScreen extends StatefulWidget {
  final Program program;

  const ProgramDetailScreen({Key? key, required this.program})
      : super(key: key);

  @override
  _ProgramDetailScreenState createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends State<ProgramDetailScreen> {
  late YoutubePlayerController _youtubeController;
  late AudioPlayer _audioPlayer;
  String _selectedOption = 'Video';
  final firebaseController = Get.put(FirebaseController());

  late Timer _timer;
  int _audioTimerDuration = 0;
  int _audioTimerElapsed = 0;

  @override
  void initState() {
    super.initState();
    _youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.program.videoUrl)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(widget.program.audioUrl);
  }

  Widget _buildVideoPlayer() {
    return Column(
      children: [
        Expanded(
            child: CustomContainer(
          marginVertical: 12,
          paddingHorizontal: 8,
          paddingVertical: 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: YoutubePlayer(
              controller: _youtubeController,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ),
        )),
        TextButton(
            onPressed: () {
              Get.to(
                  () => YouTubePlayerScreen(videoUrl: widget.program.videoUrl));
            },
            child: const Text("Watch full screen"))
      ],
    );
  }

  Widget _buildAudioPlayer() {
    return StreamBuilder<Duration?>(
      stream: _audioPlayer.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return CustomContainer(
          marginVertical: 12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<Duration>(
                stream: _audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 16.0,
                        percent: position.inSeconds / duration.inSeconds,
                        center: Container(),
                        progressColor: Colors.green,
                        backgroundColor: Colors.green.shade100,
                        circularStrokeCap: CircularStrokeCap.round,
                        reverse: true,
                      ),
                      Text(
                        position.toString().split('.').first,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  );
                },
              ),
              // StreamBuilder<Duration>(
              //   stream: _audioPlayer.positionStream,
              //   builder: (context, snapshot) {
              //     final position = snapshot.data ?? Duration.zero;
              //     return Padding(
              //       padding: const EdgeInsets.all(12.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(position.toString().split('.').first),
              //           Text(duration.toString().split('.').first),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              Center(
                child: CustomContainer(
                  paddingHorizontal: 8,
                  paddingVertical: 8,
                  child: GestureDetector(
                    onTap: () {
                      if (_audioPlayer.playing) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                      setState(() {});
                    },
                    child: Icon(
                      _audioPlayer.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 48,
                      color: const Color(0xFF58315A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    return ButtonDesign(
        btnText: "Click to Read the article",
        marginVertical: 16,
        btnFunction: () {
          Get.to(() => SummernoteScreen(
                articleContent: widget.program.textContent,
              ));
        });
  }

  Widget _buildContent() {
    switch (_selectedOption) {
      case 'Video':
        return _buildVideoPlayer();
      case 'Audio':
        return _buildAudioPlayer();
      case 'Text':
        return _buildTextContent();
      default:
        return Container();
    }
  }

  List<DropdownMenuItem<String>> _buildDropdownItems() {
    final items = <DropdownMenuItem<String>>[];
    if (widget.program.isVideo) {
      items.add(const DropdownMenuItem<String>(
        value: 'Video',
        child: Text('Video'),
      ));
    }
    if (widget.program.isAudio) {
      items.add(const DropdownMenuItem<String>(
        value: 'Audio',
        child: Text('Audio'),
      ));
    }
    if (widget.program.isText) {
      items.add(const DropdownMenuItem<String>(
        value: 'Text',
        child: Text('Text'),
      ));
    }
    return items;
  }

  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomHeader(title: "Day ${widget.program.day}"),
                  const MyCloseButton(),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.program.title,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.program.description,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                            fontSize: 12,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    paddingHorizontal: 12,
                    paddingVertical: 1,
                    marginVertical: 8,
                    child: DropdownButton<String>(
                      value: _selectedOption,
                      items: _buildDropdownItems(),
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _buildContent(),
              ),
              widget.program.quizlink!.isNotEmpty
                  ? ButtonDesign(
                      btnText: "Take Quiz",
                      btnFunction: () async {
                        await _launchUrl(Uri.parse(widget.program.quizlink!));
                      })
                  : const SizedBox(),
              ButtonDesign(
                  btnText: "Mark as Complete",
                  marginVertical: 16,
                  bgColor: const Color(0xFFECBB5F),
                  btnFunction: () {
                    Sprint sprintValue = Sprint(
                      userId: firebaseAuth.currentUser!.uid,
                      topicId: widget.program.topicId,
                      day: widget.program.day,
                      isCompleted: true,
                      completedOn:
                          DateTime.now().millisecondsSinceEpoch.toString(),
                    );
                    firebaseController.markAsComplete(sprintValue);
                  }),
              // ElevatedButton(
              //   onPressed: () {
              //     Sprint sprintValue = Sprint(
              //       userId: firebaseAuth.currentUser!.uid,
              //       topicId: widget.program.topicId,
              //       day: widget.program.day,
              //       isCompleted: true,
              //       completedOn: DateTime.now().millisecondsSinceEpoch.toString(),
              //     );
              //     firebaseController.markAsComplete(sprintValue);
              //   },
              //   child: const Text("Mark as complete"),
              // )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}
