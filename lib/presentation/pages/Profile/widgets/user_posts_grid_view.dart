import 'package:cached_network_image/cached_network_image.dart';
import 'package:dinstagram/models/chat_user.dart';
import 'package:dinstagram/presentation/pages/UserPosts/user_posts_page.dart';
import 'package:dinstagram/presentation/pages/UserPosts/widgets/user_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/user_posts_provider.dart';

class UserPostsGridView extends StatefulWidget {
  final ChatUser chatUser;
  final ScrollController scrollController;
  const UserPostsGridView(
      {super.key, required this.chatUser, required this.scrollController});

  @override
  State<UserPostsGridView> createState() => _UserPostsGridViewState();
}

class _UserPostsGridViewState extends State<UserPostsGridView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<UserPostsProvider>(context, listen: false)
          .fetchAllPosts(widget.chatUser.userId),
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
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  controller: widget.scrollController,
                  itemCount: postData.userPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserPostsPage(
                              postIndex: index,
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Stack(
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilters.colorFilterModels
                                .firstWhere((element) =>
                                    element.filterName ==
                                    postData
                                        .userPosts[index].images[0].filterName)
                                .colorFilter,
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: double.infinity,
                              imageUrl:
                                  postData.userPosts[index].images[0].imageUrl,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      const Center(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(
                                  Icons.error,
                                ),
                              ),
                            ),
                          ),
                          if (postData.userPosts[index].images.length != 1)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Icon(
                                Icons.copy,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
            });
        }
      },
    );
  }
}
