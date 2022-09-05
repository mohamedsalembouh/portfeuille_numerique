class objective {
  int? id;
  String? nom_objective;
  int? montant_cible;
  int? montant_donnee;
  String? date;
  int? status_notification;
  int? id_compte;
  int? id_utilisateur;

  objective(this.nom_objective, this.montant_cible, this.montant_donnee,
      this.date, this.status_notification, this.id_compte, this.id_utilisateur);
  objective.withId(
      this.id,
      this.nom_objective,
      this.montant_cible,
      this.montant_donnee,
      this.date,
      this.status_notification,
      this.id_compte,
      this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom_objective'] = this.nom_objective;
    map['montant_cible'] = this.montant_cible;
    map['montant_donnee'] = this.montant_donnee;
    map['date'] = this.date;
    map['status_notification'] = this.status_notification;
    map['id_compte'] = this.id_compte;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  objective.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom_objective = map['nom_objective'];
    this.montant_cible = map['montant_cible'];
    this.montant_donnee = map['montant_donnee'];
    this.date = map['date'];
    this.status_notification = map['status_notification'];
    this.id_compte = map['id_compte'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
