import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinstagram/models/user_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPostsProvider with ChangeNotifier {
  final firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  List<UserPostModel> _userPosts = [];

  List<UserPostModel> get userPosts {
    return [..._userPosts];
  }

  // upload post to database
  Future<void> addPost(UserPostModel userPostModel) async {
    try {
      await firestore
          .collection('posts/${user!.uid}/userposts/')
          .doc(userPostModel.id)
          .set(
            userPostModel.toJson(),
          );
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  // fetch posts with user's id
  Future<void> fetchAllPosts(String userId) async {
    try {
      List<UserPostModel> listOfPosts = [];
      await firestore.collection('posts/$userId/userposts/').get().then((data) {
        for (var i in data.docs) {
          listOfPosts.add(
            UserPostModel.fromJson(
              i.data(),
            ),
          );
        }
      });
      _userPosts = listOfPosts;
      notifyListeners();
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
