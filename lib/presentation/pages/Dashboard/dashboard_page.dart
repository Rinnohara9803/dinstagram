import 'package:dinstagram/apis/chat_apis.dart';
import 'package:dinstagram/presentation/pages/Chat/chats_page.dart';
import 'package:dinstagram/presentation/pages/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../apis/user_apis.dart';
import '../../../models/chat_user.dart';
import 'package:collection/collection.dart';
import '../../../services/auth_service.dart';
import '../Home/home_page.dart';
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

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.of(context).pushNamed(LoginPage.routename);
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
                  Page2(),
                  Page3(),
                  Page4(),
                  Page4(),
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

class LongPressButton extends StatefulWidget {
  @override
  _LongPressButtonState createState() => _LongPressButtonState();
}

class _LongPressButtonState extends State<LongPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool isLongPress = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startFadeAnimation() {
    _animationController.forward();
  }

  void _resetFadeAnimation() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isLongPress = true;
        });
        _startFadeAnimation();
      },
      // onLongPressEnd: (_) {
      //   setState(() {
      //     isLongPress = false;
      //   });
      //   _animationController.reset();
      // },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 200,
            height: 50,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Long Press Me',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (isLongPress) _buildTopPopup(),
          if (isLongPress) _buildBottomPopup(),
        ],
      ),
    );
  }

  Widget _buildTopPopup() {
    return Positioned(
      top: -100,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 50,
          color: Colors.yellow,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.thumb_up),
              SizedBox(width: 10),
              Icon(Icons.thumb_down),
              SizedBox(width: 10),
              Icon(Icons.favorite),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPopup() {
    return Positioned(
      bottom: -100,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: 100,
          color: Colors.orange,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  print('Unsend');
                },
                child: Text('Unsend'),
              ),
              ElevatedButton(
                onPressed: () {
                  print('Delete');
                },
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
