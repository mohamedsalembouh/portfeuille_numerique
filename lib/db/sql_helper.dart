import 'package:flutter/services.dart';
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/compteRessource.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/partag.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/ressource.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
import 'package:portfeuille_numerique/partageGroupe.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SQL_Helper {
  static SQL_Helper? dbHelper;
  static Database? _database;

  SQL_Helper._createInstant();

  factory SQL_Helper() {
    if (dbHelper == null) {
      dbHelper = SQL_Helper._createInstant();
    }

    return dbHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialiseDataBase();
    }
    return _database!;
  }

  Future<Database> initialiseDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "portfeuille_numerique.db";
    // var dbpath = await getDatabasesPath();
    // String path = dbpath + "portfeuille.db";
    Future<Database> our_db =
        openDatabase(path, version: 1, onCreate: createDataBase);
    return our_db;
    // var exists = await databaseExists(path);
    // if (!exists) {
    //   try {
    //     await Directory(path).create(recursive: true);
    //   } catch (_) {}
    //   ByteData data = await rootBundle.load("assets" + "portfeuille.db");
    //   List<int> bytes =
    //       data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //   await File(path).writeAsBytes(bytes, flush: true);
    // } else {}
  }

  //var table_user = "utilisateur";
  //String table_users = "utilisateurs";
  void createDataBase(Database db, int version) async {
    await db.execute(
        "CREATE TABLE utilisateur(id INTEGER PRIMARY KEY AUTOINCREMENT,nom TEXT,email TEXT,password TEXT)");
    await db.execute(
        "create table compte(id INTEGER PRIMARY KEY AUTOINCREMENT,solde int not null,date TEXT not null ,id_ressource INTEGER not null,id_utilisateur integer ,foreign key(id_ressource) references ressource(id_ress),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table categorie(id INTEGER PRIMARY KEY AUTOINCREMENT,nomcat TEXT,coleur TEXT,id_utilisateur INTEGER, foreign key(id_utilisateur) references utilisateur(id) )");
    await db.execute(
        "create table operation_entree(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,date TEXT not null,id_categorie INTEGER,id_compte INTEGER,id_utilisateur INTEGER,foreign key(id_categorie) references categorie(id),foreign key(id_compte) references compte(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table operation_sortir(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,date TEXT not null,id_categorie INTEGER,id_compte INTEGER,id_utilisateur INTEGER,foreign key(id_categorie) references categorie(id),foreign key(id_compte) references compte(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table prette_dettes(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,objectif text not null,montant integer not null ,date TEXT not null,date_debut text not null,date_echeance text not null,status INTEGER not null,status_notification INTEGER not null,id_compte INTEGER not null,id_utilisateur INTEGER not null, foreign key(id_compte) references compte(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table emprunte_dettes(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,objectif text not null,montant integer not null ,date TEXT not null,date_debut text not null,date_echeance text not null,status INTEGER not null,status_notification INTEGER not null,id_compte INTEGER not null,id_utilisateur INTEGER not null, foreign key(id_compte) references compte(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table budget(id INTEGER PRIMARY KEY AUTOINCREMENT,nombdg text not null, montant integer not null,date_debut text not null,date_fin text not null,status INTEGER not null,status_notification INTEGER not null,id_categorie integer ,id_utilisateur integer ,foreign key(id_categorie) references categorie(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table objectif(id INTEGER PRIMARY KEY AUTOINCREMENT,nom_objective text not null,montant_cible integer not null,montant_donnee integer not null,date TEXT not null,status_notification INTEGER not null,id_compte integer not null,id_utilisateur INTEGER not null,foreign key(id_compte) references compte(id),foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table argent(id INTEGER PRIMARY KEY AUTOINCREMENT,montant integer not null,date TEXT not null,id_ressource INTEGER not null,id_utilisateur integer not null,foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table ressource(id_ress INTEGER PRIMARY KEY AUTOINCREMENT,nom_ress TEXT not null,id_utilisateur INTEGER not null,foreign key(id_utilisateur) references utilisateur(id))");
    // await db.execute(
    //     "create table groupe(id_groupe INTEGER PRIMARY KEY AUTOINCREMENT,nom_groupe TEXT not null,id_utilisateur INTEGER not null,foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table partage(id INTEGER PRIMARY KEY AUTOINCREMENT,email_personne TEXT not null,email_utilisateur TEXT not null, id_utilisateur INTEGER not null,foreign key(id_utilisateur) references utilisateur(id))");
  }

  Future<int> insert_user(utilisateur user) async {
    Database db = await this.database;
    var result = db.insert("utilisateur", user.tomap());
    return result;
  }

  Future<utilisateur?> getUser(String mail, String pass) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM utilisateur WHERE email='$mail' AND password = '$pass'");
    if (result.length > 0) {
      return new utilisateur.getmap(result.first);
    }
    return null;
  }

  Future<utilisateur?> getUserByEmail(String mail) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM utilisateur WHERE email='$mail' ");
    if (result.length > 0) {
      return new utilisateur.getmap(result.first);
    }
    return null;
  }

  Future<utilisateur?> getUserByID(int idUser) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM utilisateur WHERE id='$idUser' ");
    if (result.length > 0) {
      return new utilisateur.getmap(result.first);
    }
    return null;
  }

  Future<int> update_password(String pass, int idUser) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE utilisateur SET password = ?  WHERE id = ? ", [pass, idUser]);
    return result;
  }

  Future<int> update_nom(String name, int idUser) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE utilisateur SET nom = ?  WHERE id = ? ", [name, idUser]);
    return result;
  }

  Future<int> insert_compte(compte cmp) async {
    Database db = await this.database;
    var result = db.insert("compte", cmp.tomap());

    return result;
  }

  Future<compte?> getCompteUser(int idutilisateur, int id_res) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM compte WHERE id_utilisateur  ='$idutilisateur' AND id_ressource = '$id_res'");
    if (result.length > 0) {
      return new compte.getmap(result.first);
    }
    return null;
  }

  Future<compte?> getCompteUserById(int idCmp, int idutilisateur) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM compte WHERE id = '$idCmp' AND id_utilisateur  ='$idutilisateur' ");
    if (result.length > 0) {
      return new compte.getmap(result.first);
    }
    return null;
  }

  Future<List<compte>> getAllComptesUser(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM compte WHERE id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return compte(maps[i]['solde'], maps[i]['date'], maps[i]['id_ressource'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<int> update_compte(compte comp) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE compte SET solde = ? , date = ? WHERE id_utilisateur = ? AND id_ressource = ?",
        [comp.solde, comp.date, comp.id_utilisateur, comp.id_ressource]);
    return result;
  }

  Future<int> insert_categorie(categorie cat) async {
    Database db = await this.database;
    var result = db.insert("categorie", cat.tomap());
    return result;
  }

  Future<categorie?> getCategorieeByNom(String nom, int idUser) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM categorie WHERE nomcat = '$nom' AND id_utilisateur = '$idUser'");
    if (result.length > 0) {
      return new categorie.getmap(result.first);
    }
    return null;
  }

  // Future<categorie?> getCategorieeByColor(String coleur) async {
  //   Database db = await this.database;
  //   var result =
  //       await db.rawQuery("SELECT * FROM categorie WHERE coleur = '$coleur'");
  //   if (result.length > 0) {
  //     return new categorie.getmap(result.first);
  //   }
  //   return null;
  // }

  Future<List<categorie>> getAllcategories(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM categorie WHERE id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return categorie(
        maps[i]['nomcat'],
        maps[i]['coleur'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<categorie?> getSpecifyCategorie(String nom) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM categorie WHERE nomcat  ='$nom'");
    if (result.length > 0) {
      return new categorie.getmap(result.first);
    }
    return null;
  }

  Future<categorie?> getSpecifyCategorie2(int id) async {
    Database db = await this.database;
    var result = await db.rawQuery("SELECT * FROM categorie WHERE id  ='$id'");
    if (result.length > 0) {
      return new categorie.getmap(result.first);
    }
    return null;
  }

  Future<int> insertOperationEntree(operation_entree entree) async {
    Database db = await this.database;
    var result = db.insert("operation_entree", entree.tomap());
    return result;
  }

  Future<int> insertOperationSortir(operation_sortir sortir) async {
    Database db = await this.database;
    var result = db.insert("operation_sortir", sortir.tomap());
    return result;
  }

  Future<List<operation_entree>> getAllRevenus(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree WHERE id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return operation_entree(
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['id_compte'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<List<operation_sortir>> getAllDepenses(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir WHERE id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return operation_sortir(
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['id_compte'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND operation_entree.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats1(
      int idCompte, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND id_compte = '$idCompte'  AND operation_entree.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats2(
      String debut, String fin, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND date > '$debut' AND date < '$fin' AND operation_entree.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats3(
      String debut, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND date > '$debut'  AND operation_entree.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats4(String fin, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND  date < '$fin' AND operation_entree.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  // je veux effacer apres modifier detailstatistique
  Future<List<depensesCats>> getAllRevenusrecherche(
      String debut, String fin, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id  AND date > '$debut' AND date < '$fin' AND operation_entree.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyRevenusCats(
      int idCompte, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND id_compte = '$idCompte' AND operation_entree.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }
  /////////////////////////////

  Future<List<depensesCats>> getSpecifyRevenusrecherche(
      String debut, String fin, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id  AND date > '$debut' AND date < '$fin' AND id_compte = '$idCmp' AND operation_entree.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyRevenusrecherche2(
      String debut, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id  AND date > '$debut'  AND id_compte = '$idCmp' AND operation_entree.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyRevenusrecherche3(
      String fin, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id  AND date < '$fin' AND id_compte = '$idCmp' AND operation_entree.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllDepensesCats(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats.withCompte(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['id_compte'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyRechercheDepenses(
      String debut, String fin, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND date > '$debut' AND date < '$fin'AND id_compte = '$idCmp' AND operation_sortir.id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyDepensesCats(
      int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND operation_sortir.id_compte = '$idCmp' AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyDepensesCats2(
      String debut, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND date > '$debut' AND operation_sortir.id_compte = '$idCmp' AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifyDepensesCats3(
      String fin, int idCmp, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND date < '$fin' AND operation_sortir.id_compte = '$idCmp' AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getRechercheDepenses(
      String debut, String fin, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND date > '$debut' AND date < '$fin' AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getRechercheDepenses2(
      String debut, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND date > '$debut' AND  operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getRechercheDepenses3(
      String fin, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id  AND date < '$fin' AND operation_sortir.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifiedDepenses(
      int idUser, String nomCat) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND operation_sortir.id_utilisateur = '$idUser' AND categorie.nomcat='$nomCat'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<int> insert_pretteDatte(prette_dette prette) async {
    Database db = await this.database;
    var result = db.insert("prette_dettes", prette.tomap());
    return result;
  }

  Future<List<prette_dette>> getAllPrettesDettes(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM prette_dettes WHERE id_utilisateur = $id");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return prette_dette.withId(
          maps[i]['id'],
          maps[i]['nom'],
          maps[i]['objectif'],
          maps[i]['montant'],
          maps[i]['date'],
          maps[i]['date_debut'],
          maps[i]['date_echeance'],
          maps[i]['status'],
          maps[i]['status_notification'],
          maps[i]['id_compte'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<int> insert_EmprunteDatte(emprunte_dette emprunte) async {
    Database db = await this.database;
    var result = db.insert("emprunte_dettes", emprunte.tomap());
    return result;
  }

  Future<List<emprunte_dette>> getAllEmprunteDettes(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM emprunte_dettes WHERE id_utilisateur = $id");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return emprunte_dette.withId(
          maps[i]['id'],
          maps[i]['nom'],
          maps[i]['objectif'],
          maps[i]['montant'],
          maps[i]['date'],
          maps[i]['date_debut'],
          maps[i]['date_echeance'],
          maps[i]['status'],
          maps[i]['status_notification'],
          maps[i]['id_compte'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<int> insert_Budget(budgete bdg) async {
    Database db = await this.database;
    var result = db.insert("budget", bdg.tomap());
    return result;
  }

  Future<List<catBudget>> getAllBudgets(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT budget.id,budget.nombdg,budget.montant,budget.status,budget.date_debut,budget.date_fin,budget.id_categorie,categorie.nomcat FROM budget,categorie WHERE budget.id_categorie = categorie.id AND budget.id_utilisateur = $id");
    return List.generate(maps.length, (i) {
      return catBudget(
        maps[i]['id'],
        maps[i]['nombdg'],
        maps[i]['montant'],
        maps[i]['status'],
        maps[i]['status_notification'],
        maps[i]['date_debut'],
        maps[i]['date_fin'],
        maps[i]['id_categorie'],
        maps[i]['nomcat'],
      );
    });
  }

  Future<List<catBudget>> getsomesBudgets(int id, String date) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT budget.id,budget.nombdg,budget.montant,budget.status,budget.date_debut,budget.date_fin,budget.id_categorie,categorie.nomcat FROM budget,categorie WHERE budget.id_categorie = categorie.id AND date_debut < '$date' AND date_fin > '$date' AND id_utilisateur = $id");
    return List.generate(maps.length, (i) {
      return catBudget(
        maps[i]['id'],
        maps[i]['nombdg'],
        maps[i]['montant'],
        maps[i]['status'],
        maps[i]['status_notification'],
        maps[i]['date_debut'],
        maps[i]['date_fin'],
        maps[i]['id_categorie'],
        maps[i]['nomcat'],
      );
    });
  }

  Future<List<catBudget>> getAllSpecifiedBudgets(
      int idUser, String nomCat) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT budget.id,budget.nombdg,budget.montant,budget.status,budget.status_notification,budget.date_debut,budget.date_fin FROM budget,categorie WHERE budget.id_categorie = categorie.id AND budget.id_utilisateur = '$idUser' AND categorie.nomcat='$nomCat'");
    return List.generate(maps.length, (i) {
      return catBudget.second(
        maps[i]['id'],
        maps[i]['nombdg'],
        maps[i]['montant'],
        maps[i]['status'],
        maps[i]['status_notification'],
        maps[i]['date_debut'],
        maps[i]['date_fin'],
      );
    });
  }

  Future<int> insert_objectif(objective obj) async {
    Database db = await this.database;
    var result = db.insert("objectif", obj.tomap());
    return result;
  }

  Future<List<objective>> getAllObjectivfs(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM objectif WHERE  id_utilisateur = $id");
    return List.generate(maps.length, (i) {
      return objective.withId(
        maps[i]['id'],
        maps[i]['nom_objective'],
        maps[i]['montant_cible'],
        maps[i]['montant_donnee'],
        maps[i]['date'],
        maps[i]['status_notification'],
        maps[i]['id_compte'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<List<objective>> getSomeObjectivfs(int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM objectif WHERE montant_cible = montant_donnee AND id_utilisateur = $id");
    return List.generate(maps.length, (i) {
      return objective.withId(
        maps[i]['id'],
        maps[i]['nom_objective'],
        maps[i]['montant_cible'],
        maps[i]['montant_donnee'],
        maps[i]['date'],
        maps[i]['status_notification'],
        maps[i]['id_compte'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<objective?> getSpecifyObjectif(int idobj, int idUser) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM objectif WHERE id =$idobj AND id_utilisateur = $idUser");
    if (result.length > 0) {
      return new objective.getmap(result.first);
    }
    return null;
  }

  Future<int> update_objective(objective obj) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE objectif SET montant_donnee = ? WHERE id = ?",
        [obj.montant_donnee, obj.id]);
    return result;
  }

  Future<int> deleteObjective(int id, int id_user) async {
    Database db = await this.database;
    var result = await db.rawDelete(
        "DELETE FROM objectif WHERE id=$id AND id_utilisateur = '$id_user'");
    return result;
  }

  Future<int> update_pretteDette(int id) async {
    Database db = await this.database;
    var result = await db
        .rawUpdate("UPDATE prette_dettes SET status = ? WHERE id = ?", [1, id]);
    return result;
  }

  Future<int> update_EmprunteDette(int id) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE emprunte_dettes SET status = ? WHERE id = ?", [1, id]);
    return result;
  }

  Future<int> deletePreteDette(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete("DELETE FROM prette_dettes WHERE id=?", [id]);
    return result;
  }

  Future<int> deleteEmprunteDette(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete("DELETE FROM emprunte_dettes WHERE id=?", [id]);
    return result;
  }

  Future<int> update_budget(int id) async {
    Database db = await this.database;
    var result = await db
        .rawUpdate("UPDATE budget SET status = ? WHERE id = ?", [1, id]);
    return result;
  }

  Future<int> deleteBudget(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete("DELETE FROM budget WHERE id=?", [id]);
    return result;
  }

  Future<List<depensesCats>> getAllSpecifyDepense(
      String nomCat, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND categorie.nomcat='$nomCat' AND id_utilisateur = '$idUser'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<int> insert_argent(argent arg) async {
    Database db = await this.database;
    var result = db.insert("argent", arg.tomap());
    return result;
  }

  Future<List<argent>> getAllArgentSpecifyCompte(
      int idRessource, int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM argent WHERE id_ressource = '$idRessource' AND id_utilisateur = '$idUser'");
    return List.generate(maps.length, (i) {
      return argent(
        maps[i]['montant'],
        maps[i]['date'],
        maps[i]['id_ressource'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<List<argent>> getAllArgent(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM argent WHERE id_utilisateur = '$idUser'");
    return List.generate(maps.length, (i) {
      return argent(
        maps[i]['montant'],
        maps[i]['date'],
        maps[i]['id_ressource'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<int> insertRessource(ressource res) async {
    Database db = await this.database;
    var result = db.insert("ressource", res.tomap());
    return result;
  }

  Future<ressource?> getSpecifyRessource(String nom) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM ressource WHERE nom_ress = '$nom'");
    if (result.length > 0) {
      return new ressource.getmap(result.first);
    }
    return null;
  }

  Future<ressource?> getSpecifyRessource2(int idres) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM ressource WHERE id_ress = '$idres'");
    if (result.length > 0) {
      return new ressource.getmap(result.first);
    }
    return null;
  }

  Future<compte?> getSpecifyCompte(int idRes) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM compte WHERE id_ressource = '$idRes'");
    if (result.length > 0) {
      return new compte.getmap(result.first);
    }
    return null;
  }

  Future<List<compteRessource>> getAllCompteRessource(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM compte,ressource WHERE compte.id_ressource = ressource.id_ress AND compte.id_utilisateur = $idUser");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return compteRessource(maps[i]['id'], maps[i]['solde'], maps[i]['date'],
          maps[i]['id_ress'], maps[i]['nom_ress'], maps[i]['id_utilisateur']);
    });
  }

  Future<ressource?> getRessourceByNom(String nom) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM ressource WHERE nom_ress = '$nom'");
    if (result.length > 0) {
      return new ressource.getmap(result.first);
    }
    return null;
  }

  Future<List<ressource>> getAllRessource(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM ressource WHERE id_utilisateur = '$idUser'");
    return List.generate(maps.length, (i) {
      return ressource.withId(
        maps[i]['id_ress'],
        maps[i]['nom_ress'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<int> insert_partage(partag prt) async {
    Database db = await this.database;
    var result = db.insert("partage", prt.tomap());
    return result;
  }

  Future<List<partag>> getAllPartag(int idUser) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM partage WHERE id_utilisateur = '$idUser'");
    return List.generate(maps.length, (i) {
      return partag.withId(
        maps[i]['id'],
        maps[i]['email_personne'],
        maps[i]['email_utilisateur'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<List<partag>> getAllPartag2(String email) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM partage WHERE email_personne = '$email'");
    return List.generate(maps.length, (i) {
      return partag.withId(
        maps[i]['id'],
        maps[i]['email_personne'],
        maps[i]['email_utilisateur'],
        maps[i]['id_utilisateur'],
      );
    });
  }

  Future<int> updateStatusNotificationPretteDette(int x, int id) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE prette_dettes SET status_notification = ? WHERE id = ?",
        [x, id]);
    return result;
  }

  Future<int> updateStatusNotificationEmprunteDette(int x, int id) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE emprunte_dettes SET status_notification = ? WHERE id = ?",
        [x, id]);
    return result;
  }

  Future<int> updateStatusNotificationBudget(int x, int id) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE budget SET status_notification = ? WHERE id = ?", [x, id]);
    return result;
  }

  Future<int> updateStatusNotificationObjectif(int x, int id) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE objectif SET status_notification = ? WHERE id = ?", [x, id]);
    return result;
  }
}
