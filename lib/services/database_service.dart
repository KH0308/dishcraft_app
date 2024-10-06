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
      prefs.setString('token', json.decode(response.body)['token']);
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
