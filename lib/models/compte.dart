class compte {
  int? id;
  int? solde;
  String? type;
  int? id_utilisateur;
  compte(this.solde, this.type, this.id_utilisateur);
  compte.withId(this.id, this.solde, this.type, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['solde'] = this.solde;
    map['type'] = this.type;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  compte.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.solde = map['solde'];
    this.type = map['type'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
