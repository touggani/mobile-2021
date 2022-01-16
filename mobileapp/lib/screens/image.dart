import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  const MyImage({Key? key, this.image, this.id}) : super(key: key);

  final image;
  final id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: _scrollImage(image, id));
  }


  Widget _scrollImage(String image, int id) {
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
                title: Text(
                  'Toto',
                ),
                background: Image.network(
                  image,
                  fit: BoxFit.cover,
                )),
          ),

        ];
      }, body: Text(id.toString()),);
  }
}