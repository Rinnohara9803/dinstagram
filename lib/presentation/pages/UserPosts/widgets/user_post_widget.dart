import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../apis/chat_apis.dart';
import '../../../../models/chat_user.dart';
import '../../../../models/user_post.dart';
import '../../UploadPost/apply_filters_page.dart';

class UserPostWidget extends StatefulWidget {
  const UserPostWidget({
    super.key,
  });

  @override
  State<UserPostWidget> createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late AnimationController _animationController1;
  late Animation<double> _animation1;

  bool _showFavouriteIcon = false;

  final _pageController = PageController();

  int _currentPage = 1;
  bool showPageNumbers = true;

  @override
  void initState() {
    Future.delayed(
        const Duration(
          seconds: 5,
        ), () {
      setState(() {
        showPageNumbers = false;
      });
    });
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController1 = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation1 = Tween<double>(begin: 3, end: 4).animate(
      CurvedAnimation(
        parent: _animationController1,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final post = Provider.of<UserPostModel>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // user details
          StreamBuilder(
            stream: ChatApis.getUserInfoWithUserId(post.userId),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // image avatar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * .2),
                          child: CachedNetworkImage(
                            height: MediaQuery.of(context).size.height * 0.045,
                            width: MediaQuery.of(context).size.height * 0.045,
                            fit: BoxFit.cover,
                            imageUrl: list.isEmpty
                                ? 'no image'
                                : list[0].profileImage,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),

                        // username
                        Text(
                          list.isEmpty ? '' : list[0].userName,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.more_vert,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),

          // user-post images
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: post.images.length,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value + 1;
                      showPageNumbers = true;
                    });
                    Future.delayed(
                        const Duration(
                          seconds: 5,
                        ), () {
                      setState(() {
                        showPageNumbers = false;
                      });
                    });
                  },
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onDoubleTap: () async {
                        setState(() {
                          _showFavouriteIcon = true;
                        });
                        _animationController1
                            .forward()
                            .then((value) => _animationController1.reverse());
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        Future.delayed(const Duration(milliseconds: 800), () {
                          setState(() {
                            _showFavouriteIcon = false;
                          });
                        });
                        if (post.isLiked) {
                          return;
                        }
                        {
                          await post.toggleIsLiked();
                        }
                      },
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              ColorFiltered(
                                colorFilter: ColorFilters.colorFilterModels
                                    .firstWhere((element) =>
                                        element.filterName ==
                                        post.images[index].filterName)
                                    .colorFilter,
                                child: CachedNetworkImage(
                                  height: 400,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: post.images[index].imageUrl,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          const SizedBox(
                                    height: 400,
                                    width: double.infinity,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const SizedBox(
                                    height: 400,
                                    width: double.infinity,
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showFavouriteIcon)
                            Center(
                              child: AnimatedBuilder(
                                animation: _animationController1,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _animation1.value,
                                    child: Icon(
                                      post.isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
                if (post.images.length > 1)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: AnimatedOpacity(
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      opacity: showPageNumbers ? 1 : 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Text('$_currentPage/${post.images.length}')),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _animationController.forward().then((_) {
                          _animationController.reverse();
                        });
                        await post.toggleIsLiked();

                        // Toggle the liked state here
                        // You can update your state management accordingly
                      },
                      child: AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _animation.value,
                            child: Icon(
                              post.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: post.isLiked ? Colors.red : Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                        Icons.messenger_outline_sharp,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.bookmark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ColorFilters {
  static List<ColorFilterModel> colorFilterModels = [
    ColorFilterModel(
      filterName: 'normal',
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.dst,
      ),
    ),
    ColorFilterModel(
      filterName: 'grayscale',
      colorFilter: const ColorFilter.matrix(<double>[
        /// matrix
        0.2126, 0.7152,
        0.0722, 0, 0,
        0.2126, 0.7152,
        0.0722, 0, 0,
        0.2126, 0.7152,
        0.0722, 0, 0,
        0, 0, 0, 1, 0
      ]),
    ),
    ColorFilterModel(
      filterName: 'sepia',
      colorFilter: const ColorFilter.matrix(
        [
          /// matrix
          0.393, 0.769,
          0.189, 0, 0,
          0.349, 0.686,
          0.168, 0, 0,
          0.272, 0.534,
          0.131, 0, 0,
          0, 0, 0, 1, 0,
        ],
      ),
    ),
    ColorFilterModel(
      filterName: 'inverted',
      colorFilter: const ColorFilter.matrix(
        <double>[
          /// matrix
          -1, 0, 0, 0, 255,
          0, -1, 0, 0, 255,
          0, 0, -1, 0, 255,
          0, 0, 0, 1, 0,
        ],
      ),
    ),
    ColorFilterModel(
      filterName: 'colorBurn',
      colorFilter: const ColorFilter.mode(
        Colors.red,
        BlendMode.colorBurn,
      ),
    ),
    ColorFilterModel(
      filterName: 'difference',
      colorFilter: const ColorFilter.mode(
        Colors.blue,
        BlendMode.difference,
      ),
    ),
    ColorFilterModel(
      filterName: 'saturation',
      colorFilter: const ColorFilter.mode(
        Colors.red,
        BlendMode.saturation,
      ),
    ),
  ];
}
