class UserModel{
  String? uid;
  String? email;
  String? nom;
  String? prenom;

  UserModel({this.uid, this.email, this.nom, this.prenom});


//retour serveur
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      nom: map['nom'],
      prenom: map['prenom'],
    );
  }

//envoie vers serveur
  Map<String,dynamic> toMap(){
    return{
      'uid': 'uid',
      'email': 'email',
      'nom': 'nom',
      'prenom': 'prenom'
    };
  }
}