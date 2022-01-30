import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mobileapp/data/models/filmImage.dart';
import 'package:mobileapp/models/comment_model.dart';
import 'package:mobileapp/page/global/loading.dart';
import 'package:mobileapp/providers/firestore_storage.dart';

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
  var dateFormat = DateFormat('dd/MM/yyyy, HH:mm');
  List _users = [];
  late final Box box;
  late TextEditingController myController;
  bool init = false;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box('connection');
    myController = TextEditingController();
    StorageHelper().getComment(widget.movie.id!).then((comments) => {
          setState(() {
            _comments = comments.toList();
          }),
          StorageHelper().getUsers().then((users) => {
                setState(() {
                  _users = users.toList();
                }),
                addNomImg()
              })
        });
  }

  addNomImg() async {
    if (_comments.length == 0) return setState(() {
      init = true;
    });
    for (int i = 0; i < _comments.length; i++) {
      for (int j = 0; j < _users.length; j++) {
        if (_comments[i]["userId"] == _users[j]["uid"])
          setState(() {
            _comments[i]["nom"] = _users[j]["nom"].toString();
            _comments[i]["imgUrl"] = _users[j]["imgUrl"].toString();
          });
      }
    }
    setState(() {
      init = true;
    });
  }

  addNom() async {
    if (_comments.length == 0) return;
    for (int i = 0; i < _comments.length; i++) {
      var userId = _comments[i]["userId"].toString();
      var userName = await StorageHelper().getUserName(userId);
      setState(() {
        _comments[i]["nom"] = userName?.toString();
      });
    }
    setState(() {
      init = true;
    });
  }

  Future<void> postComment() async {
    if (myController.text == "") return;
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
    if(mounted){
      setState(() {            // Add these lines to your code

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!init) return Loading();
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Container(
                child: Text(
                  "Commentaires ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                  myController.clear();

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
                      var dt =
                          (_comments[index]["timestamp"] as Timestamp).toDate();
                      return Card(
                        child: ListTile(
                          leading: (_comments[index]["imgUrl"] == "" || _comments[index]["imgUrl"] == null)
                              ? Image.asset("assets/blank-profile.png")
                              : Image.network(_comments[index]["imgUrl"]),
                          title: Text(
                            _comments[index]["nom"] == null
                                ? 'Unknown'
                                : _comments[index]["nom"],
                            style: GoogleFonts.roboto(
                              color: Colors.orange,
                              //fontSize: 15,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_comments[index]["comment"].toString(),
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    //fontSize: 15,
                                  )),
                              Text(
                                dateFormat.format(dt).toString(),
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          else
            Container(
                child: Center(child: const Text("No comment for this movie")))
        ],
      ),
    );
  }
}
