import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'film.dart';

class MyImage extends StatelessWidget {
  const MyImage({Key? key, this.film}) : super(key: key);

  final film;

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _scrollImage(film));
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
                title: Stack(
                  children: [Text(film.title!,
                      style: GoogleFonts.roboto(
                        //color: CupertinoColors.black,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Colors.orange,
                      )),Text(film.title!,
                      style: GoogleFonts.roboto(
                        color: CupertinoColors.black,
                      ))]
                ),
                background: Image.network(
                  film.backdropPath != null
                      ? 'https://image.tmdb.org/t/p/w500/' + film.backdropPath!
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png',
                  fit: BoxFit.cover,
                )),
          ),
        ];
      },
      body: Text(film.id.toString()),
    );
  }
}
