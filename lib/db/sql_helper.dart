import 'package:flutter/services.dart';
import 'package:portfeuille_numerique/models/argent.dart';
import 'package:portfeuille_numerique/models/budgete.dart';
import 'package:portfeuille_numerique/models/catBudget.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/depensesCats.dart';
import 'package:portfeuille_numerique/models/emprunte_dette.dart';
import 'package:portfeuille_numerique/models/objective.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
import 'package:portfeuille_numerique/models/prette_dette.dart';
import 'package:portfeuille_numerique/models/utilisateur.dart';
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
        "create table compte(id INTEGER PRIMARY KEY AUTOINCREMENT,solde int not null,type TEXT not null,date TEXT not null ,id_utilisateur integer ,foreign key(id_utilisateur) references utilisateur(id))");
    await db.execute(
        "create table categorie(id INTEGER PRIMARY KEY AUTOINCREMENT,nomcat TEXT,coleur TEXT)");
    await db.execute(
        "create table operation_entree(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,date TEXT not null,type_compte TEXT not null ,id_categorie INTEGER,id_compte INTEGER,foreign key(id_categorie) references categorie(id),foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table operation_sortir(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,date TEXT not null,type_compte TEXT not null ,id_categorie INTEGER,id_compte INTEGER,foreign key(id_categorie) references categorie(id),foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table prette_dettes(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,objectif text not null,montant integer not null ,date TEXT not null,date_debut text not null,date_echeance text not null,status INTEGER not null,type_compte TEXT not null , id_compte INTEGER not null, foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table emprunte_dettes(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,objectif text not null,montant integer not null ,date TEXT not null,date_debut text not null,date_echeance text not null,status INTEGER not null,type_compte TEXT not null , id_compte INTEGER not null, foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table budget(id INTEGER PRIMARY KEY AUTOINCREMENT,nombdg text not null, montant integer not null,date_debut text not null,date_fin text not null,status INTEGER not null,id_categorie integer ,id_compte integer ,foreign key(id_categorie) references categorie(id),foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table objectif(id INTEGER PRIMARY KEY AUTOINCREMENT,nom_objective text not null,montant_cible integer not null,montant_donnee integer not null,date TEXT not null,id_compte integer not null,foreign key(id_compte) references compte(id))");
    await db.execute(
        "create table argent(id INTEGER PRIMARY KEY AUTOINCREMENT,montant integer not null,date TEXT not null,type TEXT not null,id_compte integer not null,foreign key(id_compte) references compte(id))");
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

  Future<int> insert_compte(compte cmp) async {
    Database db = await this.database;
    var result = db.insert("compte", cmp.tomap());

    return result;
  }

  // Future<int> delete_compte(int id_user) async {
  //   Database db = await this.database;
  //   var result =
  //       await db.delete("delete from compte where id_utilisateur='$id_user'");
  //   return result;
  // }

  Future<compte?> getCompteUser(int idutilisateur, String typeCmp) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM compte WHERE id_utilisateur  ='$idutilisateur' AND type = '$typeCmp'");
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
      return compte(maps[i]['solde'], maps[i]['type'], maps[i]['date'],
          maps[i]['id_utilisateur']);
    });
  }

  Future<int> update_compte(compte comp) async {
    Database db = await this.database;
    var result = await db.rawUpdate(
        "UPDATE compte SET solde = ? , date = ? WHERE id_utilisateur = ? AND type = ?",
        [comp.solde, comp.date, comp.id_utilisateur, comp.type]);
    return result;
  }

  Future<int> insert_categorie(categorie cat) async {
    Database db = await this.database;
    var result = db.insert("categorie", cat.tomap());
    return result;
  }

  // readData(String sql) async {
  //   Database? db = await database;
  //   List<Map> response = await db.rawQuery(sql);
  //   return response;
  // }

  Future<List<categorie>> getAllcategories() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM categorie");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return categorie(
        maps[i]['nomcat'],
        maps[i]['coleur'],
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

  Future<List<operation_entree>> getAllRevenus(int idCompte) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM operation_entree WHERE id_compte = $idCompte");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return operation_entree(
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_comte'],
          maps[i]['id_categorie'],
          maps[i]['id_compte']);
    });
  }

  Future<List<operation_sortir>> getAllDepenses(int idCompte) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery("SELECT * FROM operation_sortir WHERE id_compte = $idCompte");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return operation_sortir(
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_compte'],
          maps[i]['id_categorie'],
          maps[i]['id_compte']);
    });
  }

  Future<List<depensesCats>> getAllRevenusCats(int idCompte) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_entree,categorie WHERE operation_entree.id_categorie = categorie.id AND id_compte = $idCompte");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_compte'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getAllDepensesCats(int idCompte) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND id_compte = $idCompte");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_compte'],
          maps[i]['id_categorie'],
          maps[i]['nomcat'],
          maps[i]['coleur']);
    });
  }

  Future<List<depensesCats>> getSpecifiedDepenses(
      int idCompte, String nomCat) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND id_compte = $idCompte AND categorie.nomcat='$nomCat'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_compte'],
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

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM prette_dettes WHERE id_compte = $id");

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
        maps[i]['type_compte'],
        maps[i]['id_compte'],
      );
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
        .rawQuery("SELECT * FROM emprunte_dettes WHERE id_compte = $id");

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
        maps[i]['type_compte'],
        maps[i]['id_compte'],
      );
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
        "SELECT budget.id,budget.nombdg,budget.montant,budget.status,budget.date_debut,budget.date_fin,budget.id_categorie,categorie.nomcat FROM budget,categorie WHERE budget.id_categorie = categorie.id AND id_compte = $id");
    return List.generate(maps.length, (i) {
      return catBudget(
        maps[i]['id'],
        maps[i]['nombdg'],
        maps[i]['montant'],
        maps[i]['status'],
        maps[i]['date_debut'],
        maps[i]['date_fin'],
        maps[i]['id_categorie'],
        maps[i]['nomcat'],
      );
    });
  }

  Future<List<catBudget>> getAllSpecifiedBudgets(
      int idCompte, String nomCat) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT budget.id,budget.nombdg,budget.montant,budget.status,budget.date_debut,budget.date_fin FROM budget,categorie WHERE budget.id_categorie = categorie.id AND id_compte = $idCompte AND categorie.nomcat='$nomCat'");
    return List.generate(maps.length, (i) {
      return catBudget.second(
        maps[i]['id'],
        maps[i]['nombdg'],
        maps[i]['montant'],
        maps[i]['status'],
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
        await db.rawQuery("SELECT * FROM objectif WHERE  id_compte = $id");
    return List.generate(maps.length, (i) {
      return objective.withId(
        maps[i]['id'],
        maps[i]['nom_objective'],
        maps[i]['montant_cible'],
        maps[i]['montant_donnee'],
        maps[i]['date'],
        maps[i]['id_compte'],
      );
    });
  }

  Future<objective?> getSpecifyObjectif(int idobj, int idCompte) async {
    Database db = await this.database;
    var result = await db.rawQuery(
        "SELECT * FROM objectif WHERE id =$idobj AND id_compte = $idCompte");
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

  Future<int> deleteObjective(int id, int id_cmp) async {
    Database db = await this.database;
    var result = await db
        .rawDelete("DELETE FROM objectif WHERE id=$id AND id_compte = $id_cmp");
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
      String nomCat, int idCompte) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM operation_sortir,categorie WHERE operation_sortir.id_categorie = categorie.id AND categorie.nomcat='$nomCat' AND id_compte = '$idCompte'");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return depensesCats(
          maps[i]['id'],
          maps[i]['montant'],
          maps[i]['description'],
          maps[i]['date'],
          maps[i]['type_compte'],
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

  Future<List<argent>> getAllArgent(String type, int id) async {
    Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM argent WHERE type = '$type' AND id_compte = '$id'");
    return List.generate(maps.length, (i) {
      return argent(
        maps[i]['montant'],
        maps[i]['date'],
        maps[i]['type'],
        maps[i]['id_compte'],
      );
    });
  }
}
