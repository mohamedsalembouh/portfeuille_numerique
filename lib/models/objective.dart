class objective {
  int? id;
  String? nom_objective;
  int? montant_cible;
  int? montant_donnee;
  //String? type_compte;
  int? id_compte;

  objective(this.nom_objective, this.montant_cible, this.montant_donnee,
      this.id_compte);
  objective.withId(this.id, this.nom_objective, this.montant_cible,
      this.montant_donnee, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom_objective'] = this.nom_objective;
    map['montant_cible'] = this.montant_cible;
    map['montant_donnee'] = this.montant_donnee;
    // map['type_compte'] = this.type_compte;
    map['id_compte'] = this.id_compte;
    return map;
  }

  objective.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom_objective = map['nom_objective'];
    this.montant_cible = map['montant_cible'];
    this.montant_donnee = map['montant_donnee'];
    // this.type_compte = map['type_compte'];
    this.id_compte = map['id_compte'];
  }
}
