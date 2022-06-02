class utilisateur {
  int? id;
  String? nom;
  String? email;
  String? password;
  utilisateur.withId(this.id, this.nom, this.email, this.password);
  utilisateur(this.nom, this.email, this.password);
  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom'] = this.nom;
    map['email'] = this.email;
    map['password'] = this.password;
    return map;
  }

  utilisateur.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom = map['nom'];
    this.email = map['email'];
    this.password = map['pass'];
  }
}
