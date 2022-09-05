class catBudget {
  int? id;
  String? nombdg;
  int? montant;
  int? status;
  int? status_notification;
  String? date_debut;
  String? date_fin;
  int? id_categorie;
  String? nomcat;

  catBudget(
      this.id,
      this.nombdg,
      this.montant,
      this.status,
      this.status_notification,
      this.date_debut,
      this.date_fin,
      this.id_categorie,
      this.nomcat);
  catBudget.second(this.id, this.nombdg, this.montant, this.status,
      this.status_notification, this.date_debut, this.date_fin);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['nom'] = this.nombdg;
    map['montant'] = this.montant;
    map['status'] = this.status;
    map['status_notification'] = this.status_notification;
    map['date_debut'] = this.date_debut;
    map['date_fin'] = this.date_fin;
    map['id_categorie'] = this.id_categorie;
    map['nomcat'] = this.nomcat;
    return map;
  }

  catBudget.getmap(Map<String, dynamic> map) {
    this.nombdg = map['nombdg'];
    this.montant = map['montant'];
    this.status = map['status'];
    this.status_notification = map['status_notification'];
    this.date_debut = map['date_debut'];
    this.date_fin = map['date_fin'];
    this.id_categorie = map['id_categorie'];
    this.nomcat = map['nomcat'];
  }
}
