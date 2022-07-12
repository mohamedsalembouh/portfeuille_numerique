class catBudget {
  int? id;
  String? nombdg;
  int? montant;
  String? date_debut;
  String? date_fin;
  int? id_categorie;
  String? nomcat;

  catBudget(this.nombdg, this.montant, this.date_debut, this.date_fin,
      this.id_categorie, this.nomcat);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['nom'] = this.nombdg;
    map['montant'] = this.montant;
    map['date_debut'] = this.date_debut;
    map['date_fin'] = this.date_fin;
    map['id_categorie'] = this.id_categorie;
    map['nomcat'] = this.nomcat;
    return map;
  }

  catBudget.getmap(Map<String, dynamic> map) {
    this.nombdg = map['nombdg'];
    this.montant = map['montant'];
    this.date_debut = map['date_debut'];
    this.date_fin = map['date_fin'];
    this.id_categorie = map['id_categorie'];
    this.nomcat = map['nomcat'];
  }
}
