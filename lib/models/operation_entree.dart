class operation_entree {
  int? id;
  int? montant;
  String? description;
  int? id_categorie;
  int? id_compte;
  operation_entree(
      this.montant, this.description, this.id_categorie, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['description'] = this.description;
    map['id_categorie'] = this.id_categorie;
    map['id_compte'] = this.id_compte;
    return map;
  }

  operation_entree.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.description = map['description'];
    this.id_categorie = map['id_categorie'];
    this.id_compte = map['id_compte'];
  }
}
