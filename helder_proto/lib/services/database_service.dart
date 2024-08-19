import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _letterTableName = 'letter';
  final String _letterIdColumnName = 'id';
  final String _letterContentColumnName = 'content';
  final String _letterSimplifiedContentColumnName = 'simplifiedContent';
  final String _letterKindColumnName = 'kind';

  final String _invoiceTableName = 'invoice';
  final String _invoiceIdColumnName = 'id';
  final String _invoiceLetterColumnName = 'letterId';
  final String _invoiceAmountColumnName = 'amount';
  final String _invoiceIsPaymentDueColumnName = 'isPaymentDue';
  final String _invoicePaymentReferenceColumnName = 'paymentReference';
  final String _invoicePaymentDeadlineColumnName = 'paymentDeadline';

  Future<Database> get database async {
    if(_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) => {
        db.execute('''
          CREATE TABLE $_letterTableName (
            $_letterIdColumnName INTEGER PRIMARY KEY,
            $_letterContentColumnName TEXT NOT NULL,
            $_letterSimplifiedContentColumnName TEXT NOT NULL,
            $_letterKindColumnName TEXT NOT NULL
          );

          CREATE TABLE $_invoiceTableName (
            $_invoiceIdColumnName INTEGER PRIMARY KEY,
            $_invoiceLetterColumnName INTEGER NOT NULL,
            $_invoiceAmountColumnName NUM NOT NULL,
            $_invoiceIsPaymentDueColumnName INTEGER NOT NULL,
            $_invoicePaymentReferenceColumnName TEXT,
            $_invoicePaymentDeadlineColumnName TEXT,

            FOREIGN KEY($_invoiceLetterColumnName) REFERENCES $_letterTableName($_letterIdColumnName)
          );
        ''')
      }
    );

    return database;
  }
}