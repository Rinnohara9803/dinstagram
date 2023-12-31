import 'package:dinstagram/presentation/pages/Chat/chats_page.dart';
import 'package:dinstagram/presentation/pages/Profile/profile_page.dart';
import 'package:dinstagram/presentation/resources/themes_manager.dart';
import 'package:dinstagram/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../Home/home_page.dart';
import '../Search/search_page.dart';
import '../UploadPost/select_image_page.dart';
import 'widgets/custom_popup_menubutton.dart';

class DashboardPage extends StatefulWidget {
  static const String routename = '/dashboard-page';
  final Function navigateToChatsPage;
  const DashboardPage({super.key, required this.navigateToChatsPage});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _pageController = PageController(
    initialPage: 0,
  );

  int _selectedIndex = 0;

  // returns currently running page-view to home page
  void _returnToHomePage() {
    setState(() {
      _selectedIndex = 0;
      _pageController.jumpToPage(_selectedIndex);
    });
  }

  // navigate to select image page
  void _onItemTapped(int index) async {
    if (index == 2) {
      // get read-external-storage permission
      var permission = await Permission.storage.request();
      if (permission == PermissionStatus.granted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(SelectImagePage.routename);
      } else {
        throw 'Photos access denied.';
      }
    } else {
      setState(() {
        _selectedIndex = index;
        _pageController.jumpToPage(_selectedIndex);
      });
    }
  }

  bool _isVisible = true;
  late ScrollController _scrollController;

  // conditional app bars for different page views
  Widget conditionalAppBars() {
    if (_selectedIndex == 0) {
      return AnimatedContainer(
        height: _isVisible ? 60 : 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        duration: const Duration(
          milliseconds: 200,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Dinstagram',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                ),
                const CustomPopUpMenuButton(),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.favorite_outline,
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    widget.navigateToChatsPage();
                  },
                  child: const Icon(
                    Icons.message_outlined,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // handle scrollings to hide and show appbar/bottom-nav-bar
  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isVisible = true;
      });
    } else {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            conditionalAppBars(),

            // page view of 5 pages namely: home,search,add-post,reels and profile
            Expanded(
              child: PageView(
                scrollBehavior: null,
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                children: [
                  // home page
                  HomePage(
                    scrollController: _scrollController,
                  ),

                  // search-users page
                  SearchPage(
                    returnToHomePage: _returnToHomePage,
                  ),

                  // add post page - dummy
                  const SizedBox(),

                  // reels page
                  const Page4(),

                  // profile page
                  ProfilePage(
                    chatUser: Provider.of<ProfileProvider>(context).chatUser,
                    navigateBack: _returnToHomePage,
                  ),
                ],
              ),
            ),
          ],
        ),

        // primary bottom-nav-bar for dashboard
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isVisible ? 60 : 0,
          child: Wrap(
            children: [
              BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 0
                        ? const Icon(Icons.home)
                        : const Icon(Icons.home_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 1
                        ? const Icon(Icons.search_rounded)
                        : const Icon(Icons.search_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 2
                        ? const Icon(Icons.add_box)
                        : const Icon(Icons.add_box_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: _selectedIndex == 3
                        ? const Icon(Icons.movie_creation_rounded)
                        : const Icon(Icons.movie_creation_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: CircleAvatar(
                      backgroundColor:
                          Provider.of<ThemeProvider>(context).isLightTheme
                              ? Colors.black
                              : Colors.white,
                      radius: _selectedIndex == 4 ? 14 : 12,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          Provider.of<ProfileProvider>(context)
                              .chatUser
                              .profileImage,
                        ),
                        child: Provider.of<ProfileProvider>(context)
                                .chatUser
                                .profileImage
                                .isNotEmpty
                            ? null
                            : const Icon(Icons.person),
                      ),
                    ),
                    label: '',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                iconSize: 25,
                onTap: _onItemTapped,
                elevation: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.purple,
      ),
    );
  }
}

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
      ),
    );
  }
}
