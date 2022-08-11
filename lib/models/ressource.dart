class ressource {
  int? id_ress;
  String? nom_ress;
  int? id_utilisateur;
  ressource(this.nom_ress, this.id_utilisateur);
  ressource.withId(this.id_ress, this.nom_ress, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id_ress'] = this.id_ress;
    map['nom_ress'] = this.nom_ress;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  ressource.getmap(Map<String, dynamic> map) {
    this.id_ress = map['id_ress'];
    this.nom_ress = map['nom_ress'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
