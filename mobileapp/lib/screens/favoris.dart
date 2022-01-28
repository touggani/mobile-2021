import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mobileapp/screens/film.dart';


class Favoris extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final box = Hive.box('favorites');
    print(Hive.box("favorites").length);


    return Scaffold(

        body: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List
            children: List.generate(Hive.box("favorites").length, (index) {
              return Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.network(
                        Hive.box("favorites").get(index) != null ? 'https://image.tmdb.org/t/p/w500/' + Hive.box("favorites").get(index) :
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/No_image_3x4.svg/1200px-No_image_3x4.svg.png'),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: (){
                          Hive.box("favorites").delete(index);
                          //Hive.box("favorites").clear();
                        },
                        child: const Text('Effacer'),
                      ),
                    ],)
              );
              },
            ),

          ),
      );
  }
}