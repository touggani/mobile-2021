import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'film.dart';
import 'image.dart';

class Carroussel extends StatefulWidget {
  final List<Film> films;
  Carroussel({required this.films});
  @override
  _CarrousselState createState() => _CarrousselState();
}

class _CarrousselState extends State<Carroussel> {
  int _currentIndex=0;
  List cardList =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cardList=[
      Item(film: widget.films[0],),
      Item(film: widget.films[1],),
      Item(film: widget.films[2],),
    ];
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(seconds: 2),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          enlargeCenterPage: true,
          pageSnapping: true,
          aspectRatio: 2.0,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        items: cardList.map((card){
          return Builder(
              builder:(BuildContext context){
                return Container(
                  height: MediaQuery.of(context).size.height*0.30,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    color: Colors.blueAccent,
                    child: card,
                  ),
                );
              }
          );
        }).toList(),),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(cardList, (index, url) {
          return Container(
            width: 10.0,
            height: 10.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index ? Colors.blueAccent : Colors.grey,
            ),
          );
        }),
      ),
    ]);
  }
}

class Item extends StatelessWidget {
  final Film film;
  Item({required this.film});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(

              color: Colors.white
        ),
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(15)),
                    image: DecorationImage(
                      image: NetworkImage('https://image.tmdb.org/t/p/w500/' + film.backdropPath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyImage(id: film.id,image: 'https://image.tmdb.org/t/p/w500/' + film.backdropPath!)
                  ));
                },
              ),
              Container(
                  child: Column(children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Padding(padding: EdgeInsets.all(8.0),child: Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        )),),
                    ),
                    Expanded(child: Container(), flex: 8),
                    Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.white.withOpacity(0.7),
                        //alignment: Alignment.bottomCenter,
                        /*decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),*/
                        child: Padding(
                            padding:
                            EdgeInsets.only(right: 8.0, left: 8.0),
                            child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(film.title!,
                                    style: GoogleFonts.indieFlower(
                                      color: CupertinoColors.black,
                                      //fontSize: 25,
                                    ))))),
                  ]))
            ])
    );
  }
}