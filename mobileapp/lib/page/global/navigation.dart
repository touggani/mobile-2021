import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import '../recherche/recherche.dart';
import '../accueil/accueil.dart';
import '../favoris/favoris.dart';
import '../profile/profile.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  _navigationState createState() => _navigationState();
}

class _navigationState extends State<Navigation> {
  Widget _accueil = Accueil();
  Widget _recherche = Recherche();
  Widget _favoris = Favoris();
  Widget _profil = Profil();

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget getBody() {
    if (this._selectedIndex == 0) {
      return this._accueil;
    } else if (this._selectedIndex == 1) {
      return this._recherche;
    } else if (this._selectedIndex == 2) {
      return this._favoris;
    } else {
      return this._profil;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Lottie.asset("assets/camera-moving.json"),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Cinema',
                style: GoogleFonts.mochiyPopOne(
                  color: CupertinoColors.black,
                  fontSize: 25,
                )),
            Text('\'Tic',
                style: GoogleFonts.mochiyPopOne(
                  color: Colors.orange,
                  fontSize: 25,
                ))
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Accueil',
            tooltip: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Rechercher',
            tooltip: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: 'Favoris',
            tooltip: 'Favoris',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: 'Profil',
            tooltip: 'Profil',
            //backgroundColor: Colors.grey,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
      ),
    );
  }
}
