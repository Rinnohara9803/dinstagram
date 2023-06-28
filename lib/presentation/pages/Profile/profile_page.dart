import 'package:dinstagram/providers/followings_followers_provider.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import '../../../apis/chat_apis.dart';
import '../../../apis/user_apis.dart';
import '../../../models/chat_user.dart';
import '../../../services/sound_recorder.dart';
import '../Chat/chat_page.dart';
import '../Chat/chats_page.dart';
import '../Dashboard/widgets/custom_popup_menubutton.dart';

class ProfilePage extends StatefulWidget {
  final ChatUser chatUser;

  const ProfilePage({super.key, required this.chatUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Widget> pages = [
    Container(
      color: Colors.red,
      child: const Center(
        child: Text(
          'Page 1',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    ),
    Container(
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Page 3',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    ),
  ];
  late bool haveFollowed;
  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: pages.length,
        child: Scaffold(
          body: Column(
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Dinstagram',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(),
                        ),
                        const CustomPopUpMenuButton(),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_outline,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ChatsPage.routename);
                          },
                          icon: const Icon(
                            Icons.message_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: ChatApis.getUserInfo(widget.chatUser),
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
                        List<ChatUser> users = [];
                        if (snapshot.hasData) {
                          for (var i in snapshot.data!.docs) {
                            users.add(ChatUser.fromJson(i.data()));
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          NetworkImage(users[0].profileImage),
                                    ),
                                  ),
                                  const profileDataWidget(
                                    data: 0,
                                    label: 'Posts',
                                  ),
                                  FutureBuilder(
                                    future:
                                        Provider.of<FollowingFollowersProvider>(
                                      context,
                                      listen: false,
                                    ).getFollowers(widget.chatUser.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const profileDataWidget(
                                          data: 0,
                                          label: 'Followers',
                                        );
                                      }

                                      return Consumer<
                                              FollowingFollowersProvider>(
                                          builder: (context, ffpData, child) {
                                        return profileDataWidget(
                                          data: ffpData.followers,
                                          label: 'Followers',
                                        );
                                      });
                                    },
                                  ),
                                  FutureBuilder(
                                    future:
                                        Provider.of<FollowingFollowersProvider>(
                                      context,
                                      listen: false,
                                    ).getFollowings(widget.chatUser.userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const profileDataWidget(
                                          data: 0,
                                          label: 'Followings',
                                        );
                                      }

                                      return Consumer<
                                              FollowingFollowersProvider>(
                                          builder: (context, ffpData, child) {
                                        return profileDataWidget(
                                          data: ffpData.followings,
                                          label: 'Followings',
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                users[0].email,
                              ),
                              const Text(
                                'Oh, well whatever happens happens.',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (widget.chatUser.userId == UserApis.user!.uid)
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          color:
                                              Color.fromARGB(255, 38, 38, 39),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text('Edit Profile'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (widget.chatUser.userId != UserApis.user!.uid)
                                StreamBuilder(
                                  stream: UserApis.getAllFollowings(
                                      UserApis.user!.uid),
                                  builder: (context, snapshot) {
                                    final data = snapshot.data?.docs;
                                    list = [];
                                    if (snapshot.hasData) {
                                      for (var i in data!) {
                                        list.add(i.data()['userId']);
                                      }
                                    }

                                    if (list.isNotEmpty) {
                                      haveFollowed =
                                          list.contains(widget.chatUser.userId);
                                    } else {
                                      haveFollowed = false;
                                    }

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              if (!haveFollowed) {
                                                Provider.of<
                                                    FollowingFollowersProvider>(
                                                  context,
                                                  listen: false,
                                                ).follow(widget.chatUser);
                                              } else {
                                                Provider.of<FollowingFollowersProvider>(
                                                        context,
                                                        listen: false)
                                                    .unfollow(widget.chatUser);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  !haveFollowed
                                                      ? 'Follow'
                                                      : 'Unfollow',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: !haveFollowed
                                              ? const SizedBox()
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChangeNotifierProvider<
                                                                    AudioProvider>(
                                                                create: (context) =>
                                                                    AudioProvider(),
                                                                child: ChatPage(
                                                                    user: widget
                                                                        .chatUser)),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 48, 47, 47),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        10,
                                                      ),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'Message',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const TabBar(
                                      indicatorColor: Colors.white,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      indicatorWeight: 2,
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      labelColor: Colors.white,
                                      unselectedLabelColor: Colors.grey,
                                      tabs: [
                                        Tab(
                                          icon: Icon(
                                            Icons.grid_on_sharp,
                                          ),
                                        ),
                                        Tab(
                                          icon: Icon(
                                            Icons.video_library_outlined,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: pages,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class profileDataWidget extends StatelessWidget {
  final int data;
  final String label;
  const profileDataWidget({
    super.key,
    required this.data,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        children: [
          Text(data.toString()),
          Text(label),
        ],
      ),
    );
  }
}
