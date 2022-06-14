class operation_sortir {
  int? id;
  int? montant;
  String? description;
  int? id_categorie;
  operation_sortir(this.montant, this.description, this.id_categorie);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['description'] = this.description;
    map['id_categorie'] = this.id_categorie;
    return map;
  }

  operation_sortir.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.description = map['description'];
    this.id_categorie = map['id_categorie'];
  }
}
