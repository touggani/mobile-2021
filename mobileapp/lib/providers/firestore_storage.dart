import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/screens/registration.dart';

class StorageHelper {
  CollectionReference comments =
  FirebaseFirestore.instance.collection('comment');


  var uid = Hive.box("connection").get("uid");

  void saveComment({comment, movie, date}) {
    comments
        .add({
      "comment": comment,
      "uid": uid,
      "movie": movie,
      "date" : date,
    })
        .then((value) => print("Comment Added"))
        .catchError((error) => print("Failed to add comment: $error"));
  }

  Future<List> getComment(movieId) async {
    var res = [];
    await comments
        .where("movieId", isEqualTo: movieId)
        .get()
        .then((querySnapshot) => {
      for (var document in querySnapshot.docs)
        {res.add(document.data())}
    });
    return res;
  }




}