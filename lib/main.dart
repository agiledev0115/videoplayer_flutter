import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:instagram_public_api/instagram_public_api.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  // late VideoPlayerController _controller1;
  String url = '';
  String url1 = '';
  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  Future initPlayer() async {
    final List<InstaPost> post = await FlutterInsta().getPostData(
        "https://www.instagram.com/reel/CohqWpyDNSm/?utm_source=ig_web_copy_link");
    // final List<InstaPost> post1 = await FlutterInsta().getPostData(
    //     "https://www.instagram.com/tv/CTfdcAWB1AM/?utm_source=ig_web_copy_link");
    url = post[0].displayURL.toString();
    // url1 = post1[0].displayURL.toString();
    _controller = VideoPlayerController.network(url);
    _initializeVideoPlayerFuture = _controller!.initialize()
      ..then((_) {
        setState(() {
          _controller!.play();
        });
      });
    return _initializeVideoPlayerFuture;
    // _controller1 = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  bool get isVideoPlaying {
    return _controller?.value?.isPlaying != null &&
        _controller!.value.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () =>
              _dialogBuilder(context, _controller /*, _controller1*/),
          child: const Text('Open Dialog'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (isVideoPlaying) {
              _controller?.pause();
            } else {
              _controller?.play();
            }
          });
        },
        child: Icon(
          isVideoPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(
      BuildContext context,
      VideoPlayerController?
          _controller /*, VideoPlayerController _controller1*/) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: _controller != null && _controller!.value!.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller!.value!.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : Container(),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Enable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
