// ignore_for_file: must_be_immutable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:vtv/utils/palette.dart';

class CustomPlayer extends StatefulWidget {
  CustomPlayer({
    Key? key,
    required this.link,
    required this.id,
    required this.name,
    required this.image,
    required this.popOnError,
  }) : super(key: key);
  String? id;
  bool popOnError;
  final String link;
  final String image;
  final String name;
  // final String path;
  @override
  State<CustomPlayer> createState() => _CustomPlayerState();
}

class _CustomPlayerState extends State<CustomPlayer> with Palette {
  late final VideoPlayerController _videoController;
  late final ChewieController _chewieController;
  Widget? _chewieWidget;
  init() async {
    try {
      setState(() {
        unableToPlay = false;
        _chewieWidget = null;
      });
      _videoController = VideoPlayerController.network(
        widget.link,
        // formatHint: VideoFormat.dash,
      );

      await _videoController.initialize();
      // _videoController.
      print("DURATION ${_videoController.value.duration}");
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          looping: false,
          showControls: true,
          // isLive: true,
          allowFullScreen: true,
          // allowMuting: true,
          allowPlaybackSpeedChanging: true,
          allowedScreenSleep: false,
          showOptions: true,
          deviceOrientationsAfterFullScreen: [
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ],
        );
        _chewieWidget = Chewie(
          controller: _chewieController,
        );
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Vidéo en direct indisponible");
      print("NO VIDEO ON STREAM : $e");
      if (widget.popOnError) {
        Navigator.of(context).pop();
      } else {
        setState(() {
          _chewieWidget = null;
          unableToPlay = true;
        });
      }
      return;
    }
  }

  bool unableToPlay = false;
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_chewieWidget != null) {
      _videoController.dispose();
      _chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    try {
      return LayoutBuilder(builder: (context, c) {
        final double w = c.maxWidth;
        return _chewieWidget != null
            ? AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: _chewieWidget,
              )
            : unableToPlay
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.grey.shade900,
                      height: 160,
                      width: w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await init();
                            },
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const Text(
                            "Rafraîchir",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 160,
                      color: Colors.grey.shade900,
                      width: w,
                      child: Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  );
      });
    } catch (e) {
      return Center(
        child: Text(
          "ERROR : $e",
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
