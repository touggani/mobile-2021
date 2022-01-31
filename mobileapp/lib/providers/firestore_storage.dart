import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/data/models/user_model.dart';

class StorageHelper {
  CollectionReference comments =  FirebaseFirestore.instance.collection('comment');
  CollectionReference users =  FirebaseFirestore.instance.collection('users');

  var uid = Hive.box("connection").get("uid");

  Future<void> saveComment( { commentText, movieId}) async {
    comments
        .add({
      "comment": commentText,
      "UserUid": uid,
      "movieId": movieId,
      "date" : DateTime.now().toString(),
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }

  Future<List> getComment(movieId) async {
    var res = [];
    await comments.orderBy("timestamp")
        .where("movieId", isEqualTo: movieId)
        .get()
        .then((querySnapshot) => {
      for (var document in querySnapshot.docs)
        {res.add(document.data())}
    });
    return res;
  }

  Future<String?> getUserName(userId) async {
    UserModel res = new UserModel();
    await users
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
             res = UserModel.fromMap(documentSnapshot.data());
        }
    });
    return res.nom;
  }

  Future<List> getUsers() async {
    var res = [];
    await users
        .get()
        .then((QuerySnapshot querySnapshot){
      for (var document in querySnapshot.docs){
        res.add(document.data());
      }
    });
    return res;
  }




}