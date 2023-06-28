import 'package:dinstagram/apis/chat_apis.dart';
import 'package:flutter/material.dart';

import '../../../models/chat_user.dart';
import 'widgets/chat_user_card.dart';

class ChatsPage extends StatefulWidget {
  static const String routename = '/chats-page';
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  List<ChatUser> users = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            ChatApis.user!.email as String,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
        ),
        body: StreamBuilder(
          stream: ChatApis.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasData) {
                  users = [];
                  for (var i in snapshot.data!.docs) {
                    print(ChatApis.user!.uid);
                    print(ChatUser.fromJson(i.data()).userId +
                        ' ' +
                        ChatUser.fromJson(i.data()).userName);
                    users.add(ChatUser.fromJson(i.data()));
                  }
                }
                if (users.isEmpty) {
                  return Center(
                    child: Text('No users found.'),
                  );
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                      chatUser: users[index],
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
