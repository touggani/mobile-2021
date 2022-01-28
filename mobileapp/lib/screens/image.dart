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

class _MyImageState extends State<MyImage> {
  bool _isLikeOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: _scrollImage(widget.film));
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
              Icons.favorite,
              color: _isLikeOn == true ? Colors.pink : Colors.grey,
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
          Text('Overview : ' + film.overview.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Id : ' + film.id.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Adulte : ' + film.adult.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Release date : ' + film.releaseDate.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Original Title : ' + film.originalTitle.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Original Language : ' + film.originalLanguage.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Popularity : ' + film.popularity.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Vote count : ' + film.voteCount.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
          Text('Vote average : ' + film.voteAverage.toString(),
              style: GoogleFonts.roboto(
                color: CupertinoColors.black,
                fontSize: 15,
              )),
        ],
      ),
    );
  }
}
