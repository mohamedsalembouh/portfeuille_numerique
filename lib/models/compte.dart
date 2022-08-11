class compte {
  int? id;
  int? solde;
  String? date;
  int? id_ressource;
  int? id_utilisateur;
  compte(this.solde, this.date, this.id_ressource, this.id_utilisateur);
  compte.withId(
      this.id, this.solde, this.date, this.id_ressource, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['solde'] = this.solde;
    map['date'] = this.date;
    map['id_ressource'] = this.id_ressource;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  compte.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.solde = map['solde'];
    this.date = map['date'];
    this.id_ressource = map['id_ressource'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
