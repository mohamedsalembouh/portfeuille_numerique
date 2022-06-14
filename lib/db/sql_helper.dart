import 'package:flutter/services.dart';
import 'package:portfeuille_numerique/models/categorie.dart';
import 'package:portfeuille_numerique/models/compte.dart';
import 'package:portfeuille_numerique/models/operation_entree.dart';
import 'package:portfeuille_numerique/models/operation_sortir.dart';
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
        "create table categorie(id INTEGER PRIMARY KEY AUTOINCREMENT,nom TEXT,type TEXT)");
    await db.execute(
        "create table operation_entree(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,id_categorie INTEGER,foreign key(id_categorie) references categorie(id))");
    await db.execute(
        "create table operation_sortir(id INTEGER PRIMARY KEY AUTOINCREMENT,montant INTEGER,description TEXT,id_categorie INTEGER,foreign key(id_categorie) references categorie(id))");
    await db.execute(
        "create table objectif(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,montant_cible integer not null,montant_donnee integer not null)");
    await db.execute(
        "create table dettes(id INTEGER PRIMARY KEY AUTOINCREMENT,type text not null,description text not null,date_debut text not null,date_fin text not null)");
    await db.execute(
        "create table budget(id INTEGER PRIMARY KEY AUTOINCREMENT,nom text not null,duree text not null,montant text not null,id_categorie integer ,foreign key(id_categorie) references categorie(id))");
    await db.execute(
        "create table compte(id INTEGER PRIMARY KEY AUTOINCREMENT,solde int not null ,id_utilisateur integer ,foreign key(id_utilisateur) references utilisateur(id))");
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

  Future<compte?> getCompteUser(int idutilisateur) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM compte WHERE id  ='$idutilisateur'");
    if (result.length > 0) {
      return new compte.getmap(result.first);
    }
    return null;
  }

  Future<int> update_compte(compte comp) async {
    Database db = await this.database;
    var result = await db.rawUpdate("UPDATE compte SET solde = ? WHERE id = ?",
        [comp.solde, comp.id_utilisateur]);
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
        maps[i]['nom'],
        maps[i]['type'],
      );
    });
  }

  Future<categorie?> getSpecifyCategorie(String nom) async {
    Database db = await this.database;
    var result =
        await db.rawQuery("SELECT * FROM categorie WHERE nom  ='$nom'");
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

  Future<List<operation_sortir>> getAllDepenses() async {
    Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM operation_sortir");

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return operation_sortir(
          maps[i]['montant'], maps[i]['description'], maps[i]['id_categorie']);
    });
  }
}
