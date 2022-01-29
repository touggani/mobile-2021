import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'api_result.dart';
import 'film.dart';
import 'package:http/http.dart' as http;

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
  var _query = '';

  ApiResult? _apiResult;
  List<Film> _films = [];

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
              child: Row(children: [
                Expanded(
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
                            borderRadius: BorderRadius.all(
                                Radius.circular(25.0)))),
                  ),
                ),
                SizedBox(width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.025,),
                ElevatedButton(
                  onPressed: () {
                    filterSearchResults();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                  child: const Text('Rechercher'),
                ),
              ])),
          Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(children: [
                /*IconButton(icon:
                  _isAdultOn
                      ? FaIcon(FontAwesomeIcons.male)
                      : FaIcon(FontAwesomeIcons.child),
                  color: Colors.red,
              onPressed: () {
                setState(() {
                  _isAdultOn = !_isAdultOn;
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('+18')));
              },
            ),*/
                ActionChip(
                  elevation: 8.0,
                  padding: EdgeInsets.all(2.0),
                  backgroundColor: Colors.black,
                  avatar: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      _isAdultOn ? Icons.bedroom_parent
                        : Icons.bedroom_baby,
                    color: Colors.white,
                    size: 20,
                    ),
                  ),
                  label: Text(_isAdultOn ? '+18' : '-18',style: TextStyle(color: Colors.white),),
                  onPressed: () {
                    setState(() {
                      _isAdultOn = !_isAdultOn;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Catégorie +18 ${_isAdultOn ? 'activée' : 'désactivée'}')));
                  },)
              ])),
          !init
              ? Expanded(
              child: Lottie.asset("assets/the-panda-eats-popcorn.json"))
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
        'https://api.themoviedb.org/3/search/multi?api_key=df33b16d1dd87d889bd119c06dd10960' +
            page +
            adult +
            query);
    debugPrint("[${DateTime.now()}]: Appel API : ${url.toString()}");
    var responseAPI = await http.get(url);
    if (responseAPI.statusCode == 200) {
      debugPrint(
          "[${DateTime.now()}]: Code de retour de l'appel API : ${responseAPI
              .statusCode}");
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
}
