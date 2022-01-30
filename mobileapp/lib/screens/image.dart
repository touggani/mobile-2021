import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobileapp/screens/filmImage.dart';
import 'comment.dart';
import 'film.dart';
import 'package:http/http.dart' as http;

import 'loading.dart';

class MyImage extends StatefulWidget {
  const MyImage({Key? key, this.film}) : super(key: key);
  final film;

  @override
  State<MyImage> createState() => _MyImageState();
}

String durationToString(int minutes) {
  var d = Duration(minutes: minutes);
  List<String> parts = d.toString().split(':');
  return '${parts[0].padLeft(2, '0')}h${parts[1].padLeft(2, '0')}min';
}

class _MyImageState extends State<MyImage> {
  bool _isLikeOn = false;
  late final Box box;
  late FilmImage _film;
  bool init = false;

  Future<void> getGenreRomance(Film film) async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${film.id}?api_key=df33b16d1dd87d889bd119c06dd10960');
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var request = await http.get(url);
    if (request.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${request.statusCode}");
      setState(() {
        _film = FilmImage.fromJson(jsonDecode(request.body));
        if (!init) init = true;
      });
    }
  }

  _deleteFavoris(int index) {
    setState(() {
      box.deleteAt(index);
    });
    print('Item deleted from box at index: $index');
  }

  _addFavoris(Film film) {
    box.add(film);
    print('Item added');
  }

  _getAddDelete(Film film) async {
    if (_isLikeOn == true) {
      print('if');
      await _addFavoris(film);
    } else {
      print('else');
      for (var i = 0; i < box.length; i++) {
        if (film.id == box.getAt(i).id) {
          await _deleteFavoris(i);
        }
      }
    }
  }

  _getFavoriteStatus(Film film) {
    for (var i = 0; i < box.length; i++) {
      if (widget.film.id == box.getAt(i).id) {
        setState(() {
          _isLikeOn = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    box = Hive.box('favorites');
    getGenreRomance(widget.film);
    _getFavoriteStatus(widget.film);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: _scrollImage(widget.film));
  }

  List<Widget> _widgetList(FilmImage film) {
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
    if (!init) {
      return Loading();
    }
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
                titlePadding: EdgeInsetsDirectional.all(0),
                title: Stack(children: [
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 52.0, top: 5.0, bottom: 5.0),
                            child: Text(film.title!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.mochiyPopOne(
                                  color: CupertinoColors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                )),
                          ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(
                              left: 0, top: 5.0, right: 20.0, bottom: 5.0),
                          icon: Icon(
                            _isLikeOn == true
                                ? Icons.favorite
                                : Icons.favorite_border,
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
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              ),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                        ),
                      ],
                    ),
                  ),
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    //flex: 1,
                    child: Text("Durée : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(durationToString(_film.runtime!),
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Date de sortie : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_film.releaseDate!,
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Statut : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_film.status!,
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Note moyenne : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(_film.voteAverage.toString(),
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Synopsis : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_film.overview!,
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                        )),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Row(children: <Widget>[
                  Expanded(
                    child: Text("Genre : ",
                        textAlign: TextAlign.left, // has impact
                        style: GoogleFonts.roboto(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                ])),
            Align(
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 5,
                //alignment: WrapAlignment.center,
                children: _film.genres!
                    .map((e) => Chip(
                          padding: const EdgeInsets.all(0),
                          label: Text(e.name.toString(),
                              style: GoogleFonts.roboto(
                                color: Colors.orange,
                                //fontSize: 15,
                              )),
                        ))
                    .toList(),
              ),
            ),


                Container(
                  height: 800,
                  // don't forget about height

                  child:
                  CommentMob(movie: _film),

                ),


          ],
        ),
      ),
    );
  }
}
