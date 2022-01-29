import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../apiPage/api_result.dart';
import '../../data/models/film.dart';
import 'package:http/http.dart' as http;
import '../../data/models/genre.dart';
import '../film/image.dart';
import 'multiselect.dart';

class Recherche extends StatefulWidget {
  const Recherche({Key? key}) : super(key: key);

  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  bool _isAdultOn = false;
  final ScrollController _scrollController = ScrollController();
  bool loading = false;
  bool allLoaded = false;
  bool init = false;
  var _genreQuery = '';
  var _query = '';
  bool genreOk = false;
  bool rechercheParGenre = false;
  ApiResult? _apiResult;
  List<Film> _films = [];
  ListGenre? _genres;
  bool isSearchEmpty = true;
  List<Genres> selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<Genres>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: _genres);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        selectedItems = results;
      });
    }
  }

  void filterSearchResults() {
    setState(() {
      init = false;
      isSearchEmpty = _query.isEmpty;
      loading = true;
      _films = [];
      _apiResult = null;
    });
    if (rechercheParGenre) {
      getSearchGenre();
    } else {
      getSearchFilms();
    }
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
        if (_films.isNotEmpty) if (rechercheParGenre) {
          getSearchGenre();
        } else {
          getSearchFilms();
        }
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
      // check box select
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rechercher par ',
                style: GoogleFonts.mochiyPopOne(
                  color: CupertinoColors.black,
                  fontSize: 15,
                )),
            Text('texte',
                style: GoogleFonts.mochiyPopOne(
                  color: Colors.orange,
                  fontSize: 15,
                )),
            Text(' ou par ',
                style: GoogleFonts.mochiyPopOne(
                  color: CupertinoColors.black,
                  fontSize: 15,
                )),
            Text('genre',
                style: GoogleFonts.mochiyPopOne(
                  color: Colors.orange,
                  fontSize: 15,
                ))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: !rechercheParGenre
            ? TextField(
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
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // use this button to open the multi-select dialog
                  ElevatedButton(
                    child: const Text('Selectionner un genre'),
                    onPressed: _showMultiSelect,
                  ),
                ],
              ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Expanded(
              child: !rechercheParGenre
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rechercheParGenre = !rechercheParGenre;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                      ),
                      child: const Text('Rechercher par genres'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          rechercheParGenre = !rechercheParGenre;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0))),
                      ),
                      child: const Text('Rechercher par texte'),
                    )),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.025,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                filterSearchResults();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
              ),
              child: const Text('Rechercher'),
            ),
          )
        ]),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Row(children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.orange,
                  border: Border.all(
                    color: Colors.orange,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text('+18',
                    style: GoogleFonts.roboto(
                      color: CupertinoColors.black,
                      fontSize: 15,
                    )),
              ),
            ),
            Switch(
              value: _isAdultOn,
              onChanged: (value) {
                setState(() {
                  _isAdultOn = !_isAdultOn;
                });
              },
            ),
          ])),
      /*if(recherce_par_genre)
            const Divider(
            height: 10,
          ), */
      if (rechercheParGenre)
        // display selected items
        Wrap(
          children: selectedItems
              .map((e) => Chip(
                    label: Text(e.name.toString()),
                  ))
              .toList(),
        ),

      !init
          ? Expanded(child: Lottie.asset("assets/the-panda-eats-popcorn.json"))
          : Expanded(
              child: Stack(children: [
              ListView.separated(
                itemCount: _films.length,
                controller: _scrollController,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(_films[index].title!,
                          style: GoogleFonts.roboto(
                            color: CupertinoColors.black,
                            fontSize: 10,
                          )),
                      leading: Image.network(_films[index].posterPath != null
                          ? 'https://image.tmdb.org/t/p/w500' +
                              _films[index].posterPath!
                          : 'https://i.imgur.com/R7mqXKL.png'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MyImage(film: _films[index])));
                      }
                      // action
                      );
                },
              ),
              if (loading) ...[
                Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      height: 80,
                      child: Center(child: CircularProgressIndicator())),
                ),
              ]
            ]))
    ]));
  }

  Future<void> getSearchFilms() async {
    if (allLoaded) {
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
        'https://api.themoviedb.org/3/search/multi?api_key=df33b16d1dd87d889bd119c06dd10960' +
            page +
            adult +
            query);
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPI.statusCode}");
      setState(() {
        _apiResult = ApiResult.fromJson(jsonDecode(responseAPI.body));
        _films = _films + _apiResult!.results!;
        loading = false;
        if (!init) init = true;
        if (_apiResult!.page == _apiResult!.totalPages) {
          allLoaded = true;
        }
      });
    }
  }

  Future<void> getGenres() async {
    var url = Uri.parse(
        'https://api.themoviedb.org/3/genre/movie/list?api_key=df33b16d1dd87d889bd119c06dd10960');
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPI.statusCode}");
      setState(() {
        _genres = ListGenre.fromJson(jsonDecode(responseAPI.body));
        genreOk = true;
      });
    }
  }

  Future<void> getSearchGenre() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    var page = '&page=';
    var adult = '&include_adult=' + _isAdultOn.toString();

    for (var i = 0; i < selectedItems.length; i++) {
      if (_genreQuery == '') {
        _genreQuery = selectedItems[i].id.toString();
      } else {
        _genreQuery = _genreQuery + ',' + selectedItems[i].id.toString();
      }
    }

    var genres = '&with_genres=' + _genreQuery;

    if (_apiResult?.page != null) {
      page = page + (_apiResult!.page! + 1).toString();
    } else {
      page = page + '1';
    }
    var url = Uri.parse(
        'https://api.themoviedb.org/3/discover/movie?api_key=df33b16d1dd87d889bd119c06dd10960' +
            page +
            adult +
            genres);
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPI.statusCode}");
      setState(() {
        _apiResult = ApiResult.fromJson(jsonDecode(responseAPI.body));
        _films = _films + _apiResult!.results!;
        loading = false;
        if (!init) init = true;
        if (_apiResult!.page == _apiResult!.totalPages) {
          allLoaded = true;
        }
      });
    }
  }
}
