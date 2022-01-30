
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  Widget build(BuildContext context) {

    StorageHelper().getComment(widget.movie.id!).then((value) =>
    {

      if (this.mounted) {
        setState(() {
          _comments = value.toList();
        })
      }
    })
    ;

    return Scaffold(

        body: SingleChildScrollView(

          child:
        Container (
        height: 200,

        child :Center(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Text(
                  widget.movie.id.toString(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),


                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "COMMENT : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                _getOpinion()
              ],
            ),
          ),
        ),
        ),
     );
  }

  Widget _getOpinion() {
    if (_comments.isNotEmpty) {


      return Expanded(
        child: ListView.separated(
            padding: const EdgeInsets.all(8),
    itemCount: _comments.length,
    itemBuilder: (BuildContext context, int index) {
        return  Text(_comments[index]["comment"].toString(),
          style: GoogleFonts.roboto(
            color: Colors.orange,
            //fontSize: 15,
          ),
        );
    },
            separatorBuilder: (BuildContext context, int index) => const Divider()
          ),
      );
    } else {
      return const Center(child: Text("No comment for this movie"));
    }
  }
}