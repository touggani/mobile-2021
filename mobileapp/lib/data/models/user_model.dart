class UserModel{
  String? uid;
  String? email;
  String? nom;
  String? prenom;
  String imgUrl;

  UserModel({this.uid, this.email, this.nom, this.prenom, this.imgUrl = ""});


//retour serveur
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nom: map['nom'],
      prenom: map['prenom'],
      imgUrl: map['imgUrl'],
    );
  }

//envoie vers serveur
  Map<String,dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'imgUrl': imgUrl
    };
  }
}