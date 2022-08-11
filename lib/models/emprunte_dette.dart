class emprunte_dette {
  int? id;
  String? nom;
  String? objectif;
  int? montant;
  String? date;
  String? date_debut;
  String? date_echeance;
  int? status;
  int? id_compte;
  int? id_utilisateur;

  emprunte_dette(
      this.nom,
      this.objectif,
      this.montant,
      this.date,
      this.date_debut,
      this.date_echeance,
      this.status,
      this.id_compte,
      this.id_utilisateur);
  emprunte_dette.withId(
      this.id,
      this.nom,
      this.objectif,
      this.montant,
      this.date,
      this.date_debut,
      this.date_echeance,
      this.status,
      this.id_compte,
      this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom'] = this.nom;
    map['objectif'] = this.objectif;
    map['montant'] = this.montant;
    map['date'] = this.date;
    map['date_debut'] = this.date_debut;
    map['date_echeance'] = this.date_echeance;
    map['status'] = this.status;
    map['id_compte'] = this.id_compte;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  emprunte_dette.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    map['nom'] = this.nom;
    this.objectif = map['objectif'];
    this.montant = map['montant'];
    this.date = map['date'];
    this.date_debut = map['date_debut'];
    this.date_echeance = map['date_echeance'];
    this.status = map['status'];
    this.id_compte = map['id_compte'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
