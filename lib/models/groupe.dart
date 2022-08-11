class groupe {
  int? id_groupe;
  String? nom_groupe;
  int? id_utilisateur;

  groupe(this.nom_groupe, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id_groupe'] = this.id_groupe;
    map['nom_groupe'] = this.nom_groupe;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  groupe.getmap(Map<String, dynamic> map) {
    this.id_groupe = map['id_groupe'];
    this.nom_groupe = map['nom_groupe'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
