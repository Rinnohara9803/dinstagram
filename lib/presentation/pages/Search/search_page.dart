import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinstagram/models/chat_user.dart';
import 'package:dinstagram/presentation/pages/Search/widgets/search_chat_user_card.dart';
import 'package:dinstagram/presentation/resources/themes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final Function returnToHomePage;
  const SearchPage({super.key, required this.returnToHomePage});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isVisible = true;
  late ScrollController _scrollController;

  List<ChatUser> searchResults = [];

  final _searchController = TextEditingController();

  Future<void> searchUsers(String searchTerm) async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isGreaterThanOrEqualTo: searchTerm)
        .where('userName', isLessThanOrEqualTo: '$searchTerm\uf8ff')
        .get()
        .then((snapshot) {
      setState(() {
        searchResults = [];
      });
      for (var i in snapshot.docs) {
        setState(() {
          searchResults.add(ChatUser.fromJson(i.data()));
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
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

  Widget searchBar() {
    return AnimatedContainer(
      height: _isVisible ? 60 : 0,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      duration: const Duration(
        milliseconds: 200,
      ),
      child: TextField(
        controller: _searchController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.bottom,
        cursorColor: Provider.of<ThemeProvider>(context).isLightTheme
            ? Colors.black
            : Colors.white,
        style: const TextStyle(
          fontSize: 12,
        ),
        cursorHeight: 13,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: const TextStyle(
            fontSize: 12,
          ),
          isDense: true,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
        ),
        onChanged: (value) async {
          await searchUsers(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.returnToHomePage();
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              searchBar(),
              Expanded(
                child: _searchController.text.isEmpty
                    ? const Center(
                        child: Text('fetch previous search results'),
                      )
                    : FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              if (searchResults.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No users found',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                              return SearchChatUserCard(
                                chatUser: searchResults[index],
                              );
                            },
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
