import 'package:dinstagram/presentation/pages/Chat/chats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Home/home_page.dart';
import '../UploadPost/select_image_page.dart';
import 'widgets/custom_popup_menubutton.dart';

class DashboardPage extends StatefulWidget {
  static const String routename = '/dashboard-page';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _pageController = PageController(
    initialPage: 0,
  );

  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if (index == 2) {
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite_outline,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(ChatsPage.routename);
                  },
                  icon: const Icon(
                    Icons.message_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      return Container();
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
        backgroundColor: Colors.black,
        body: Column(
          children: [
            conditionalAppBars(),
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
                  HomePage(
                    scrollController: _scrollController,
                  ),
                  const Page2(),
                  const Page3(),
                  const Page4(),
                  const Page4(),
                ],
              ),
            ),
          ],
        ),
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
                  const BottomNavigationBarItem(
                    icon: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                    ),
                    label: '',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.black,
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white,
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

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            Container(
              color: Colors.blue,
            ),
          ],
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
