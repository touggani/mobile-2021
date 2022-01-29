import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapp/screens/film.dart';
import 'image.dart';
import 'package:flutter/widgets.dart';
import 'api_result.dart';
import 'caroussel.dart';
import 'film.dart';
import 'package:http/http.dart' as http;


class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  bool init = false;
  bool loading = true;
  bool allloaded = false;
  final ScrollController _scrollController = ScrollController();

  ApiResult? _apiResult;
  ApiResult? _apiResultPopular;
  ApiResult? _apiResultAction;
  ApiResult? _apiResultRomance;
  ApiResult? _apiResultHorreur;
  List<Film> _films = [];
  List<Film> _filmsPopular = [];
  List<Film> _filmsAction = [];
  List<Film> _filmsRomance = [];
  List<Film> _filmsHorreur = [];

  Future<void> getGenreAction() async {
    var url_action = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=df33b16d1dd87d889bd119c06dd10960&with_genres=28');
    debugPrint("[${DateTime.now()}]: Appel API : ${url_action.toString()}");
    var responseAPIAction = await http.get(url_action);
    if (responseAPIAction.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPIAction.statusCode}");
      setState(() {
        _apiResultAction = ApiResult.fromJson(jsonDecode(responseAPIAction.body));
        _filmsAction = _apiResultAction!.results!;
      });
    }
  }

  Future<void> getGenreRomance() async {
    var url_romance = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=df33b16d1dd87d889bd119c06dd10960&with_genres=10749');
    debugPrint("[${DateTime.now()}]: Appel API : ${url_romance.toString()}");
    var responseAPIRomance = await http.get(url_romance);
    if (responseAPIRomance.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPIRomance.statusCode}");
      setState(() {
        _apiResultRomance = ApiResult.fromJson(jsonDecode(responseAPIRomance.body));
        _filmsRomance = _apiResultRomance!.results!;
      });
    }
  }

  Future<void> getGenreHorreur() async {
    var url_horreur = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=df33b16d1dd87d889bd119c06dd10960&with_genres=27');
    debugPrint("[${DateTime.now()}]: Appel API : ${url_horreur.toString()}");
    var responseAPIHorreur = await http.get(url_horreur);
    if (responseAPIHorreur.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPIHorreur.statusCode}");
      setState(() {
        _apiResultHorreur = ApiResult.fromJson(jsonDecode(responseAPIHorreur.body));
        _filmsHorreur = _apiResultHorreur!.results!;
      });
    }
  }

  Future<void> getFilms() async {
    if (allloaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    var page = '&page=';
    if (_apiResult?.page != null) {
      page = page + (_apiResult!.page! + 1).toString();
    } else {
      page = page + '1';
    }
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=df33b16d1dd87d889bd119c06dd10960' +
            page);
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      debugPrint("[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPI.statusCode}");
      setState(() {
        _apiResult = ApiResult.fromJson(jsonDecode(responseAPI.body));
        _films = _films + _apiResult!.results!;
        loading = false;
        if (!init) init = true;
        if (_apiResult!.page == _apiResult!.totalPages) {
          allloaded = true;
        }
      });
    }
  }

  Future<void> getFilmPopular() async {
    var url_popular = Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=df33b16d1dd87d889bd119c06dd10960&page=1');
    debugPrint("[${DateTime.now()}]: Appel API : ${url_popular.toString()}");
    var responseAPIPopular = await http.get(url_popular);
    if (responseAPIPopular.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPIPopular.statusCode}");
      setState(() {
        _apiResultPopular = ApiResult.fromJson(jsonDecode(responseAPIPopular.body));
        _filmsPopular = _apiResultPopular!.results!;
      });
      await getGenreAction();
      await getGenreRomance();
      await getGenreHorreur();
      await getFilms();
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFilmPopular();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + MediaQuery.of(context).size.height * 0.30 >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        getFilms();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!init) {
      return Loading();
    }

    return Stack(children: [
      ListView(
        controller: _scrollController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Les films populaires ',
                    style: GoogleFonts.mochiyPopOne(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    )),
                Text('aujourd\'hui',
                    style: GoogleFonts.mochiyPopOne(
                      color: Colors.orange,
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Carroussel(
            films: _filmsPopular,
            ratio: 2.0,
            enlarge: true,
            fraction: 1,
            autoPlay:true,
            infinite:true,
            fontSize:15.0
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Genre ',
                    style: GoogleFonts.mochiyPopOne(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    )),
                Text('action',
                    style: GoogleFonts.mochiyPopOne(
                      color: Colors.orange,
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Carroussel(
            films: _filmsAction,
            initial: 1
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Genre ',
                    style: GoogleFonts.mochiyPopOne(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    )),
                Text('romance',
                    style: GoogleFonts.mochiyPopOne(
                      color: Colors.orange,
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Carroussel(
            films: _filmsRomance,
            initial: 1
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Genre ',
                    style: GoogleFonts.mochiyPopOne(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    )),
                Text('horreur',
                    style: GoogleFonts.mochiyPopOne(
                      color: Colors.orange,
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Carroussel(
            films: _filmsHorreur,
            initial: 1
          ),
          const Divider(
            height: 40,
            thickness: 1,
            indent: 20,
            endIndent: 20,
            color: Colors.orange,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tous ',
                    style: GoogleFonts.mochiyPopOne(
                      color: Colors.orange,
                      fontSize: 15,
                    )),
                Text('les films',
                    style: GoogleFonts.mochiyPopOne(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5,0,5,0),
            child: GridView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemCount: _films.length,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                    image: NetworkImage(_films[index]
                                                .backdropPath !=
                                            null
                                        ? 'https://image.tmdb.org/t/p/w500/' +
                                            _films[index].backdropPath!
                                        : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyImage(
                                        film: _films[index])));
                              },
                            ),
                            Container(
                                child: Column(children: [
                              /*Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: Colors.orange,
                                      )),
                                ),
                              ),*/
                              Expanded(child: Container(), flex: 8),
                              Container(
                                  width: double.infinity,
                                  height: 35,
                                  color: Colors.white.withOpacity(0.7),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 8.0, left: 8.0),
                                      child: Center(
                                          child: Text(_films[index].title!,
                                              style: GoogleFonts.roboto(
                                                color: CupertinoColors.black,
                                                fontSize: 10,
                                              ))))),
                            ]))

                          ]),);
                }),
          )
        ],
      ),
      if (loading) ...[
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(height: 80,child: Center(child: CircularProgressIndicator())),
          ),
      ]
    ]);
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: CircularProgressIndicator(),
    ));
  }
}
