import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/screens/film.dart';

import 'image.dart';

class Favoris extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final box = Hive.box('favorites');
    //print(Hive.box("favorites").length);
    //Hive.box("favorites").clear();
    debugPrint(
        "[${DateTime.now()}]: ${Hive.box("favorites").get(1).toString()}");

    return ListView(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vos films ',
                style: GoogleFonts.mochiyPopOne(
                  color: CupertinoColors.black,
                  fontSize: 15,
                )),
            Text('favoris',
                style: GoogleFonts.mochiyPopOne(
                  color: Colors.orange,
                  fontSize: 15,
                ))
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemCount: Hive.box("favorites").length,
            itemBuilder: (context, index) {
              return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    image: DecorationImage(
                                      image: NetworkImage(Hive.box("favorites")
                                                  .get(index)
                                                  .backdropPath !=
                                              null
                                          ? 'https://image.tmdb.org/t/p/w500/' +
                                              Hive.box("favorites")
                                                  .get(index)
                                                  .backdropPath
                                                  .toString()
                                          : 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyImage(
                                          film: Hive.box("favorites")
                                              .get(index))));
                                },
                              ),
                              Container(
                                  child: Column(children: [
                                Expanded(child: Container(), flex: 8),
                                Container(
                                    width: double.infinity,
                                    height: 35,
                                    color: Colors.white.withOpacity(0.7),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 8.0, left: 8.0),
                                        child: Center(
                                            child: Text(
                                                Hive.box("favorites")
                                                    .get(index)
                                                    .title!,
                                                style: GoogleFonts.roboto(
                                                  color: CupertinoColors.black,
                                                  fontSize: 10,
                                                ))))),
                              ]))
                            ]),
                      ),
                      /* Container(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Hive.box("favorites").delete(index);
                            //Hive.box("favorites").clear();
                          },
                          child: const Text('Effacer'),
                        ),
                      )*/
                    ],
                  ));
            }),
      ),
      Container(
        child: TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Hive.box("favorites").clear();
          },
          child: const Text('Effacer tous les favoris'),
        ),
      )
    ]);
  }
}
