import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../service/models/order/ResponseListOrdersModels.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'orders.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY,
        room_id INTEGER,
        code TEXT,
        name TEXT,
        status_rooms INTEGER,
        status_order TEXT,
        type TEXT,
        ip TEXT,
        secret TEXT,
        newest_order_start_time TEXT,
        newest_order_end_time TEXT
      )
    ''');
  }

  Future<void> insertOrder(NewestOrder order) async {
    final db = await database;
    await db.insert(
      'orders',
      order.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NewestOrder>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('orders');

    return List.generate(maps.length, (i) {
      return NewestOrder(
        roomId: maps[i]['room_id'],
        id: maps[i]['id'],
        code: maps[i]['code'],
        name: maps[i]['name'],
        statusRooms: maps[i]['status_rooms'],
        statusOrder: maps[i]['status_order'],
        type: maps[i]['type'],
        ip: maps[i]['ip'],
        secret: maps[i]['secret'],
        newestOrderStartTime: maps[i]['newest_order_start_time'],
        newestOrderEndTime: maps[i]['newest_order_end_time'],
      );
    });
  }

  Future<void> deleteOrders() async {
    final db = await database;
    await db.delete('orders');
  }

  Future<void> deleteOrderById(int id) async {
    final db = await database;
    await db.delete(
      'orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> saveJsonData(String jsonData) async {
    var data = jsonDecode(jsonData);
    if (data['status'] == true) {
      for (var orderData in data['data']) {
        NewestOrder order = NewestOrder(
          roomId: orderData['room_id'],
          id: orderData['id'],
          code: orderData['code'],
          name: orderData['name'],
          statusRooms: orderData['status_rooms'],
          statusOrder: orderData['status_order'],
          type: orderData['type'],
          ip: orderData['ip'],
          secret: orderData['secret'],
          newestOrderStartTime: orderData['newest_order_start_time'],
          newestOrderEndTime: orderData['newest_order_end_time'],
        );
        await insertOrder(order);
      }
    }
  }
}
