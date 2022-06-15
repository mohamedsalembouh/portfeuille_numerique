import 'package:flutter/cupertino.dart';

class categorie {
  int? id;
  String? nom;
  String? coleur;

  categorie(this.nom, this.coleur);
  categorie.withId(this.id, this.nom, this.coleur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nom'] = this.nom;
    map['coleur'] = this.coleur;
    return map;
  }

  categorie.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nom = map['nom'];
    this.coleur = map['coleur'];
  }
}
