import 'package:dinstagram/presentation/pages/Dashboard/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../apis/chat_apis.dart';

class InitialPage extends StatefulWidget {
  static const String routename = '/initial-page';
  const InitialPage({super.key});

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
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
    const DashboardPage(),
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

  @override
  void initState() {
    ChatApis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (ChatApis.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          ChatApis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          ChatApis.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          initialIndex: 1,
          length: pages.length,
          child: Scaffold(
            body: TabBarView(
              children: pages,
            ),
          ),
        ),
      ),
    );
  }
}
