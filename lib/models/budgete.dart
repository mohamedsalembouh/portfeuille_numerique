class budgete {
  int? id;
  String? nombdg;
  int? montant;
  String? date_debut;
  String? date_fin;
  int? status;
  int? status_notification;
  int? id_categorie;
  int? id_utilisateur;

  budgete(
      this.nombdg,
      this.montant,
      this.date_debut,
      this.date_fin,
      this.status,
      this.status_notification,
      this.id_categorie,
      this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nombdg'] = this.nombdg;
    map['montant'] = this.montant;
    map['date_debut'] = this.date_debut;
    map['date_fin'] = this.date_fin;
    map['status'] = this.status;
    map['status_notification'] = this.status_notification;
    map['id_categorie'] = this.id_categorie;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  budgete.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nombdg = map['nombdg'];
    this.montant = map['montant'];
    this.date_debut = map['date_debut'];
    this.date_fin = map['date_fin'];
    this.status = map['status'];
    this.status_notification = map['status_notification'];
    this.id_categorie = map['id_categorie'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
