import "dart:async";

import "package:flutter/material.dart";
import "package:photos/core/event_bus.dart";
import "package:photos/events/use_media_kit_for_video.dart";
import "package:photos/models/file/file.dart";
import "package:photos/ui/viewer/file/video_widget_media_kit.dart";
import "package:photos/ui/viewer/file/video_widget_native.dart";

class VideoWidget extends StatefulWidget {
  final EnteFile file;
  final String? tagPrefix;
  final Function(bool)? playbackCallback;
  const VideoWidget(
    this.file, {
    this.tagPrefix,
    this.playbackCallback,
    super.key,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool useNativeVideoPlayer = true;
  late final StreamSubscription<UseMediaKitForVideo>
      useMediaKitForVideoSubscription;

  @override
  void initState() {
    super.initState();
    useMediaKitForVideoSubscription =
        Bus.instance.on<UseMediaKitForVideo>().listen((event) {
      setState(() {
        useNativeVideoPlayer = false;
      });
    });
  }

  @override
  void dispose() {
    useMediaKitForVideoSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (useNativeVideoPlayer) {
      return VideoWidgetNative(
        widget.file,
        tagPrefix: widget.tagPrefix,
        playbackCallback: widget.playbackCallback,
      );
    } else {
      return VideoWidgetMediaKit(
        widget.file,
        tagPrefix: widget.tagPrefix,
        playbackCallback: widget.playbackCallback,
      );
    }
  }
}
