import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:weather/data/remote/model/user_model.dart';

class FireStoreUser {
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUserToFireStore(UserModel model) async {
    return await _reference.doc(model.userId).set(model.toJson());
  }

  Future<DocumentSnapshot> getCurrentUser(String uId) async {
    return await _reference.doc(uId).get();
  }

  Future<void> updateUser(String uId, UserModel model) async {
    return await _reference.doc(uId).update(model.toJson());
  }

  Future<void> updateUserSingleValue(
      String uId, String key, String value) async {
    
    return await _reference.doc(uId).update({key: value});
  }
}
