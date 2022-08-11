class operation_sortir {
  int? id;
  int? montant;
  String? description;
  String? date;
  int? id_categorie;
  int? id_compte;
  int? id_utilisateur;
  operation_sortir(this.montant, this.description, this.date, this.id_categorie,
      this.id_compte, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['description'] = this.description;
    map['date'] = this.date;
    map['id_categorie'] = this.id_categorie;
    map['id_compte'] = this.id_compte;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  operation_sortir.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.description = map['description'];
    this.date = map['date'];
    this.id_categorie = map['id_categorie'];
    this.id_compte = map['id_compte'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
