class argent {
  int? id;
  int? montant;
  String? date;
  String? type;
  int? id_compte;
  argent(this.montant, this.date, this.type, this.id_compte);

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['montant'] = this.montant;
    map['date'] = this.date;
    map['type'] = this.type;
    map['id_compte'] = this.id_compte;
    return map;
  }

  argent.getmap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.montant = map['montant'];
    this.date = map['date'];
    this.type = map['type'];
    this.id_compte = map['id_compte'];
  }
}
