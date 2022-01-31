import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{
  int? movieId;
  String? userId;
  Timestamp? timestamp;
  String? comment;

  CommentModel({this.movieId, this.userId, this.timestamp, this.comment});


//retour serveur
  factory CommentModel.fromMap(map){
    return CommentModel(
        movieId: map['movieId'],
      userId: map['userId'],
      timestamp: map['timestamp'],
      comment: map['comment']
    );
  }

//envoie vers serveur
  Map<String,dynamic> toMap(){
    return{
      'movieId': movieId,
      'userId': userId,
      'timestamp': timestamp,
      'comment': comment
    };
  }
}