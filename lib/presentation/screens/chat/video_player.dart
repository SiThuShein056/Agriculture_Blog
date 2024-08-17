import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  VideoPlayerWidget({super.key, required this.uri});
  String uri;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late CachedVideoPlayerController _videoPlayerController
      // , _videoPlayerController2,
      //     _videoPlayerController3
      ;

  late CustomVideoPlayerController _customVideoPlayerController;
  // late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings(showSeekButtons: true);

  // final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
  //     CustomVideoPlayerWebSettings(
  //   src: longVideo,
  // );

  @override
  void initState() {
    super.initState();

    _videoPlayerController = CachedVideoPlayerController.network(
      widget.uri,
    )..initialize().then((value) => setState(() {}));
    // _videoPlayerController2 = CachedVideoPlayerController.network(video240);
    // _videoPlayerController3 = CachedVideoPlayerController.network(video480);
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      // additionalVideoSources: {
      //   "240p": _videoPlayerController2,
      //   "480p": _videoPlayerController3,
      //   "720p": _videoPlayerController,
      // },
    );

    // _customVideoPlayerWebController = CustomVideoPlayerWebController(
    //   webVideoPlayerSettings: _customVideoPlayerWebSettings,
    // );
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video View Screen"),
      ),
      body: Center(
        child: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController,
        ),
      ),
    );
  }
}
