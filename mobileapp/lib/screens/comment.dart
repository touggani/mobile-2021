import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/models/comment_model.dart';
import 'package:mobileapp/providers/firestore_storage.dart';

import 'filmImage.dart';

class CommentMob extends StatefulWidget {
  const CommentMob({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final FilmImage movie;

  @override
  CommentMobState createState() => CommentMobState();
}

class CommentMobState extends State<CommentMob> {
  List _comments = [];
  late final Box box;
  late TextEditingController myController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box('connection');
    myController = TextEditingController();
    StorageHelper().getComment(widget.movie.id!).then((value) => {
          setState(() {
            _comments = value.toList();
          })
        });
  }

  postComment() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CommentModel commentModel = CommentModel();
    commentModel.movieId = widget.movie.id;
    commentModel.userId = box.get("uid");
    commentModel.comment = myController.text;
    commentModel.timestamp = Timestamp.now();
    await firebaseFirestore.collection("comment").add(commentModel.toMap());
    Fluttertoast.showToast(
        msg: "Commentaire ajouté !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.orange,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    // int? movieId = widget.movie.id;
    //String getText = "";

    /*StorageHelper().saveComment().then((value) =>
    {
    if (this.mounted) {
      //getText = myController.text,
     // movieId = widget.movie.id
    }
      }
    );*/

    return Column(
      children: [
        Center(
          child: Text(
            "COMMENT : ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _setComment(),
        _getComment(),
      ],
    );
  }

  Widget _setComment() {
    if (!box.get("isLoggin"))
      return Text(
          "Vous n'êtes pas connecté, vous ne pouvez pas écrire de commentaire.");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: myController,
          ),
        ),
        Container(
          height: 50,
          child: TextButton(
            onPressed: () {
              postComment();
            },
            child: const Text(
              "Add comment",
            ),
          ),
        )
      ],
    );
  }

  Widget _getComment() {
    if (_comments.isNotEmpty) {
      return Container(
        height: 400,
        child: ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Expanded(
                  child: ListTile(
                      title: Text(
                        _comments[index]["userId"].toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.orange,
                          //fontSize: 15,
                        ),
                      ),
                      subtitle: Text(_comments[index]["comment"].toString(),
                          style: GoogleFonts.roboto(
                            color: Colors.black,
                            //fontSize: 15,
                          ))),
                ),
              );
            }),
        //Container(height:50,child: Text("blabla")),
      );
    } else {
      return Center(child: const Text("No comment for this movie"));
    }
  }
}
