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
                            image: loginUser.imgUrl != null
                                ? NetworkImage("${loginUser.imgUrl}")
                                : NetworkImage(
                                    "https://www.google.com/search?q=profile+image&rlz=1C1CHBF_frFR967FR967&tbm=isch&source=iu&ictx=1&vet=1&fir=H6pHpB03ZEAgeM%252Cwg0CyFWNfK7o5M%252C_%253B6LZBULRxg_WfYM%252Cb5C9ViMmmhpq-M%252C_%253BB3G4vEo9lSBh0M%252CFvQHUVZ-cx81xM%252C_%253BJpaFCmffhUdABM%252CeirPelkp9eoYkM%252C_%253BgRmIHR3owD_V0M%252CpmE0x0RqkiBF7M%252C_%253BjAbbSdWZuoI5VM%252CbNcOzSNtObF5xM%252C_%253Bbn2FhB9xAX_09M%252CAxbDaKpnLJRHjM%252C_%253BuXISzfBmyACS2M%252CUaTT14cKZXZhDM%252C_%253BTUPxmKQ-sparcM%252CFvQHUVZ-cx81xM%252C_%253BWgJP1HLvsHDWSM%252C-_VDyVVleiKWeM%252C_%253B-h20Jdis7Qx6mM%252C1OYXNPk0ZutdDM%252C_%253BVT5qYdgyTZyr8M%252CSixlWtBpRVa7SM%252C_%253B31dvrCPLIkewdM%252CdSpQ5-chSmGJjM%252C_%253BA1JLS0S6wZDMMM%252Cb5C9ViMmmhpq-M%252C_%253Bao1hFGI76RKBsM%252CbNcOzSNtObF5xM%252C_%253B8YKhHqULA_X3YM%252CSixlWtBpRVa7SM%252C_&usg=AI4_-kQPyyMYTimpbEeTcHPS2gxFVhY80A&sa=X&ved=2ahUKEwigg-uGiNr1AhUSrhQKHadOD_0Q9QF6BAgDEAE#imgrc=H6pHpB03ZEAgeM"),
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
