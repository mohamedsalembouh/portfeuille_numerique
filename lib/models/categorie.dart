import 'package:flutter/cupertino.dart';

class categorie {
  int? id;
  String? nomcat;
  String? coleur;
  int? id_utilisateur;

  categorie(this.nomcat, this.coleur, this.id_utilisateur);
  categorie.withId(this.id, this.nomcat, this.coleur, this.id_utilisateur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nomcat'] = this.nomcat;
    map['coleur'] = this.coleur;
    map['id_utilisateur'] = this.id_utilisateur;
    return map;
  }

  categorie.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nomcat = map['nomcat'];
    this.coleur = map['coleur'];
    this.id_utilisateur = map['id_utilisateur'];
  }
}
