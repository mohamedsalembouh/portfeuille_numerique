class budgete {
  int? id;
  String? nombdg;
  int? montant;
  String? date_debut;
  String? date_fin;
  int? status;
  int? id_categorie;
  int? id_compte;

  budgete(this.nombdg, this.montant, this.date_debut, this.date_fin,
      this.status, this.id_categorie, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nombdg'] = this.nombdg;
    map['montant'] = this.montant;
    map['date_debut'] = this.date_debut;
    map['date_fin'] = this.date_fin;
    map['status'] = this.status;
    map['id_categorie'] = this.id_categorie;
    map['id_compte'] = this.id_compte;
    return map;
  }

  budgete.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nombdg = map['nombdg'];
    this.montant = map['montant'];
    this.date_debut = map['date_debut'];
    this.date_fin = map['date_fin'];
    this.status = map['status'];
    this.id_categorie = map['id_categorie'];
    this.id_compte = map['id_compte'];
  }
}
