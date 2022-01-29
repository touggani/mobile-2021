import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



import 'film.dart';

class MyImage extends StatefulWidget {

  const MyImage({Key? key, this.film}) : super(key: key);
  final film;
  @override
  State<MyImage> createState() => _MyImageState();

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
            expandedHeight: MediaQuery.of(context).size.height / 2,
            backgroundColor: Colors.transparent,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,

                //titlePadding: EdgeInsetsDirectional.all(0),
                title: Stack(children: [
                  Text(film.title!,
                      style: GoogleFonts.roboto(
                        //color: CupertinoColors.black,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.orange,
                      )),
                  Text(film.title!,
                      style: GoogleFonts.roboto(
                        color: CupertinoColors.black,
                      ))
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
          IconButton(
            icon: Icon(
              _isLikeOn == true ? Icons.favorite :
              Icons.favorite_border,
              color: Colors.orange,
            ),
            onPressed: () {
              Hive.box("favorites").add(film);
              print("Add ${Hive.box("favorites").get(0)} to favorites");
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
          Expanded(child: ListView(children: _widgetList(film))),
          //Text(name)
        ],
      ),

    );
  }
}
