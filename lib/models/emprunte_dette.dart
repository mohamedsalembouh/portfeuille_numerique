class emprunte_dette {
  int? id;
  String? nom;
  String? objectif;
  int? montant;
  String? date_debut;
  String? date_echeance;
  int? id_compte;

  emprunte_dette(this.nom, this.objectif, this.montant, this.date_debut,
      this.date_echeance, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom'] = this.nom;
    map['objectif'] = this.objectif;
    map['montant'] = this.montant;
    map['date_debut'] = this.date_debut;
    map['date_echeance'] = this.date_echeance;
    map['id_compte'] = this.id_compte;
    return map;
  }

  emprunte_dette.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    map['nom'] = this.nom;
    this.objectif = map['objectif'];
    this.montant = map['montant'];
    this.date_debut = map['date_debut'];
    this.date_echeance = map['date_echeance'];
    this.id_compte = map['id_compte'];
  }
}
