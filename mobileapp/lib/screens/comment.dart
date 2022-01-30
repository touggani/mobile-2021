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
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Container(
              child: Text(
                "COMMENT : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (!box.get("isLoggin"))
            Container(
              child: Text(
                  "Vous n'êtes pas connecté, vous ne pouvez pas écrire de commentaire."),
            ),
          if (box.get("isLoggin"))
            Container(
              child: TextField(
                controller: myController,
              ),
            ),
          if (box.get("isLoggin"))
            Container(
              child: TextButton(
                onPressed: () {
                  postComment();
                },
                child: const Text(
                  "Add comment",
                ),
              ),
            ),
          if (_comments.isNotEmpty)
            Container(
              //height: 300,
              child: Expanded(
                child: ListView.builder(
                    itemCount: _comments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
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
                      );
                    }),
              ),
            )
          else
            Center(child: Container(child: const Text("No comment for this movie")))
        ],
      ),
    );
  }
}
