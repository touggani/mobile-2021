import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

import 'api_result.dart';
import 'film.dart';
import 'package:http/http.dart' as http;

import 'genre.dart';
import 'image.dart';

class Recherche extends StatefulWidget {
  const Recherche({Key? key}) : super(key: key);

  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  bool _isAdultOn = false;
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  bool allloaded = false;
  bool init = false;
  bool genre_ok = false;
  bool recherce_par_genre = false;
  var _query = '';

  ApiResult? _apiResult;
  List<Film> _films = [];
  Genres? _genres;

  bool _isSearchEmpty = true;

  void filterSearchResults() {
    setState(() {
      init = false;
      _isSearchEmpty = _query.isEmpty;
      loading = true;
      _films = [];
      _apiResult = null;
    });
    getSearchFilms();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGenres();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent &&
          !loading) {
        if (_films.isNotEmpty) getSearchFilms();
        print("Refresh");
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
    return Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row ( children: [Expanded(
              child: TextField(
                //controller: editingController,
                onChanged: (value) {
                  setState(() {
                  _query = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: "Rechercher",
                    hintText: "Matrix 2...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            )
            ])
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row ( children: [ Expanded( child:

                !recherce_par_genre ? ElevatedButton(
                  onPressed: () {
                    setState(() {
                      recherce_par_genre = !recherce_par_genre;
                    });
                  },
                  style : ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),),
                  child: const Text('Rechercher par genres'),
                ) : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      recherce_par_genre = !recherce_par_genre;
                    });
                  },
                  style : ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),),
                  child: const Text('Rechercher par texte'),
                )),ElevatedButton(
                  onPressed: () {
                    filterSearchResults();
                  },
                  style : ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25.0))),),
                  child: const Text('Rechercher'),
                )

              ])
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(children: [
                ActionChip(
                  elevation: 8.0,
                  padding: EdgeInsets.all(2.0),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(
                      _isAdultOn
                          ? Icons.bakery_dining_rounded
                          : Icons.bakery_dining_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  label: Text('+18'),
                  onPressed: () {
                    setState(() {
                      _isAdultOn = !_isAdultOn;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('+18')));
                  },
                  backgroundColor: Colors.grey[200],
                  shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      )),
                ),
              ])),
          !init
              ? Expanded(
              child: Lottie.asset("assets/the-panda-eats-popcorn.json"))
              : Expanded(
            child: Stack( children:[ListView.separated(
              itemCount: _films.length,
              controller: _scrollController,
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_films[index].title!,
                      style: GoogleFonts.indieFlower(
                        color: CupertinoColors.black,
                      )),
                  leading: Image.network(_films[index]
                      .posterPath !=
                      null
                      ? 'https://image.tmdb.org/t/p/w500' +
                      _films[index].posterPath!
                      : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png'),
    onTap: () {
    Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => MyImage(
    film: _films[index])));
    }
                    // action
                );
              },
            ),
              if (loading) ...[
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              ),
            )
          ]
        ])
          )
        ]));
  }

  Future<void> getSearchFilms() async {
    if (allloaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    var page = '&page=';
    var adult = '&include_adult=' + _isAdultOn.toString();
    var query = '&query=' + _query;
    if (_apiResult?.page != null) {
      page = page + (_apiResult!.page! + 1).toString();
    } else {
      page = page + '1';
    }
    var url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=df33b16d1dd87d889bd119c06dd10960' +
            page + adult + query);
    debugPrint(url.toString());
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
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

  Future<void> getGenres() async {

    var url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=df33b16d1dd87d889bd119c06dd10960');
    debugPrint(url.toString());
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      setState(() {
        _genres = Genres.fromJson(jsonDecode(responseAPI.body));
        genre_ok = true;
      });
    }
  }
}