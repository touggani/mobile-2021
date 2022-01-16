import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class Recherche extends StatefulWidget {
  const Recherche({Key? key}) : super(key: key);

  @override
  _RechercheState createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  bool _isStartersOn = false;
  bool _isDishesOn = false;
  bool _isDesertsOn = false;

  bool _isSearchEmpty = true;

  final duplicateItems = List<String>.generate(10, (i) => "Item $i");

  void filterSearchResults(String query) {
    setState(() {
      _isSearchEmpty = query.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              //controller: editingController,
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: InputDecoration(
                  labelText: "Rechercher",
                  hintText: "Matrix 2...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)))),
            ),
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
                      _isStartersOn
                          ? Icons.bakery_dining_rounded
                          : Icons.bakery_dining_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  label: Text('Thriller'),
                  onPressed: () {
                    setState(() {
                      _isStartersOn = !_isStartersOn;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Thriller')));
                  },
                  backgroundColor: Colors.grey[200],
                  shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      )),
                ),
                ActionChip(
                  elevation: 8.0,
                  padding: EdgeInsets.all(2.0),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      _isDishesOn
                          ? Icons.bakery_dining_rounded
                          : Icons.bakery_dining_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  label: Text('Romance'),
                  onPressed: () {
                    setState(() {
                      _isDishesOn = !_isDishesOn;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Romance')));
                  },
                  backgroundColor: Colors.grey[200],
                  shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      )),
                ),
                ActionChip(
                  elevation: 8.0,
                  padding: EdgeInsets.all(2.0),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.yellowAccent,
                    child: Icon(
                      _isDesertsOn
                          ? Icons.bakery_dining_rounded
                          : Icons.bakery_dining_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  label: Text('Documentaire'),
                  onPressed: () {
                    setState(() {
                      _isDesertsOn = !_isDesertsOn;
                    });
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Documentaire')));
                  },
                  backgroundColor: Colors.grey[200],
                  shape: StadiumBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.redAccent,
                      )),
                ),
              ])),
          _isSearchEmpty
              ? Expanded(child: Lottie.asset("assets/the-panda-eats-popcorn.json"))
              : Expanded(
            child: ListView.separated(
              itemCount: duplicateItems.length,
              separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(duplicateItems[index]),
                  leading: Icon(Icons.favorite),
                  onTap: () {
                    // action
                  },
                );
              },
            ),
          )
        ]));
  }
}