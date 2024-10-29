import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:onboarding_app/presentation/guide/guide.dart';
import 'package:onboarding_app/presentation/guide/guidepage2/guidepage2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../network/models/uservideos_model.dart';
import '../../routes/app_pages.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Your Videos',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                setState(() {
                  _controller.getUserVideos();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return Guide();
                }));
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("Navigating back to DashboardScreen...");
            try {
              Get.offAllNamed(Routes.DASHBOARD);
            } catch (e) {
              print("Error navigating: $e");
              // Fallback navigation
              Get.offAllNamed(Routes.DASHBOARD);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              if (_controller.videosList?.isEmpty ?? true) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => guidepage2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: Text(
                      'Start Recording',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              } else {
                return _buildVideoList();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;
          print("rating : $ratingValue");
          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                  alignment: Alignment.center,
                  children: [
                    // Your actual video thumbnail
                    /*ClipRRect(
                      borderRadius: BorderRadius.circular(24.00),
                      child: CachedNetworkImage(
                        imageUrl: _controller.videosList![index].thumbnailImage.toString(),
                        fit: BoxFit.cover, // Ensure the image fills the container
                        height: 180.00,
                        width: 327.00,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),

                     */
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.00),
                      child: CachedNetworkImage(
                        imageUrl: _controller.videosList![index].thumbnailImage
                            .toString(),
                        fit: BoxFit.cover,
                        // Ensure the image fills the container
                        height: 180.00,
                        width: double.infinity,
                        placeholder: (context, url) => SizedBox(
                          width: 180.00, // Set the width of the SizedBox
                          height: 327.00, // Set the height of the SizedBox
                          child: Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              // Adjust the stroke width if needed
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey), // Adjust the color if needed
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
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
                        width: 60, // Set width of the play button container
                        height: 60, // Set height of the play button container
                        child: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerScreen(
                                  video: _controller.videosList![index],
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 36, // Adjust size of the play button icon
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                if (ratingValue == null ||
                                    ratingValue == 0.0 ||
                                    ratingValue <= 0)
                                  Text(
                                    'Ratings Will Be Updated Soon',
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 14,
                                    ),
                                  )
                                else
                                  for (int i = 0; i < 5; i++)
                                    Icon(
                                      i < fullStars
                                          ? Icons.star
                                          : i == fullStars &&
                                                  fractionalPart >= 0.5
                                              ? Icons.star_half
                                              : Icons.star_border,
                                      color: Colors.yellow,
                                      size: 18,
                                    ),
                                Spacer(),
                                Container(
                                    child: Text(_controller
                                            .videosList![index]!.length
                                            .toString() +
                                        " Secs")),
                                //),
                              ],
                            ),
                            // else
                            //   Text(
                            //     'Ratings Will Be Updated Soon',
                            //     style: TextStyle(
                            //       color: Colors.yellow,
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            const SizedBox(height: 6),
                            // Display title in multiple lines if too long
                            Text(
                              _controller.videosList![index].title.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2, // Maximum 2 lines
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

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
    // _videoPlayerController =
    //   VideoPlayerController.network(widget.video.video.toString());
    //  await _videoPlayerController.initialize();
    _videoPlayerController =
        VideoPlayerController.network(widget.video.video.toString())
          ..initialize().then((_) {
            setState(() {
              _isVideoLoading = true;
            });
          })
          ..addListener(() {
            if (_videoPlayerController.value.position ==
                _videoPlayerController.value.duration) {
              setState(() {
                _isVideoLoading = false;
              });
            }
          });
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

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.video.title ?? 'Video Title';
    int maxLines =
        (title.length / 20).ceil(); // Adjust based on your preference

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: maxLines,
            textAlign: TextAlign.start, // Align text to the start (left)
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          leading: BackButton(),
          backgroundColor: Colors.white, // Set your desired app bar color
          centerTitle: false, // Align the title to start (left)
        ),
        body: Center(
          /*  child: _isVideoLoading
              ? CircularProgressIndicator()
              : Chewie(
                  controller: _chewieController,
                ),*/
          child: _videoPlayerController.value.isInitialized
              ? Chewie(
                  controller: _chewieController,
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:onboarding_app/presentation/guide/guide.dart';
import 'package:onboarding_app/presentation/guide/guidepage/guidepage.dart';
import 'package:onboarding_app/presentation/guide/guidepage2/guidepage2.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';
import '../guide/guidepage/guidepage.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Your Videos',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                setState(() {
                  _controller.getUserVideos();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.black),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Guide();
                }));
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print("Navigating back to DashboardScreen...");
            try {
              Get.offAll(DashboardScreen());
            } catch (e) {
              print("Error navigating: $e");
              // Fallback navigation
              Get.off(DashboardScreen());
            }
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              if (_controller.videosList?.isEmpty ?? true) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => guidepage2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                    ),
                    child: Text(
                      'Start Recording',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              } else {
                return _buildVideoList();
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

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
        VideoPlayerController.network(widget.video.video.toString());
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

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.video.title ?? 'Video Title';
    int maxLines = (title.length / 20)
        .ceil(); // Adjust based on your preference

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            maxLines: maxLines,
            textAlign: TextAlign.start, // Align text to the start (left)
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          leading: BackButton(),
          backgroundColor: Colors.white, // Set your desired app bar color
          centerTitle: false, // Align the title to start (left)
        ),
        body: Center(
          child: _isVideoLoading
              ? CircularProgressIndicator()
              : Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
  class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Videos',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold, // Making the text bold
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
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

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
        VideoPlayerController.network(widget.video.video.toString());
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

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
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
                        widget.video.title ?? 'Video Title',
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
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}


 */
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Videos',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.bold, // Making the text bold
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
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

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
        VideoPlayerController.network(widget.video.video.toString());
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

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
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
                      widget.video.title ?? 'Video Title',
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

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}


 */

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

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
                      widget.video.title ?? 'Video Title',
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
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
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
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
          SliverAppBar(
          expandedHeight: 60.0, // Adjust as needed
          flexibleSpace: FlexibleSpaceBar(
          centerTitle: true, // Center the title
          title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
          widget.video.title ?? 'Video Title',
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
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Marquee(
          child: Text(widget.video.title ?? 'Video Title'),
          scrollAxis: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          velocity: 100.0,
          pauseAfterRound: const Duration(seconds: 1),
          blankSpace: 20.0,
          startPadding: 10.0,
          accelerationDuration: const Duration(seconds: 1),
          decelerationDuration: const Duration(milliseconds: 500),
          accelerationCurve: Curves.linear,
          decelerationCurve: Curves.easeOut,
        ),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
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
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title ?? 'Video Title'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow: TextOverflow.clip, // Ensure continuous scrolling
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 30.0, // Adjust velocity
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Marquee(
          child: Text(widget.video.title ?? 'Video Title'),
        ),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
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
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;

          int fullStars = ratingValue.floor();
          double fractionalPart = ratingValue - fullStars;

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i < fullStars
                                                          ? Icons.star
                                                          : i == fullStars && fractionalPart >= 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title ?? 'Video Title'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
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
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          double ratingValue = _controller.videosList?[index].rating != null
              ? double.parse(_controller.videosList![index].rating!) / 2
              : 0;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (ratingValue != null && ratingValue > 0)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i + 0.5 < ratingValue
                                                          ? Icons.star
                                                          : i + 0.5 - ratingValue < 0.5
                                                          ? Icons.star_half
                                                          : Icons.star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title ?? 'Video Title'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

 */

/*import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:onboarding_app/controllers/yourVideosController/your_videos-controller.dart';
import 'package:video_player/video_player.dart';
import 'package:shimmer/shimmer.dart';
import '../../network/models/uservideos_model.dart';
import '../dashboard/dashboard_screen.dart';

class Video {
  late final String title;
  late final String thumbnailUrl;
  late final String videoUrl;
  late final String rating;

  Video({
    required this.title,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.rating,
  });
}

class YourVideos extends StatefulWidget {
  YourVideos({Key? key});

  @override
  _YourVideosState createState() => _YourVideosState();
}

class _YourVideosState extends State<YourVideos> {
  final YourVideosController _controller = Get.put(YourVideosController());

  @override
  void initState() {
    super.initState();
    _controller.getUserVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Videos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAll(DashboardScreen());
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: FutureBuilder(
          future: _controller.getUserVideos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading();
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading videos'));
            } else {
              return _buildVideoList();
            }
          },
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5, // Number of shimmer loading items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, right: 22, left: 22),
            child: Container(
              height: 180.00,
              width: 327.00,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.00),
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoList() {
    return RefreshIndicator(
      onRefresh: () async {
        await _controller.getUserVideos();
        setState(() {});
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.videosList?.length ?? 0,
        itemBuilder: (context, index) {
          String rating = _controller.videosList?[index].rating ?? '';

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    video: _controller.videosList![index],
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
                    // Shimmer loading for video thumbnail
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.00),
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Your actual video thumbnail
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.00),
                        child: _controller.videosList?[index].thumbnailImage == null
                            ? const CircularProgressIndicator()
                            : Image.network(
                          _controller.videosList![index].thumbnailImage.toString(),
                          fit: BoxFit.fill,
                          height: 180.00,
                          width: 390.00,
                        ),
                      ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 26),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                          video: _controller.videosList![index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 18, top: 26, bottom: 16),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            if (rating != null &&
                                                rating.isNotEmpty)
                                              Row(
                                                children: [
                                                  for (int i = 0; i < 5; i++)
                                                    Icon(
                                                      i + 0.5 <
                                                          double.parse(rating)
                                                          ? Icons.star
                                                          : i + 0.5 -
                                                          double.parse(
                                                              rating) <
                                                          0.5
                                                          ? Icons.star_half
                                                          : Icons
                                                          .star_border,
                                                      color: Colors.yellow,
                                                      size: 18,
                                                    ),
                                                ],
                                              )
                                            else
                                              Text(
                                                'Ratings Will Be Updated Soon',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                            Marquee(
                                              child: Text(
                                                _controller.videosList![index]
                                                    .title
                                                    .toString(),
                                                softWrap: true,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              scrollAxis: Axis.horizontal,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              blankSpace: 20.0,
                                              velocity: 100.0,
                                              pauseAfterRound:
                                              const Duration(seconds: 1),
                                              startPadding: 10.0,
                                              accelerationDuration:
                                              const Duration(seconds: 1),
                                              accelerationCurve:
                                              Curves.linear,
                                              decelerationDuration:
                                              const Duration(
                                                  milliseconds: 500),
                                              decelerationCurve:
                                              Curves.easeOut,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Handle more options tap
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final ListData video;

  VideoPlayerScreen({required this.video});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
    VideoPlayerController.network(widget.video.video.toString())
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      autoPlay: true,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  double _calculateAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return screenWidth / screenHeight;
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoInitialize: true,
      aspectRatio: _calculateAspectRatio(context),
      autoPlay: true,
      looping: false,
      showControls: true,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.title ?? 'Video Title'),
      ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class Marquee extends StatelessWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  Marquee({
    required this.child,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.velocity = 100.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.blankSpace = 20.0,
    this.startPadding = 0.0,
    this.accelerationDuration = const Duration(seconds: 1),
    this.decelerationDuration = const Duration(milliseconds: 500),
    this.accelerationCurve = Curves.linear,
    this.decelerationCurve = Curves.easeOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: scrollAxis,
      physics: const BouncingScrollPhysics(),
      child: _MarqueeContent(
        child: child,
        scrollAxis: scrollAxis,
        crossAxisAlignment: crossAxisAlignment,
        velocity: velocity,
        pauseAfterRound: pauseAfterRound,
        blankSpace: blankSpace,
        startPadding: startPadding,
        accelerationDuration: accelerationDuration,
        decelerationDuration: decelerationDuration,
        accelerationCurve: accelerationCurve,
        decelerationCurve: decelerationCurve,
      ),
    );
  }
}

class _MarqueeContent extends StatefulWidget {
  final Widget child;
  final Axis scrollAxis;
  final CrossAxisAlignment crossAxisAlignment;
  final double velocity;
  final Duration pauseAfterRound;
  final double blankSpace;
  final double startPadding;
  final Duration accelerationDuration;
  final Duration decelerationDuration;
  final Curve accelerationCurve;
  final Curve decelerationCurve;

  const _MarqueeContent({
    required this.child,
    required this.scrollAxis,
    required this.crossAxisAlignment,
    required this.velocity,
    required this.pauseAfterRound,
    required this.blankSpace,
    required this.startPadding,
    required this.accelerationDuration,
    required this.decelerationDuration,
    required this.accelerationCurve,
    required this.decelerationCurve,
  });

  @override
  _MarqueeContentState createState() => _MarqueeContentState();
}

class _MarqueeContentState extends State<_MarqueeContent>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.accelerationDuration +
          widget.pauseAfterRound +
          widget.decelerationDuration,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.jumpTo(widget.startPadding);
        _animationController.reset();
        _animationController.forward();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.scrollAxis,
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      child: Container(
        child: Row(
          crossAxisAlignment: widget.crossAxisAlignment,
          children: [
            SizedBox(width: widget.startPadding),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    -_animationController.value * widget.blankSpace,
                    0.0,
                  ),
                  child: child,
                );
              },
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
 */
