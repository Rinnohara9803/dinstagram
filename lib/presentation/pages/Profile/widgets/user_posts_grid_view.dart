import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinstagram/models/chat_user.dart';
import 'package:dinstagram/models/user_post.dart';
import 'package:dinstagram/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../providers/user_posts_provider.dart';
import '../../../../utilities/color_filters.dart';

class UserPostsGridView extends StatefulWidget {
  final ChatUser chatUser;
  final ScrollController scrollController;
  const UserPostsGridView(
      {super.key, required this.chatUser, required this.scrollController});

  @override
  State<UserPostsGridView> createState() => _UserPostsGridViewState();
}

class _UserPostsGridViewState extends State<UserPostsGridView> {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  int currentLimit = 12;

  void _onRefresh() async {
    if (currentLimit >
        Provider.of<UserPostsProvider>(
          context,
          listen: false,
        ).allUserPosts.length) {
      _refreshController.loadComplete();
      return;
    }
    print('refreshing');
    currentLimit = currentLimit + 12;
    await Provider.of<UserPostsProvider>(context, listen: false)
        .fetchAllPostsOfUserWithLimit(widget.chatUser.userId, currentLimit)
        .then((value) {
      _refreshController.loadComplete();
    }).catchError((e) {
      _refreshController.loadFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserPostsProvider>(context, listen: false)
          .fetchAllPostsOfUserWithLimit(widget.chatUser.userId, currentLimit),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            return Consumer<UserPostsProvider>(
                builder: (context, postData, child) {
              if (postData.userPosts.isEmpty) {
                return const Center(
                  child: Text(
                    'No posts till date',
                  ),
                );
              } else {
                return SmartRefresher(
                  enablePullUp: true,
                  enablePullDown: false,
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onRefresh,
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = const SizedBox();
                      } else if (mode == LoadStatus.loading) {
                        body = const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      } else if (mode == LoadStatus.failed) {
                        body = const Text("Load Failed!");
                      } else {
                        body = const SizedBox();
                      }
                      return SizedBox(
                        height: 55.0,
                        child: Center(
                          child: body,
                        ),
                      );
                    },
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    controller: widget.scrollController,
                    itemCount: postData.userPosts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: postData.userPosts[index],
                        child: const UserPostGridViewWidget(),
                      );
                    },
                  ),
                );
              }
            });
        }
      },
    );
  }
}

class UserPostGridViewWidget extends StatefulWidget {
  const UserPostGridViewWidget({super.key});

  @override
  State<UserPostGridViewWidget> createState() => UserPostGridViewWidgetState();
}

class UserPostGridViewWidgetState extends State<UserPostGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    final post = Provider.of<UserPostModel>(context);
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserPostsPage(
                postIndex: Provider.of<UserPostsProvider>(context)
                    .userPosts
                    .indexOf(post),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilters.colorFilterModels
                  .firstWhere((element) =>
                      element.filterName == post.images[0].filterName)
                  .colorFilter,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: double.infinity,
                height: constraints.maxHeight,
                imageUrl: post.images[0].imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  child: const Center(
                    child: Icon(
                      Icons.error,
                    ),
                  ),
                ),
              ),
            ),
            if (post.images.length != 1)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Icons.copy,
                ),
              ),
          ],
        ),
      );
    });
  }
}
