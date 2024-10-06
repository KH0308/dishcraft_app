// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sqflite/sqflite.dart';
// import '../models/recipe.dart';

// class DatabaseService {
//   final String baseUrl = 'https://reqres.in/api';
//   static Database? _database;
//   final _recipeController = StreamController<List<Recipe>>.broadcast();

//   Stream<List<Recipe>> get recipeStream => _recipeController.stream;

//   Future<Map<String, dynamic>> authSignIn(
//       String emailUser, String passwordUser) async {
//     final prefs = await SharedPreferences.getInstance();

//     final response = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'email': emailUser,
//         'password': passwordUser,
//       }),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       prefs.setString('user_token', json.decode(response.body)['token']);
//       debugPrint('Sign In successful');
//       return json.decode(response.body);
//     } else if (response.statusCode == 400) {
//       debugPrint('${json.decode(response.body)['error']}');
//       return json.decode(response.body);
//     } else {
//       throw Exception('Failed to sign in');
//     }
//   }

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB();
//     return _database!;
//   }

//   Future<Database> _initDB() async {
//     String path = join(await getDatabasesPath(), 'recipes.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           "CREATE TABLE recipes(id INTEGER PRIMARY KEY, name TEXT, type TEXT, image TEXT, ingredients TEXT, steps TEXT)",
//         );
//       },
//     );
//   }

//   Future<void> loadRecipes() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('recipes');
//     final recipes = List.generate(maps.length, (i) {
//       return Recipe.fromJson({
//         'id': maps[i]['id'],
//         'name': maps[i]['name'],
//         'type': maps[i]['type'],
//         'image': maps[i]['image'],
//         'ingredients': maps[i]['ingredients'].split(','),
//         'steps': maps[i]['steps'].split(','),
//       });
//     });
//     _recipeController.sink.add(recipes);
//   }

//   Future<void> insertRecipe(Recipe recipe) async {
//     final db = await database;
//     await db.insert(
//       'recipes',
//       recipe.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     await loadRecipes();
//   }

//   Future<void> updateRecipe(Recipe recipe) async {
//     final db = await database;
//     await db.update(
//       'recipes',
//       recipe.toJson(),
//       where: 'id = ?',
//       whereArgs: [recipe.id],
//     );
//     await loadRecipes();
//   }

//   Future<void> deleteRecipe(int id) async {
//     final db = await database;
//     await db.delete(
//       'recipes',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     await loadRecipes();
//   }

//   void dispose() {
//     _recipeController.close();
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import "package:http/http.dart" as http;

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  final String baseUrl = 'https://reqres.in/api';

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipe.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recipes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        imagePath TEXT,
        ingredients TEXT,
        steps TEXT
      )
    ''');
  }

  Future<Map<String, dynamic>> authSignIn(
      String emailUser, String passwordUser) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': emailUser,
        'password': passwordUser,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      prefs.setString('user_token', json.decode(response.body)['token']);
      debugPrint('Sign In successful');
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      debugPrint('${json.decode(response.body)['error']}');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<int> createRecipe(Map<String, dynamic> recipe) async {
    final db = await instance.database;
    return await db.insert('recipes', recipe);
  }

  Future<List<Map<String, dynamic>>> getRecipes() async {
    final db = await instance.database;
    return await db.query('recipes');
  }

  Future<int> updateRecipe(int id, Map<String, dynamic> recipe) async {
    final db = await instance.database;
    return await db.update(
      'recipes',
      recipe,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteRecipe(int id) async {
    final db = await instance.database;
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
