import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_app/model/video_model.dart';

import '../../util/notification_service.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel data;
  const VideoPlayerScreen({super.key, required this.data});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse('${widget.data.videourl}'));
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.play();
    notificationService.initialiseNotification();
    setState(() {});
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Video Player screen"),
      ),
      body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Stack(children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(_controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow),
                              onPressed: () {
                                setState(() {
                                  _controller!.value.isPlaying
                                      ? _controller!.pause()
                                      : _controller!.play();
                                });
                              },
                            ),
                            Text('${_controller!.value.position}'),

                          ],
                        ),

                      ]),
                    )
                  ]),
                  ListTile(
                    title: Text(widget.data.videoTitle.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(widget.data.videoLocalTitle.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                    trailing: IconButton(
                        onPressed: () async {
                          await notificationService
                              .downloadFile('${widget.data.videourl}');
                        },
                        icon: const Icon(Icons.download)),
                  )
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
