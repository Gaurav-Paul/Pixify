import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pixify/helper/show_alert_dialog.dart';
import 'package:pixify/services/auth_service.dart';
import 'package:pixify/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final FirebaseDatabase database = DatabaseService.database;

  sendMessage({
    required BuildContext context,
    required String textMessage,
    required String receiverUserUid,
    required String senderUserUid,
  }) async {
    try {
      final int timeSent = DateTime.now().microsecondsSinceEpoch;

      final DataSnapshot senderUserDataSnapshot =
          (await database.ref('users').child(senderUserUid).get());

      final DataSnapshot recieverUserDataSnapshot =
          (await database.ref('users').child(receiverUserUid).get());

      await addUserToConversationsList(
          recieverUID: receiverUserUid,
          senderUid: senderUserUid,
          senderUserDataSnapshot: senderUserDataSnapshot,
          recieverUserDataSnapshot: recieverUserDataSnapshot);

      await saveMessageForBothUsers(
          receiverUserUid: receiverUserUid,
          textMessage: textMessage,
          timeSent: timeSent,
          textMessageId: const Uuid().v1(),
          senderUsername:
              senderUserDataSnapshot.child('username').value.toString(),
          receiverUsername:
              recieverUserDataSnapshot.child('username').value.toString(),
          messageType: 'text');

      await saveLastMessageForBothUsers(
          senderUserUID: senderUserUid,
          receiverUserUid: receiverUserUid,
          senderUserDataSnapshot: senderUserDataSnapshot,
          receiverUserDataSnapshot: recieverUserDataSnapshot,
          lastMessage: textMessage,
          timeSent: timeSent);
    } catch (e) {
      showAlertDialog(context: context, content: e.toString());
    }
  }

  saveMessageForBothUsers({
    required String receiverUserUid,
    required String textMessage,
    required int timeSent,
    required String textMessageId,
    required String senderUsername,
    required String receiverUsername,
    required String messageType,
  }) async {
    final Map<String, dynamic> message = {
      "senderId": AuthService.auth.currentUser!.uid,
      "recieverId": receiverUserUid,
      "textMessage": textMessage,
      "type": messageType,
      "timeSent": timeSent,
      "messageId": textMessageId,
    };

    // Save Message in Sender's data
    await database
        .ref('users')
        .child(AuthService.auth.currentUser!.uid)
        .child('chats')
        .child(receiverUserUid)
        .child("messages")
        .child(textMessageId)
        .set(message);

    // Save Message in Reciever's data
    await database
        .ref('users')
        .child(receiverUserUid)
        .child('chats')
        .child(AuthService.auth.currentUser!.uid)
        .child("messages")
        .child(textMessageId)
        .set(message);
  }

  saveLastMessageForBothUsers({
    required String senderUserUID,
    required String receiverUserUid,
    required DataSnapshot senderUserDataSnapshot,
    required DataSnapshot receiverUserDataSnapshot,
    required String lastMessage,
    required int timeSent,
  }) async {
    final Map<String, dynamic> recieverMessageMap = {
      "username": senderUserDataSnapshot.child('username').value.toString(),
      "profilePicURL":
          senderUserDataSnapshot.child('profilePicURL').value.toString(),
      'uid': senderUserUID,
      "timeSent": timeSent,
      "lastMessage": lastMessage,
    };

    final Map<String, dynamic> senderMessageMap = {
      "username": receiverUserDataSnapshot.child('username').value.toString(),
      "profilePicURL":
          receiverUserDataSnapshot.child('profilePicURL').value.toString(),
      'uid': receiverUserUid,
      "timeSent": timeSent,
      "lastMessage": lastMessage,
    };

    // Save Last Message to Sender's data
    await database
        .ref('users')
        .child(senderUserUID)
        .child('chats')
        .child(receiverUserUid)
        .update(senderMessageMap);

    // Save Last Message to Receiver's data
    await database
        .ref('users')
        .child(receiverUserUid)
        .child('chats')
        .child(senderUserUID)
        .update(recieverMessageMap);
  }

  addUserToConversationsList(
      {required String recieverUID,
      required String senderUid,
      required DataSnapshot senderUserDataSnapshot,
      required DataSnapshot recieverUserDataSnapshot}) async {
    print(senderUserDataSnapshot.child('conversations').value);
    print(senderUserDataSnapshot.child('conversations').value.runtimeType);

    List listOfSendersConversations =
        senderUserDataSnapshot.child('conversations').value as List;

    List listOfReceiversConversations =
        recieverUserDataSnapshot.child('conversations').value as List;

    print(listOfSendersConversations);

    if (!(listOfSendersConversations.contains(recieverUID)) ||
        !(listOfReceiversConversations.contains(senderUid))) {
      print('not here');
      await database
          .ref('users')
          .child(senderUid)
          .child('conversations')
          .update({
        (senderUserDataSnapshot.child('conversations').children.length)
            .toString(): recieverUID,
      });

      await database
          .ref('users')
          .child(recieverUID)
          .child('conversations')
          .update({
        (recieverUserDataSnapshot.child('conversations').children.length)
            .toString(): senderUid,
      });
    }
  }
}
