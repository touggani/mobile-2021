import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'film.dart';

class MyImage extends StatefulWidget {
  const MyImage({Key? key, this.film}) : super(key: key);
  final film;

  @override
  State<MyImage> createState() => _MyImageState();
}

String durationToString(int minutes) {
  var d = Duration(minutes:minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
}

class _MyImageState extends State<MyImage> {
  bool _isLikeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: _scrollImage(widget.film));
  }

  List<Widget> _widgetList(Film film) {
    List<Widget> myList = [];
    film.toJson().forEach((key, value) {
      myList.add(ListTile(
        leading: Text(key.toString(),
            style: GoogleFonts.roboto(
              color: Colors.orange,
              //fontSize: 15,
            )),
        title: Text(value.toString(),
            style: GoogleFonts.roboto(
              color: CupertinoColors.black,
              //fontSize: 15,
            )),
      ));
    });
    return myList;
  }

  Widget _scrollImage(Film film) {
    //Plein écran lors de l'affichage de la fenêtre
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            foregroundColor: Colors.black,
            expandedHeight: MediaQuery.of(context).size.height / 3,
            backgroundColor: Colors.transparent,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,

                //titlePadding: EdgeInsetsDirectional.all(0),
                title: Stack(children: [
                  /* Text(film.title!,
                      style: GoogleFonts.roboto(
                        //color: CupertinoColors.black,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.orange,
                      )),*/
                ]),
                background: Image.network(
                  film.backdropPath != null
                      ? 'https://image.tmdb.org/t/p/w500/' + film.backdropPath!
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png',
                  fit: BoxFit.cover,
                )),
          ),
        ];
      },
      body: Column(
        children: [

          //Expanded(child: ListView(children: _widgetList(film)))
          Expanded(child: Column(

            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 52.0, top: 10.0),
                      child: Text(
                          film.title!,
                          textAlign: TextAlign.center,

                          style: GoogleFonts.roboto(
                            color: CupertinoColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          )),
                    ),
                  ),

                  IconButton(
                    padding: const EdgeInsets.only(left: 32.0, top: 10.0, right: 20.0),
                    icon: Icon(
                      _isLikeOn == true ? Icons.favorite :
                      Icons.favorite_border,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLikeOn = !_isLikeOn;
                      });
                      final snackBar = SnackBar(
                        content: _isLikeOn == true
                            ? Text('Vous avez ajouté ' +
                            film.title.toString() +
                            ' à vos favoris.')
                            : Text('Vous avez retiré ' +
                            film.title.toString() +
                            ' de vos favoris.'),
                        action: SnackBarAction(
                          label: 'Annuler',
                          onPressed: () {
                            setState(() {
                              _isLikeOn = !_isLikeOn;
                            });
                            final snackBar = SnackBar(
                                content: _isLikeOn == true
                                    ? Text(film.title.toString() +
                                    ' a été rajouté à vos favoris.')
                                    : Text(film.title.toString() +
                                    ' a été retiré de vos favoris.'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ],
              ),

              Row( mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("Durée : ",
                      style: GoogleFonts.roboto(
                        color: CupertinoColors.black,
                        //fontSize: 15,
                      )),
                  Text(film.runtime.toString() ,
                      style: GoogleFonts.roboto(
                        color: CupertinoColors.black,

                      )),
                ],
              )

            ],
          ))
        ],
      ),
    );
  }
}
