import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mom/screens/feature_screens/audio_player.dart';
import 'package:mom/screens/feature_screens/summernote_screen.dart';
import 'package:mom/screens/feature_screens/youtube_player.dart';
import 'package:mom/services/models/wisdom.dart';
import 'package:mom/widgets/components/appbar_design.dart';
import 'package:mom/widgets/components/button_design.dart';
import 'package:mom/widgets/ui_widgets/custom_container.dart';
import 'package:mom/widgets/ui_widgets/custom_header.dart';

class WisdomDetailScreen extends StatefulWidget {
  Wisdom wisdom;
  WisdomDetailScreen({Key? key, required this.wisdom}) : super(key: key);

  @override
  State<WisdomDetailScreen> createState() => _WisdomDetailScreenState();
}

class _WisdomDetailScreenState extends State<WisdomDetailScreen> {
  bool isArticle = false;
  playContent() {
    String mediaType = widget.wisdom.contentType;
    switch (mediaType) {
      case 'video':
        // Handle video type
        break;
      case 'audio':
        Get.to(() => AudioPlayerScreen(wisdomData: widget.wisdom));
        break;
      case 'youtube':
        Get.to(() => YouTubePlayerScreen(videoUrl: widget.wisdom.content));
        break;
      case 'text':
        Get.to(() => SummernoteScreen(articleContent: widget.wisdom.content));
        break;
      default:
        // Handle unknown type
        break;
    }
  }

  Widget getContentTypeIcon() {
    String contentType = widget.wisdom.contentType;
    switch (contentType) {
      case 'video':
        return const Icon(Icons.video_library);
      case 'audio':
        return const Icon(Icons.audiotrack);
      case 'youtube':
        return const Icon(Icons.play_circle_fill);
      case 'text':
        return const Icon(Icons.article);
      default:
        return const Icon(Icons.perm_media);
    }
  }

  @override
  void initState() {
    if (widget.wisdom.contentType == "text") {
      isArticle = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDesign(title: "", isLeading: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: const CustomHeader(title: "Wisdom")),
            CustomContainer(
                height: 200,
                paddingHorizontal: 12,
                paddingVertical: 12,
                marginHorizontal: 20,
                marginVertical: 16,
                backgroundColor: const Color(0xFF66C4BC),
                child: Stack(
                  children: [
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.wisdom.imgUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    isArticle
                        ? const SizedBox()
                        : Center(
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF58315A),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                ),
                                iconSize: 46,
                                color: Colors.white,
                                onPressed: () {
                                  playContent();
                                },
                              ),
                            ),
                          ),
                  ],
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.wisdom.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          getContentTypeIcon(),
                          const SizedBox(width: 8),
                          Text(widget.wisdom.contentType),
                        ],
                      ),
                      Text(
                        DateFormat("MMM dd , yyyy").format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.wisdom.id))),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'What\'s it about?',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.wisdom.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            !isArticle
                ? const SizedBox()
                : ButtonDesign(
                    btnText: "Read Article",
                    bgColor: const Color(0xFF96D1BD),
                    marginHorizontal: 24,
                    marginVertical: 12,
                    btnFunction: () async {
                      Get.to(() => SummernoteScreen());
                    },
                  ),
            // ElevatedButton(
            //     onPressed: () {
            //       Get.to(() => SummernoteScreen());
            //     },
            //     child: const Text("Read full article"),
            //   ),
          ],
        ),
      ),
    );
  }
}
