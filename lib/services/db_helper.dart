import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/article.dart';
import '../models/location.dart';
import '../models/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();
  factory DBHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Upgrade logic here
    }
  }

  Future<Database?> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'inventory.db');

    _database = await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            code TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            password TEXT,
            createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
            role TEXT DEFAULT 'user'
          )
        ''');

        await db.execute('''
          CREATE TABLE articles (
            code TEXT PRIMARY KEY,
            name TEXT,
            quantity INTEGER DEFAULT 0,
            description TEXT,
            condition TEXT,
            category TEXT,
            location TEXT,
            createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
            updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
            agentCode TEXT,
            FOREIGN KEY (agentCode) REFERENCES users(code)
          )
        ''');

        await db.execute('''
          CREATE TABLE locations (
            code TEXT PRIMARY KEY,
            name TEXT,
            occupation TEXT,
            type TEXT,
            description TEXT,
            createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
            updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
            agentCode TEXT,
            FOREIGN KEY (agentCode) REFERENCES users(code)
          )
        ''');
      },
      onUpgrade: _onUpgrade,
    );

    if (_database == null) {
      throw Exception('Failed to initialize the database');
    } else {
      return _database;
    }
  }

  // === User Methods ===
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers({String? role}) async {
    final db = await database;

    final maps = await db.query(
      'users',
      where: role != null ? 'role = ?' : null,
      whereArgs: role != null ? [role] : null,
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> getUsersCount({String? role}) async {
    final db = await database;

    final maps = await db.query(
      'users',
      columns: ['COUNT(*) as count'],
      where: role != null ? 'role = ?' : null,
      whereArgs: role != null ? [role] : null,
    );
    return Sqflite.firstIntValue(maps) ?? 0;
  }

  Future<List<User>> getUsersPaginated({
    required int limit,
    required int offset,
    String? role,
  }) async {
    final db = await database;

    final maps = await db.query(
      'users',
      limit: limit,
      offset: offset,
      orderBy: 'createdAt DESC',
      where: role != null ? 'role = ?' : null,
      whereArgs: role != null ? [role] : null,
    );
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<User?> getUserByCode(String code) async {
    final db = await database;
    if (code.isEmpty) return null; // Handle empty code case
    final maps = await db.query('users', where: 'code = ?', whereArgs: [code]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'code = ?',
      whereArgs: [user.code],
    );
  }

  Future<void> deleteUser(String code) async {
    final db = await database;
    await db.delete('users', where: 'code = ?', whereArgs: [code]);
  }

  // === Article Methods ===
  Future<void> insertArticle(Article article) async {
    final db = await database;

    await db.insert(
      'articles',
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Article>> getArticles({
    String? code,
    String? agentCode,
    String? category,
    String? location,
  }) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];
    if (code != null) {
      where += '${where.isEmpty ? '' : ' AND '}code = ?';
      whereArgs.add(code);
    }
    if (agentCode != null) {
      where += '${where.isEmpty ? '' : ' AND '}agentCode = ?';
      whereArgs.add(agentCode);
    }
    if (category != null) {
      where += '${where.isEmpty ? '' : ' AND '}category = ?';
      whereArgs.add(category);
    }
    if (location != null) {
      where += '${where.isEmpty ? '' : ' AND '}location = ?';
      whereArgs.add(location);
    }
    final maps = await db.query(
      'articles',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
    return List.generate(maps.length, (i) => Article.fromMap(maps[i]));
  }

  Future<List<Article>> getArticlesPaginated({
    required int limit,
    required int offset,
  }) async {
    final db = await database;
    final maps = await db.query(
      'articles',
      limit: limit,
      offset: offset,
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Article.fromMap(maps[i]));
  }

  Future<int> getArticlesCount({
    String? agentCode,
    String? category,
    String? location,
  }) async {
    final db = await database;

    // بناء جملة WHERE وشروطها حسب المعطيات
    String where = '';
    List<dynamic> whereArgs = [];

    if (agentCode != null) {
      where += '${where.isEmpty ? '' : ' AND '}agentCode = ?';
      whereArgs.add(agentCode);
    }
    if (category != null) {
      where += '${where.isEmpty ? '' : ' AND '}category = ?';
      whereArgs.add(category);
    }
    if (location != null) {
      where += '${where.isEmpty ? '' : ' AND '}location = ?';
      whereArgs.add(location);
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM articles ${where.isNotEmpty ? 'WHERE $where' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Article?> getArticleByCode(String code) async {
    final db = await database;
    final maps = await db.query(
      'articles',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isNotEmpty) {
      return Article.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateArticle(Article article) async {
    final db = await database;
    await db.update(
      'articles',
      article.toMap(),
      where: 'code = ?',
      whereArgs: [article.code],
    );
  }

  Future<void> deleteArticle(String code) async {
    final db = await database;
    await db.delete('articles', where: 'code = ?', whereArgs: [code]);
  }

  // === Location Methods ===
  Future<void> insertLocation(Location location) async {
    final db = await database;
    await db.insert(
      'locations',
      location.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Location>> getLocations({String? code, String? agentCode}) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];
    if (code != null) {
      where += '${where.isEmpty ? '' : ' AND '}code = ?';
      whereArgs.add(code);
    }
    if (agentCode != null) {
      where += '${where.isEmpty ? '' : ' AND '}agentCode = ?';
      whereArgs.add(agentCode);
    }
    final maps = await db.query(
      'locations',
      where: where.isNotEmpty ? where : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );
    return List.generate(maps.length, (i) => Location.fromMap(maps[i]));
  }

  Future<List<Location>> getLocationsPaginated({
    String? agentCode,
    required int limit,
    required int offset,
  }) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (agentCode != null) {
      where += '${where.isEmpty ? '' : ' AND '}agentCode = ?';
      whereArgs.add(agentCode);
    }

    final maps = await db.query(
      'locations',
      limit: limit,
      offset: offset,
      orderBy: 'createdAt DESC',
    );
    return List.generate(maps.length, (i) => Location.fromMap(maps[i]));
  }

  Future<int> getLocationsCount({String? agentCode}) async {
    final db = await database;
    String where = '';
    List<dynamic> whereArgs = [];

    if (agentCode != null) {
      where += '${where.isEmpty ? '' : ' AND '}agentCode = ?';
      whereArgs.add(agentCode);
    }
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM locations ${where.isNotEmpty ? 'WHERE $where' : ''}',
      whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Location?> getLocationByCode(String code) async {
    final db = await database;
    final maps = await db.query(
      'locations',
      where: 'code = ?',
      whereArgs: [code],
    );
    if (maps.isNotEmpty) {
      return Location.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updateLocation(Location location) async {
    final db = await database;
    await db.update(
      'locations',
      location.toMap(),
      where: 'code = ?',
      whereArgs: [location.code],
    );
  }

  Future<void> deleteLocation(String code) async {
    final db = await database;
    await db.delete('locations', where: 'code = ?', whereArgs: [code]);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null; // Reset the database instance
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.execute('DELETE FROM users');
    await db.execute('DELETE FROM articles');
    await db.execute('DELETE FROM locations');
    // Add other tables as needed
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS users');
    await db.execute('DROP TABLE IF EXISTS articles');
    await db.execute('DROP TABLE IF EXISTS locations');
    // Add other tables as needed
    _database = null; // Reset the database instance
    await _initDB(); // Reinitialize the database
  }

  Future<void> deleteAllArticles({String? agentCode}) async {
    final db = await database;
    await db.delete(
      'articles',
      where: agentCode != null ? 'agentCode = ?' : null,
      whereArgs: agentCode != null ? [agentCode] : null,
    );
  }

  Future<void> deleteAllLocations({String? agentCode}) async {
    final db = await database;
    await db.delete(
      'locations',
      where: agentCode != null ? 'agentCode = ?' : null,
      whereArgs: agentCode != null ? [agentCode] : null,
    );
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    await db.delete('users');
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('users');
      await txn.delete('articles');
      await txn.delete('locations');
    });
  }

  // ... الكود السابق ...

  Future<void> generateDummyData() async {
    final admins = await getUsers(role: 'admin');
    await clearDatabase();

    final random = Random();

    for (int i = 0; i < 5 + random.nextInt(10); i++) {
      User agent = User(
        code: 'agent${i + 1}',
        name: 'Agent ${i + 1}',
        description: 'Description for Agent ${i + 1}',
        password: 'password${i + 1}',
        role: 'agent',
      );
      await insertUser(agent);
    }
    // creating admin :
    if (admins.isNotEmpty) await insertUser(admins[0]);
    // توليد 10 مواقع (locations) عامة - ليتم مشاركتها بين الوكلاء

    // سنوزع المواقع على الوكلاء - كل وكيل يملك 10 مواقع (يمكن مشاركة المواقع بين وكلاء)

    for (int i = 1; i <= 20 + random.nextInt(10); i++) {
      final agents = await getUsers(role: 'agent');
      // أنشئ نسخة من الموقع مع إضافة agentCode الحالي
      Location newLoc = Location(
        code: 'loc$i',
        name: 'Location $i',
        occupation: 'Occupation $i',
        type: 'Type $i',
        description: 'Description for location $i',
        agentCode: agents[random.nextInt(agents.length)].code,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await insertLocation(newLoc);
    }

    // توليد 30 مادة لكل موقع ولكل وكيل
    // المواد أيضاً يمكن أن تكون مشتركة بين الوكلاء لنفس الموقع (نفس الكود لكن agentCode مختلف)
    for (int i = 1; i <= 400 + random.nextInt(100); i++) {
      final locs = await getLocations();
      final loc = locs[random.nextInt((locs).length)];
      final artCode = 'art_${loc.code}_$i';
      Article article = Article(
        code: artCode,
        name: 'Article $i at ${loc.name}',
        quantity: random.nextInt(50) + 1,
        description: 'Description of article $i at ${loc.name}',
        condition: [
          'New',
          'Good',
          'Working',
          'Needs Repair',
          'Broken',
        ][random.nextInt(5)],
        category: 'Category ${(i % 5) + 1}',
        location: loc.code,
        agentCode: loc.agentCode,
      );
      await insertArticle(article);
    }
  }
}
