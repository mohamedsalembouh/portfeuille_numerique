class argent {
  int? id;
  int? montant;
  String? date;
  int? id_ressource;
  int? id_utilisateur;
  argent(this.montant, this.date, this.id_ressource, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['date'] = this.date;
    map['id_ressource'] = this.id_ressource;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  argent.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.date = map['date'];
    this.id_ressource = map['id_ressource'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
