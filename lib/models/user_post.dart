import 'package:dinstagram/apis/user_apis.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class UserPostModel with ChangeNotifier {
  UserPostModel({
    required this.images,
    required this.latitude,
    required this.caption,
    required this.id,
    required this.longitude,
    required this.likes,
    required this.userId,
    this.isLiked = false,
  });
  late final List<Images> images;
  late final double latitude;
  late final String caption;
  late final String id;
  late final double longitude;
  late final List<Likes> likes;
  late final String userId;
  late bool isLiked;

  Future<void> toggleIsLiked() async {
    if (!isLiked) {
      print('not liked');
      isLiked = true;
      notifyListeners();

      likes.add(Likes(userId: UserApis.user!.uid));
      await UserApis.firestore
          .collection('posts/$userId/userposts/')
          .doc(id)
          .update({
            'likes': likes.map((e) => e.toJson()).toList(),
          })
          .then((value) {})
          .catchError((e) {
            isLiked = false;
            notifyListeners();
          });
    } else {
      print('liked');
      isLiked = false;
      notifyListeners();
      likes.removeWhere((element) => element.userId == UserApis.user!.uid);
      await UserApis.firestore
          .collection('posts/$userId/userposts/')
          .doc(id)
          .update(
            {
              'likes': likes.map((e) => e.toJson()).toList(),
            },
          )
          .then((value) {})
          .catchError(
            (e) {
              isLiked = true;
              notifyListeners();
            },
          );
    }
  }

  UserPostModel.fromJson(Map<String, dynamic> json) {
    images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
    latitude = json['latitude'];
    caption = json['caption'];
    id = json['id'];
    longitude = json['longitude'];
    likes = List.from(json['likes']).map((e) => Likes.fromJson(e)).toList();
    userId = json['userId'];
    isLiked = likes.firstWhereOrNull(
            (element) => element.userId == UserApis.user!.uid) !=
        null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images.map((e) => e.toJson()).toList();
    data['latitude'] = latitude;
    data['caption'] = caption;
    data['id'] = id;
    data['longitude'] = longitude;
    data['likes'] = likes.map((e) => e.toJson()).toList();
    data['userId'] = userId;
    return data;
  }
}

class Images {
  Images({
    required this.imageUrl,
    required this.filterName,
  });
  late final String imageUrl;
  late final String filterName;

  Images.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    filterName = json['filterName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['filterName'] = filterName;
    return data;
  }
}

class Likes {
  Likes({
    required this.userId,
  });
  late final String userId;

  Likes.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    return data;
  }
}
