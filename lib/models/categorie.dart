import 'package:flutter/cupertino.dart';

class categorie {
  int? id;
  String? nomcat;
  String? coleur;

  categorie(this.nomcat, this.coleur);
  categorie.withId(this.id, this.nomcat, this.coleur);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['nomcat'] = this.nomcat;
    map['coleur'] = this.coleur;
    return map;
  }

  categorie.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.nomcat = map['nomcat'];
    this.coleur = map['coleur'];
  }
}
