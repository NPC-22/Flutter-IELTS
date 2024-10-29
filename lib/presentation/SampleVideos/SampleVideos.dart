import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../../routes/app_pages.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailAssetPath; // Modified
  late final String videoUrl;

  Video({
    required this.title,
    required this.thumbnailAssetPath, // Modified
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      thumbnailAssetPath: json['thumbnailAssetPath'], // Modified
      videoUrl: json['videoUrl'],
    );
  }
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [];

  final TextStyle appBarTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    List<String> videoUrls = [
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video1.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video2.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video3.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video4.mp4',
    ];

    List<String> thumbnailAssetPaths = [
      'assets/thumbnail/thumbnail1.webp',
      'assets/thumbnail/thumbnail2.webp',
      'assets/thumbnail/thumbnail3.webp',
      'assets/thumbnail/thumbnail4.webp',
    ];

    List<String> titles = [
      'Where do you want to stay?',
      'How are going pay tuition for?',
      'How did you got to know about this opportunity?',
      'What is XSR in Web development',
    ];

    for (int i = 0; i < videoUrls.length; i++) {
      sampleVideos.add(
        Video(
          title: titles[i],
          thumbnailAssetPath: thumbnailAssetPaths[i],
          videoUrl: videoUrls[i],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sample Videos',
          style: appBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(Routes.DASHBOARD);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: sampleVideos[index],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset( // Modified
                      sampleVideos[index].thumbnailAssetPath, // Modified
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      sampleVideos[index].title,
                      textAlign: TextAlign.center,
                      style: appBarTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.video.videoUrl);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.video.title ?? 'Video Title';
    int maxLines = (title.length / 20).ceil();
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.1,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: maxLines,
                    style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                leading: BackButton(),
                backgroundColor: Colors.white,
                centerTitle: false,
                floating: true,
                pinned: true,
                snap: true,
              ),
            ];
          },
          body: Center(
            child: _isVideoLoading
                ? CircularProgressIndicator()
                : Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ),
    );
  }
}

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
    );
  }
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [];

  final TextStyle appBarTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black, // Ensure text color is black
  );

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  void fetchVideos() async {
    // Fetch video data from URLs
    List<String> videoUrls = [
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video1.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video2.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video3.mp4',
      'https://d2g0cr4389rk9o.cloudfront.net/video/videos/video4.mp4',
    ];

    List<String> thumbnailUrls = [
      'https://d2g0cr4389rk9o.cloudfront.net/video/thumbnails/thumbnail1.png',
      'https://d2g0cr4389rk9o.cloudfront.net/video/thumbnails/thumbnail2.png',
      'https://d2g0cr4389rk9o.cloudfront.net/video/thumbnails/thumbnail3.png',
      'https://d2g0cr4389rk9o.cloudfront.net/video/thumbnails/thumbnail4.png',
    ];

    List<String> titles = [
      'Where do you want to stay?',
      'How are going pay tuition for?',
      'How did you got to know about this opportunity?',
      'What is XSR in Web development',
    ];

    for (int i = 0; i < videoUrls.length; i++) {
      sampleVideos.add(
        Video(
          title: titles[i],
          thumbnailUrl: thumbnailUrls[i],
          videoUrl: videoUrls[i],
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sample Videos',
          style: appBarTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: sampleVideos[index],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      sampleVideos[index].thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      sampleVideos[index].title,
                      textAlign: TextAlign.center,
                      style: appBarTextStyle.copyWith(
                        fontWeight: FontWeight.bold, // Make text bold
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.video.videoUrl);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.video.title ?? 'Video Title';
    int maxLines = (title.length / 20).ceil();
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.1,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: maxLines,
                    style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                leading: BackButton(),
                backgroundColor: Colors.white,
                centerTitle: false,
                floating: true,
                pinned: true,
                snap: true,
              ),
            ];
          },
          body: Center(
            child: _isVideoLoading
                ? CircularProgressIndicator()
                : Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ),
    );
  }
}


 */
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoAsset;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoAsset,
  });
}
 
class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [
    Video(
      title: 'Where do you want to stay?',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video1.mp4',
    ),
    Video(
      title: 'How are going pay tuition for?',
      thumbnailUrl: 'assets/thumbnail/thumbnail2.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: "How did you got to know about this opportunity?",
      thumbnailUrl: 'assets/thumbnail/thumbnail3.png',
      videoAsset: 'assets/videos/video3.mp4',
    ),
    Video(
      title: 'What is XSR in Web development',
      thumbnailUrl: 'assets/thumbnail/thumbnail4.png',
      videoAsset: 'assets/videos/video4.mp4',
    ),
  ];

  // Define a TextStyle object
  final TextStyle appBarTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sample Videos',
          style: appBarTextStyle, // Apply the TextStyle here
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Add spacing between each box
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: sampleVideos[index],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                // Thumbnail
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      sampleVideos[index].thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay Play Button
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                // Title Box
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      sampleVideos[index].title,
                      textAlign: TextAlign.center,
                      style: appBarTextStyle, // Apply the same TextStyle here
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset(widget.video.videoAsset);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.video.title ?? 'Video Title';
    int maxLines = (title.length / 20)
        .ceil(); // Adjust based on your preference
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                // Adjust as needed
                title: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    // Align text to the start (left)
                    maxLines: maxLines,
                    style: TextStyle(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                leading: BackButton(),
                // Adding a leading back button
                backgroundColor: Colors.white,
                // Setting app bar color
                centerTitle: false,
                // Centering title
                floating: true,
                // App bar will be shown floating
                pinned: true,
                // App bar will be pinned
                snap: true, // Snap app bar when scrolling reaches its limit
              ),
            ];
          },
          body: Center(
            child: _isVideoLoading
                ? CircularProgressIndicator() // Show loading indicator
                : Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoAsset;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoAsset,
  });
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [
    Video(
      title: 'Where do you want to stay?',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video1.mp4',
    ),
    Video(
      title: 'How are going pay tuition for?',
      thumbnailUrl: 'assets/thumbnail/thumbnail2.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: "How did you got to know about this opportunity?",
      thumbnailUrl: 'assets/thumbnail/thumbnail3.png',
      videoAsset: 'assets/videos/video3.mp4',
    ),
    Video(
      title: 'What is XSR in Web development',
      thumbnailUrl: 'assets/thumbnail/thumbnail4.png',
      videoAsset: 'assets/videos/video4.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sample Videos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Add spacing between each box
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: sampleVideos[index],
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                // Thumbnail
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      sampleVideos[index].thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Overlay Play Button
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
                // Title Box
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      sampleVideos[index].title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.video.videoAsset);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.1, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // Center the title
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.video.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: _isVideoLoading
              ? CircularProgressIndicator() // Show loading indicator
              : Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoAsset;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoAsset,
  });
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [
    Video(
      title: 'Where do you want to stay?',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video1.mp4',
    ),
    Video(
      title: 'How are going pay tuition for?',
      thumbnailUrl: 'assets/thumbnail/thumbnail2.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: "How did you got to know about this opportunity?",
      thumbnailUrl: 'assets/thumbnail/thumbnail3.png',
      videoAsset: 'assets/videos/video3.mp4',
    ),
    Video(
      title: 'What is XSR in Web development',
      thumbnailUrl: 'assets/thumbnail/thumbnail4.png',
      videoAsset: 'assets/videos/video4.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sample Videos',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  video: sampleVideos[index],
                ),
              ),
            );
          },
          child: Stack(
            children: [
              // Thumbnail
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    sampleVideos[index].thumbnailUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Overlay Play Button
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),
              // Title Box
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(
                    sampleVideos[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
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
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.video.videoAsset);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.1, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // Center the title
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.video.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: _isVideoLoading
              ? CircularProgressIndicator() // Show loading indicator
              : Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}


 */


/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoAsset;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoAsset,
  });
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [
    Video(
      title: 'Where do you want to stay?',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video1.mp4',
    ),
    Video(
      title: 'How are going pay tuition for?',
      thumbnailUrl: 'assets/thumbnail/thumbnail2.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: "How did you got to know about this opportunity?",
      thumbnailUrl: 'assets/thumbnail/thumbnail3.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: 'What is XSR in Web development',
      thumbnailUrl: 'assets/thumbnail/thumbnail4.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sample Videos',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  video: sampleVideos[index],
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Thumbnail
              Container(
                height: 180,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Image.asset(
                      sampleVideos[index].thumbnailUrl,
                      fit: BoxFit.cover, // Fit the image to cover the entire container
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment(0.5, -3.0616171314629196e-17),
                            end: Alignment(0.5, 0.9999999999999999),
                            colors: [
                              Color(0xFF99111112),
                              Color(0xFF99111112),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  sampleVideos[index].title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.video.videoAsset);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.1, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // Center the title
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.video.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: _isVideoLoading
              ? CircularProgressIndicator() // Show loading indicator
              : Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoAsset;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoAsset,
  });
}

class SampleVideos extends StatefulWidget {
  SampleVideos({Key? key});

  @override
  _SampleVideosState createState() => _SampleVideosState();
}

class _SampleVideosState extends State<SampleVideos> {
  List<Video> sampleVideos = [
    Video(
      title: 'Sample Video 1',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video1.mp4',
    ),
    Video(
      title: 'Sample Video 2',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: 'Sample Video 3',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
    Video(
      title: 'Sample Video 4',
      thumbnailUrl: 'assets/thumbnail/thumbnail1.png',
      videoAsset: 'assets/videos/video2.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sample Videos',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: _buildVideoList(),
      ),
    );
  }

  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: sampleVideos.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  video: sampleVideos[index],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Thumbnail
                  Image.asset(
                    sampleVideos[index].thumbnailUrl,
                    fit: BoxFit.fill,
                    height: 180.00,
                    width: 390.00,
                  ),
                  // Play button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.5, -3.0616171314629196e-17),
                          end: Alignment(0.5, 0.9999999999999999),
                          colors: [
                            Color(0xFF99111112),
                            Color(0xFF99111112),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final Video video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isVideoLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(widget.video.videoAsset);
    await _videoPlayerController.initialize();
    setState(() {
      _isVideoLoading = false;
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoInitialize: true,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.1, // Adjust as needed
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true, // Center the title
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.video.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Center(
          child: _isVideoLoading
              ? CircularProgressIndicator() // Show loading indicator
              : Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}


 */


//activity indicatorr
//tips and tricks
// Center align the names
/*
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoDemo extends StatefulWidget {
  const VideoDemo({super.key});

  final String title = "Sample Videos";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  late PageController _pageController;
  late List<ChewieController> _chewieControllers;
  int _currentPageIndex = 0;

  List<String> videoTitles = [
    "Where do you want to stay?",
    "How are you going to pay tuition?"
  ]; // Titles for videos

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _chewieControllers = [
      ChewieController(
        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4")..initialize().then((_) {
          setState(() {});
        }),
        autoPlay: false,
        looping: true,
      ),
      ChewieController(
        videoPlayerController: VideoPlayerController.asset("videos/video2.mp4")..initialize().then((_) {
          setState(() {});
        }),
        autoPlay: false,
        looping: true,
      ),
    ];
  }

  @override
  void dispose() {
    for (final controller in _chewieControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = _calculateAspectRatio(context); // Calculate aspect ratio here
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Videos"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _chewieControllers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      videoTitles[index], // Display title here
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set text color to dark black
                      ),
                    ),
                  ),
                  Expanded(
                    child: Chewie(
                      controller: _chewieControllers[index],
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe left or right for more videos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateAspectRatio(BuildContext context) {
    // You can customize this logic based on your requirements
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Example: Use a fixed aspect ratio or adjust based on screen size
    return screenWidth / screenHeight;
  }
}

void main() {
  runApp(MaterialApp(
    home: VideoDemo(),
  ));
}


 */


/*import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoDemo extends StatefulWidget {
  VideoDemo() : super();

  final String title = "Sample Videos";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  late PageController _pageController;
  late List<ChewieController> _chewieControllers;
  int _currentPageIndex = 0;

  List<String> videoTitles = [
    "Where do you want to stay?",
    "How are you going to pay tuition?"
  ]; // Titles for videos

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _chewieControllers = [
      ChewieController(
        videoPlayerController: VideoPlayerController.asset("videos/video1.mp4"),
        autoPlay: false,
        looping: true,
      ),
      ChewieController(
        videoPlayerController: VideoPlayerController.asset("videos/video2.mp4"),
        autoPlay: false,
        looping: true,
      ),
    ];
  }

  @override
  void dispose() {
    for (final controller in _chewieControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Videos"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _chewieControllers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      videoTitles[index], // Display title here
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Set text color to dark black
                      ),
                    ),
                  ),
                  Expanded(
                    child: Chewie(
                      controller: _chewieControllers[index],
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe left or right for more videos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


 */

/*
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  VideoDemo() : super();

  final String title = "Sample Videos";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  late PageController _pageController;
  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;
  int _currentPageIndex = 0;

  List<String> videoTitles = ["Where do you want to stay?", "How are going pay tuition for?"]; // Titles for videos

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = [
      VideoPlayerController.asset("videos/video1.mp4"),
      VideoPlayerController.asset("videos/video2.mp4"),
      //VideoPlayerController.asset("videos/video3.mp4"),
    ];
    _initializeVideoPlayerFutures = List.generate(
      _controllers.length,
          (index) => _controllers[index].initialize(),
    );
    for (final controller in _controllers) {
      controller.setLooping(true);
      controller.setVolume(1.0);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Videos"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _controllers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _initializeVideoPlayerFutures[index],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            videoTitles[index], // Display title here
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: _controllers[index].value.aspectRatio,
                              child: Stack(
                                children: [
                                  VideoPlayer(_controllers[index]),
                                  Positioned.fill(
                                    child: Center(
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_controllers[index].value.isPlaying) {
                                              _controllers[index].pause();
                                            } else {
                                              _controllers[index].play();
                                            }
                                          });
                                        },
                                        child: Icon(
                                          _controllers[index].value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe left or right for more videos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  VideoDemo() : super();

  final String title = "Sample Videos";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  late PageController _pageController;
  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;
  int _currentPageIndex = 0;

  List<String> videoTitles = ["Title 1", "Title 2", "Title 3"]; // Titles for videos

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = [
      VideoPlayerController.asset("videos/video1.mp4"),
      VideoPlayerController.asset("videos/video2.mp4"),
      VideoPlayerController.asset("videos/video3.mp4"),
    ];
    _initializeVideoPlayerFutures = List.generate(
      _controllers.length,
          (index) => _controllers[index].initialize(),
    );
    for (final controller in _controllers) {
      controller.setLooping(true);
      controller.setVolume(1.0);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Videos"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _controllers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _initializeVideoPlayerFutures[index],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            videoTitles[index], // Display title here
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: _controllers[index].value.aspectRatio,
                              child: VideoPlayer(_controllers[index]),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe left or right for more videos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controllers[_currentPageIndex].value.isPlaying) {
              _controllers[_currentPageIndex].pause();
            } else {
              _controllers[_currentPageIndex].play();
            }
          });
        },
        child: Icon(
          _controllers[_currentPageIndex].value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}



 */
/*import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDemo extends StatefulWidget {
  VideoDemo() : super();

  final String title = "Sample Videos";

  @override
  VideoDemoState createState() => VideoDemoState();
}

class VideoDemoState extends State<VideoDemo> {
  late PageController _pageController;
  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = [
      VideoPlayerController.asset("videos/video1.mp4"),
      VideoPlayerController.asset("videos/video2.mp4"),
      VideoPlayerController.asset("videos/video3.mp4"),
    ];
    _initializeVideoPlayerFutures = List.generate(
      _controllers.length,
          (index) => _controllers[index].initialize(),
    );
    for (final controller in _controllers) {
      controller.setLooping(true);
      controller.setVolume(1.0);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Demo"),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _controllers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: _initializeVideoPlayerFutures[index],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _controllers[index].value.aspectRatio,
                        child: VideoPlayer(_controllers[index]),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Swipe left or right for more videos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controllers[_currentPageIndex].value.isPlaying) {
              _controllers[_currentPageIndex].pause();
            } else {
              _controllers[_currentPageIndex].play();
            }
          });
        },
        child: Icon(
          _controllers[_currentPageIndex].value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class SampleVideos extends StatelessWidget {
  final List<String> videoAssets = [
    'assets/videos/video1.mp4',
    'assets/videos/video2.mp4',
    'assets/videos/video3.mp4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Videos'),
      ),
      body: ListView.builder(
        itemCount: videoAssets.length,
        itemBuilder: (context, index) {
          return VideoWidget(videoPath: videoAssets[index]);
        },
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoPath;

  VideoWidget({required this.videoPath});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() {
    _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      aspectRatio: 16 / 9,
      allowFullScreen: false,
      showControls: false,
      placeholder: Container(
        color: Colors.black,
        child: Center(
          child: Icon(
            Icons.play_arrow,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_isPlaying) {
            _videoPlayerController.pause();
          } else {
            _videoPlayerController.play();
          }
          _isPlaying = !_isPlaying;
        });
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ),
            if (!_isPlaying)
              Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 50,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

 */


/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Videos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SampleVideos(),
    );
  }
}

class SampleVideos extends StatelessWidget {
  const SampleVideos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Videos'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/comingsoon.gif', // Replace with your actual GIF image path
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sample Videos Will Be Uploaded Soon!',
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

 */
