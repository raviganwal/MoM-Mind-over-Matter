import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:mom/services/models/wisdom.dart';
import 'package:mom/widgets/components/appbar_design.dart';

class AudioPlayerScreen extends StatefulWidget {
  Wisdom wisdomData;
  AudioPlayerScreen({super.key, required this.wisdomData});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool isAutoPlay = true;
  Duration _position = Duration.zero;

  @override
  void initState() {
    _player.setUrl(widget.wisdomData.content);
    _player.playerStateStream.listen((state) {
      if (state.playing && isAutoPlay) {
        _player.play();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDesign(title: "", isLeading: true),
      body: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.wisdomData.imgUrl,
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Lottie.asset(
                      "assets/animations/tape.json",
                      height: 100,
                      repeat: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.wisdomData.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              _position = snapshot.data ?? Duration.zero;
              final duration = _player.duration ?? Duration.zero;
              if (_player.duration == _position) {
                _player.pause();
              }
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Slider(
                      value: _position.inSeconds.toDouble(),
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _player.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}'),
                        Text('${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: () {
                            _player.seek(_position - const Duration(seconds: 10));
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(8),
                          decoration:
                              BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                            icon: Icon(
                              _player.playing ? Icons.pause : Icons.play_arrow,
                              size: 32,
                            ),
                            onPressed: () {
                              if (_player.playing) {
                                _player.pause();
                              } else {
                                _player.play();
                                setState(() {
                                  isAutoPlay = true;
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () {
                            _player.seek(_position + const Duration(seconds: 10));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
