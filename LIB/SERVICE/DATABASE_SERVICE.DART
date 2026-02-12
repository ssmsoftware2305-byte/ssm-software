import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'ssm.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
        CREATE TABLE companies(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          gst TEXT,
          fyStart TEXT
        )
        ''');

        await db.execute('''
        CREATE TABLE sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          invoiceNo TEXT,
          date TEXT,
          party TEXT,
          subtotal REAL,
          gst REAL,
          total REAL
        )
        ''');

        await db.execute('''
        CREATE TABLE ledger(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          voucher TEXT,
          debit REAL,
          credit REAL
        )
        ''');

      },
    );
  }
}
