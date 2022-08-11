class partag {
  int? id;
  String? email_personne;
  String? email_utilisateur;
  int? id_utilisateur;

  partag(this.email_personne, this.email_utilisateur, this.id_utilisateur);
  partag.withId(this.id, this.email_personne, this.email_utilisateur,
      this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['email_personne'] = this.email_personne;
    map['email_utilisateur'] = this.email_utilisateur;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  partag.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.email_personne = map['email_personne'];
    this.email_utilisateur = map['email_utilisateur'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
