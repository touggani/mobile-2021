import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/data/models/user_model.dart';
import 'package:mobileapp/page/authFirebase/login.dart';
import 'package:mobileapp/page/global/loading.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseStorage storage = FirebaseStorage.instance;
  UserModel loginUser = UserModel();
  bool isLoading = false;
  bool init = false;

  @override
  void initState() {
    super.initState();
    _getActualUser();
  }

  _getActualUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loginUser = UserModel.fromMap(value.data());
      setState(() {
        init = true;
      });
    });
}

  @override
  Widget build(BuildContext context) {
    if (!init) return Loading();
    if (isLoading) return Loading();
    return Scaffold(
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: Image.asset("assets/logo-appmobile.png",
                      fit: BoxFit.contain),
                ),
                Stack(children: [
                  ClipOval(
                      child: Material(
                          color: Colors.transparent,
                          child: Ink.image(
                            image: loginUser.imgUrl != ""
                                ? NetworkImage("${loginUser.imgUrl}")
                                : NetworkImage("https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"),
                            fit: BoxFit.cover,
                            width: 128,
                            height: 128,
                            child: InkWell(onTap: () {
                              _upload('gallery');
                            }),
                          ))),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: ClipOval(
                      child: Container(
                          padding: EdgeInsets.all(4),
                          color: Colors.white,
                          child: ClipOval(
                            child: Container(
                              padding: EdgeInsets.all(8),
                              color: Colors.orange,
                              child: Icon(
                                loginUser.imgUrl == null
                                    ? Icons.add_a_photo
                                    : Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )),
                    ),
                  ),
                ]),
                Text(
                  "Bonjour",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${loginUser.nom} ${loginUser.prenom}",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                Text(
                  "${loginUser.email}",
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                ActionChip(
                    label: Text("Deconnexion"),
                    onPressed: () {
                      Deconnexion(context);
                    }),
              ],
            )),
      ),
    );
  }

  Future<void> Deconnexion(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;

    pickedImage =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 1920);

    final String fileName =
        "img_profile_${loginUser.uid}_${Timestamp.now().seconds}.jpg";
    File imageFile = File(pickedImage!.path);
    setState(() {
      isLoading = true;
    });
    // Uploading the selected image with some custom meta data
    TaskSnapshot snapshot = await storage.ref(fileName).putFile(
        imageFile,
        SettableMetadata(customMetadata: {
          'uploaded_by': '${loginUser.uid}',
          'description': 'Image de profile User ${loginUser.uid}'
        }));
    if (snapshot.state == TaskState.success) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(loginUser.uid)
          .update({"imgUrl": downloadUrl});
      _getActualUser();
    }
    // Refresh the UI
    setState(() {
      isLoading = false;
    });
  }
}
