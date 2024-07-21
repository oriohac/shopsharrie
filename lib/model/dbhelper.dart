import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper instance = DBHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get a location using path_provider for Android and iOS
    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, 'orders.db');

    // Create the database
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT,
        quantity INTEGER,
        price REAL,
        order_date TEXT
      )
    ''');
  }

  Future<int> insertOrder(Map<String, dynamic> order) async {
    Database db = await instance.database;
    return await db.insert('orders', order);
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    Database db = await instance.database;
    return await db.query('orders');
  }

  Future<void> deleteOrder(int id) async {
    Database db = await instance.database;
    await db.delete('orders', where: 'id = ?', whereArgs: [id]);
  }
}
