class operation_sortir {
  int? id;
  int? montant;
  String? description;
  String? date;
  String? type_compte;
  int? id_categorie;
  int? id_compte;
  operation_sortir(this.montant, this.description, this.date, this.type_compte,
      this.id_categorie, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['description'] = this.description;
    map['date'] = this.date;
    map['type_compte'] = this.type_compte;
    map['id_categorie'] = this.id_categorie;
    map['id_compte'] = this.id_compte;
    return map;
  }

  operation_sortir.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.description = map['description'];
    this.date = map['date'];
    this.type_compte = map['type_compte'];
    this.id_categorie = map['id_categorie'];
    this.id_compte = map['id_compte'];
  }
}
