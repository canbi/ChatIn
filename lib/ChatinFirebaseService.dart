import 'package:cloud_firestore/cloud_firestore.dart';

class ChatinFirebaseService {
  //Returns whether given user exists in the server
  Future<bool> checkIfUserExists(String id) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id.toString())
        .get()
        .then((value) => value.exists);
  }

  Future<bool> checkIfRoomExists(String id) async {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(id.toString())
        .get()
        .then((value) => value.exists);
  }

  //Return newly created user id, 0 on return indicates error.
  Future<void> createUser(String name) async {
    FirebaseFirestore.instance.collection('users').doc(name).set({
      'bio': 'Hey there! I am using ChatIn', // John Doe
      'name': name,
      'sub_chats': []
    }).then((value) => null);
    /*
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.add({
      'bio': 'Hey there! I am using ChatIn', // John Doe
      'name': name,
      'sub_chats': []
    }).then((value) => value.id).catchError((error) => "0");
     */
  }

  Future<void> removeChatroom(String userId, String roomId) async {
    FirebaseFirestore.instance.collection('chats').doc(roomId).delete();
    _removeFromPublicChatrooms(userId, roomId);
  }

  Future<void> _removeFromPublicChatrooms(String userId, String roomId) async {
    var chatIds = FirebaseFirestore.instance.collection('misc').doc('chatIds');
    unsubscribeFromRoom(userId, roomId);
    return chatIds.update({
      'chatIds': FieldValue.arrayRemove(['$roomId'])
    });
  }

  Future<String> createChatroom(String userId, String name) async {
    var newChat = FirebaseFirestore.instance.collection('chats').doc(name);
    return _addToPublicChatrooms(
        userId,
        await newChat.set({
          'name': name, //deprecated
          'time': DateTime.now().millisecondsSinceEpoch,
          'uid': userId,
          'users': [userId],
          'messages': []
        }).then((value) => name));
  }

  Future<String> _addToPublicChatrooms(String userId, String newRoomId) async {
    var chatIds = FirebaseFirestore.instance.collection('misc').doc('chatIds');
    subscribeToRoom(userId, newRoomId);
    return chatIds.update({
      'chatIds': FieldValue.arrayUnion(['$newRoomId'])
    }).then((value) => newRoomId);
  }

  Future<void> subscribeToRoom(String userId, String roomId) async {
    var userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId.toString());
    var chatDoc =
        FirebaseFirestore.instance.collection('chats').doc(roomId.toString());
    return userDoc.update({
      'sub_chats': FieldValue.arrayUnion(['$roomId'])
    }).then((value) => chatDoc.update({
          'users': FieldValue.arrayUnion(['$userId'])
        }).then((value) => null));
  }

  Future<void> unsubscribeFromRoom(String userId, String roomId) async {
    var userDoc =
        FirebaseFirestore.instance.collection('users').doc(userId.toString());
    var chatDoc =
        FirebaseFirestore.instance.collection('chats').doc(roomId.toString());
    return userDoc.update({
      'sub_chats': FieldValue.arrayRemove(['$roomId'])
    }).then((value) => null);

    // ! impossible to reach deleted chatroom
    /*then((value) => chatDoc.update({
          'users': FieldValue.arrayRemove(['$userId'])
        })*/
  }

  //Get data on specific user
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserById(
      String userId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId.toString())
        .get();
  }

  //Get data on specific chatroom
  Future<DocumentSnapshot<Map<String, dynamic>>> getChatroom(
      String roomId) async {
    return FirebaseFirestore.instance.collection('chats').doc(roomId).get();
  }

  //Get specific chatroom stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatroomStream(
      String roomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(roomId)
        .snapshots();
  }

  Future<void> sendMessage(String userId, String roomId, String msg) async {
    var chatDoc = FirebaseFirestore.instance.collection('chats').doc(roomId);
    return chatDoc.update({
      'messages': FieldValue.arrayUnion([
        {
          'uid': userId,
          'content': msg,
          'time': DateTime.now().millisecondsSinceEpoch
        }
      ]),
    }).then((value) => null);
  }

  //returns a future that will have the list of all public chatroom ids
  Future<List<dynamic>> getAllChatIds() async {
    return FirebaseFirestore.instance
        .collection('misc')
        .doc('chatIds')
        .get()
        .then((value) => value['chatIds']);
  }

  Future<void> editUser(String userId, String name, String bio) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'name': name, 'bio': bio}).then((value) => null);
  }
}
