import 'package:helder_proto/models/helder_invoice.dart';
import 'package:helder_proto/models/helder_letter.dart';
import 'package:helder_proto/utils/constants/enums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  final String _letterTableName = 'letter';
  final String _letterIdColumnName = 'id';
  final String _letterContentColumnName = 'content';
  final String _letterSenderColumnName = 'sender';
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
            $_letterSenderColumnName TEXT NOT NULL,
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

  Future<int> _addLetter(HelderLetter letter) async {
    final db = await database;
    int id = await db.insert(
      _letterTableName, 
      {
        _letterContentColumnName: letter.content,
        _letterSenderColumnName: letter.sender,
        _letterSimplifiedContentColumnName: letter.simplifiedContent,
        _letterKindColumnName: letter.kind.name
      }
    );

    return id;
  }

  Future<List<HelderLetter>> getLetters() async {
    final db = await database;
    final letterData = await db.query(_letterTableName);

    List<HelderLetter> letters = letterData.map((e) => 
        HelderLetter(
          content: e[_letterContentColumnName] as String, 
          sender: e[_letterSenderColumnName] as String, 
          simplifiedContent: e[_letterSimplifiedContentColumnName] as String, 
          kind: LetterKind.values.byName(e[_letterKindColumnName] as String) 
        )).toList();

    return letters;
  }
  
  Future<HelderLetter> getLetter(int letterId) async {
    final db = await database;
    final letterData = await db.query(
      _letterIdColumnName, 
      distinct: true,
      where: '"$_letterIdColumnName" = ?',
      whereArgs: [letterId]
    );
    if (letterData.isNotEmpty) {
      return HelderLetter.fromMap(letterData.first);
    }

    return HelderLetter.empty();
  }

  Future<int> addInvoice(HelderInvoice helderInvoice) async {
    final db = await database;
    int letterId = await _addLetter(helderInvoice.letter);

    int id = await db.insert(
      _invoiceTableName,
      {
        _invoiceLetterColumnName: letterId,
        _invoiceAmountColumnName: helderInvoice.amount,
        _invoiceIsPaymentDueColumnName: helderInvoice.isPaymentDue,
        _invoicePaymentReferenceColumnName: helderInvoice.paymentReference,
        _invoicePaymentDeadlineColumnName: helderInvoice.paymentDeadline.toIso8601String(),
      }
    );

    return id;
  }

  Future<List<HelderInvoice>> getInvoices() async {
    final db = await database;
    final invoiceData = await db.query(_invoiceTableName);

    List<HelderInvoice> invoices = await Future.wait(
      invoiceData.map(
        (e) async => await HelderInvoice.fromMap(e),
      ),
    );

    return invoices;
  }

  Future<HelderInvoice> getInvoice(int invoiceId) async {
    final db = await database;
    final invoiceData = await db.query(
      _invoiceTableName, 
      distinct: true,
      where: '"$_invoiceIdColumnName" = ?',
      whereArgs: [invoiceId]
    );
    if (invoiceData.isNotEmpty) {
      return HelderInvoice.fromMap(invoiceData.first);
    }

    return HelderInvoice.empty();
  }
}