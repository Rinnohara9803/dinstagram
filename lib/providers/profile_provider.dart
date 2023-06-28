import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  Future<void> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then(
        (data) {
          // print(data['email']);
        },
      );
    } catch (e) {
      return Future.error(
        e.toString(),
      );
    }
  }
}
