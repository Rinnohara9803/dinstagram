import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinstagram/models/chat_message.dart';
import 'package:dinstagram/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatApis {
  // auth instance
  static FirebaseAuth auth = FirebaseAuth.instance;

  // firestore instance
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // storage instance
  static FirebaseStorage storage = FirebaseStorage.instance;

  // current authenticated user
  static final user = auth.currentUser;

  // all-users snapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('userId', isNotEqualTo: user!.uid)
        .snapshots();
  }

  // followings snapshot

  // get a unique conversation id between two chat-users
  static String getConversationId(String id) =>
      user!.uid.hashCode <= id.hashCode
          ? '${user!.uid}_$id'
          : '${id}_${user!.uid}';

  // all messages snapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.userId)}/messages/')
        .snapshots();
  }

  // send text message
  static Future<void> sendMessage(ChatUser chatUser, String msg,
      String replyText, ChatMessageType messageType) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final ChatMessage message = ChatMessage(
      toId: chatUser.userId,
      read: '',
      message: msg,
      type: messageType,
      fromId: user!.uid,
      sent: time,
      replyText: replyText,
      videoChat: VideoChat(id: '', duration: '', message: ''),
      isVideoCallOn: false,
    );
    final ref = firestore
        .collection('chats/${getConversationId(chatUser.userId)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) {}).catchError((e) {
      print(e.toString());
    });
  }

  // send video chat message
  // static Future<void> sendVideoRequestMessage(
  //     ChatUser chatUser,
  //     String msg,
  //     String replyText,
  //     ChatMessageType messageType,
  //     VideoChat videoChat,
  //     bool startCall) async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();

  //   final ChatMessage message = ChatMessage(
  //     toId: chatUser.userId,
  //     read: '',
  //     message: msg,
  //     type: messageType,
  //     fromId: user!.uid,
  //     sent: time,
  //     replyText: replyText,
  //     videoChat: VideoChat(
  //       id: videoChat.id,
  //       duration: videoChat.duration,
  //       message: videoChat.message,
  //     ),
  //     isVideoCallOn: startCall,
  //   );
  //   final ref = firestore
  //       .collection('chats/${getConversationId(chatUser.userId)}/messages/');
  //   await ref.doc(time).set(message.toJson()).then((value) {
  //     print('all good');
  //   }).catchError((e) {
  //     print(e.toString());
  //   });
  // }

  // delete chat message from conversation
  static Future<void> deleteChatMessage(
    ChatMessage chatMessage,
  ) async {
    await firestore
        .collection('chats/${getConversationId(chatMessage.toId)}/messages/')
        .doc(chatMessage.sent)
        .delete();
  }

  // send image message
  static Future<void> sendChatImage(
      ChatUser chatUser, String replyText, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'images/${getConversationId(chatUser.userId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(
      file,
      SettableMetadata(
        contentType: 'image/$ext',
      ),
    )
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, replyText, ChatMessageType.image);
  }

  // send audio message
  static Future<void> sendAudioMessage(
      ChatUser chatUser, String replyText, File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child(
        'audios/${getConversationId(chatUser.userId)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref
        .putFile(
      file,
      SettableMetadata(
        contentType: 'audio/$ext',
      ),
    )
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    final audioUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, audioUrl, replyText, ChatMessageType.audio);
  }

  // update message-read status
  static Future<void> updateReadStatus(ChatMessage chatMessage) async {
    await firestore
        .collection('chats/${getConversationId(chatMessage.fromId)}/messages/')
        .doc(chatMessage.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  // last message snapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationId(user.userId)}/messages/')
        .orderBy('sent', descending: true)
        .limit(
          1,
        )
        .snapshots();
  }

  // user info snapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('userId', isEqualTo: chatUser.userId)
        .snapshots();
  }

  // user info with userId
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfoWithUserId(
      String userId) {
    return firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // profile info snapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> getProfileInfo() {
    return firestore
        .collection('users')
        .where('userId', isEqualTo: user!.uid)
        .snapshots();
  }

  // update online status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user!.uid).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      // 'push_token': me.pushToken,
    });
  }
}
