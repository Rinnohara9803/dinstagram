import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  const HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<VideoStory> videoStories = [
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'john_doesdfsdfsdsdsf',
      avatarUrl:
          'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'jane_smith',
      avatarUrl:
          'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'john_doe',
      avatarUrl:
          'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'jane_smith',
      avatarUrl:
          'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'john_doe',
      avatarUrl:
          'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'jane_smith',
      avatarUrl:
          'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'john_doe',
      avatarUrl:
          'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
    ),
    VideoStory(
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      username: 'jane_smith',
      avatarUrl:
          'https://static.wikia.nocookie.net/naruto/images/d/d6/Naruto_Part_I.png/revision/latest/scale-to-width-down/1200?cb=20210223094656',
    ),
    // Add more video stories as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        controller: widget.scrollController,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            height: 110,
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 7,
                    ),
                    child: SizedBox(
                      height: 115,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  'https://c4.wallpaperflare.com/wallpaper/127/164/7/kid-luffy-monkey-d-luffy-one-piece-anime-hd-wallpaper-preview.jpg',
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Your story',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 34,
                            right: -2,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                                child: Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ...videoStories
                      .map((videoStory) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Container(
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StoryPlayerScreen(
                                            videoStory: videoStory,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 71,
                                      width: 71,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.amber,
                                            Colors.red,
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: CircleAvatar(
                                          radius: 34,
                                          backgroundColor: Colors.black,
                                          child: CircleAvatar(
                                            radius: 31,
                                            backgroundImage: NetworkImage(
                                              videoStory.avatarUrl,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    videoStory.username,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Container(
                                  //   width: 100,
                                  //   height: 180,
                                  //   child: VideoStoryWidget(
                                  //     videoStory: videoStories[index],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ))
                      .toList()
                ],
              ),
            ),
          ),
          Container(
            height: 400,
            color: Colors.red,
          ),
          Container(
            height: 400,
            color: Colors.blue,
          ),
          Container(
            height: 400,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class StoryPlayerScreen extends StatefulWidget {
  final VideoStory videoStory;

  const StoryPlayerScreen({super.key, required this.videoStory});

  @override
  State<StoryPlayerScreen> createState() => StoryPlayerScreenState();
}

class StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoStory.videoUrl);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.addListener(_onProgressChanged);
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onProgressChanged() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;

    setState(() {
      _progressValue = position.inMilliseconds / duration.inMilliseconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressValue,
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    },
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class VideoStory {
  final String videoUrl;
  final String username;
  final String avatarUrl;

  VideoStory({
    required this.videoUrl,
    required this.username,
    required this.avatarUrl,
  });
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<File> _photos = [];

  // @override
  // void initState() {
  //   _pickPhotos();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _photos.length,
        itemBuilder: (context, index) {
          return Image.file(_photos[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPhotos,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickPhotos() async {
    final List<XFile>? pickedPhotos = await ImagePicker().pickMultiImage();

    if (pickedPhotos != null) {
      setState(() {
        _photos =
            pickedPhotos.map((pickedPhoto) => File(pickedPhoto.path)).toList();
      });
    }
  }
}
