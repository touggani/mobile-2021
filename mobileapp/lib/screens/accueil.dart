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
  List<Film> _films = [];

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
      debugPrint(_apiResult.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFilms();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !loading) {
        getFilms();
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
    if (!init) {
      return Loading();
    }
    return Stack(children: [
      ListView(
        controller: _scrollController,
        children: [
          Carroussel(
            films: _films,
          ),
          GridView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
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
                            Expanded(
                              child: Container(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            Expanded(child: Container(), flex: 8),
                            Container(
                                width: double.infinity,
                                height: 30,
                                color: Colors.white.withOpacity(0.7),
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 8.0, left: 8.0),
                                    child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(_films[index].title!,
                                            style: GoogleFonts.indieFlower(
                                              color: CupertinoColors.black,
                                            ))))),
                          ]))
                        ]));
              })
        ],
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
