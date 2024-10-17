import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'model.dart';

class VideoPreviewScreen extends StatefulWidget {
  VideoPreviewScreen({
    super.key,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  final Map<int, VideoPlayerController> _controllers = {};
  late List<Model> model;

  final List<Uri> videoUris = [
    Uri.parse(
      'https://drive.google.com/uc?export=download&id=1tPZo5IWVlbY_xk4W5mEPcWwAyCEK-LSS',
    ),
    Uri.parse(
        'https://drive.google.com/uc?export=download&id=1K38QKG39uiCQJ1xasm9R04njv0zCLVB8'),
    Uri.parse(
        'https://drive.google.com/uc?export=download&id=1cpm7XTq6Oe0el1vHbvQtbw1rEvRsZwGo'),
    Uri.parse(
        'https://drive.google.com/uc?export=download&id=1WWKt7EvJhgvj-jIH0kwlWzYxGEjhBhsO'),
    Uri.parse(
        'https://drive.google.com/uc?export=download&id=1g0R9hVgKn93NpUztRFLhECthA7_dWerR'),
  ];

  @override
  void initState() {
    super.initState();
    Model.addModel();
    _initializeControllers(); // Add this line
    // Automatically play the first video for 5 seconds
    Future.delayed(const Duration(seconds: 0), () {
      _controllers[0]?.play();
      Future.delayed(const Duration(seconds: 6), () {
        _controllers[0]?.pause();
      });
    });
  }

  // Initialize controllers for each video in the model list
  void _initializeControllers() {
    for (int i = 0; i < Model.model.length; i++) {
      final VideoPlayerController controller =
          VideoPlayerController.networkUrl(videoUris[i])..setLooping(true);

      // Initialize the controller and then set the volume to 0 to mute the video
      controller.initialize().then((_) {
        controller.setVolume(0.0); // Mute the video
        setState(() {}); // Update UI once the video is initialized
      });

      _controllers[i] = controller;
    }
  }

  @override
  void dispose() {
    _controllers.forEach((index, controller) => controller.dispose());
    super.dispose();
  }

  void _playVideo(int index) {
    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i]?.play();
      } else {
        _controllers[i]?.pause(); // Pause other videos
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Preview Screen'),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: Model.model.length,
          itemBuilder: (context, index) {
            final Model model = Model.model[index];
            final controller = _controllers[index];

            return GestureDetector(
              // onTap: () {
              //   _playVideo(index);
              // },
              onTapCancel: () => _playVideo(index),
              child: VisibilityDetector(
                key: Key('product-video-$index'),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction > 0.5) {
                    controller!.play();
                    setState(() {});
                  } else {
                    controller!.pause();
                  }
                  setState(() {});
                },
                child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 2.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image

                            controller?.value.isInitialized == true
                                ? AspectRatio(
                                    aspectRatio: controller!.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                : Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 120,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 8),
                            // Product Name
                            Text(
                              model.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            //Product Price
                            Text(
                              model.price,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            );
          }),
    );
  }
}
