class categorie {
  int? id;
  String? nom;
  String? type;

  categorie(this.nom, this.type);
  categorie.withId(this.id, this.nom, this.type);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom'] = this.nom;
    map['type'] = this.type;
    return map;
  }

  categorie.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom = map['nom'];
    this.type = map['type'];
  }
}
