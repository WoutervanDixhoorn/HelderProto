import 'package:helder_proto/models/helder_invoice_data.dart';
import 'package:helder_proto/models/helder_allowance_data.dart';
import 'package:helder_proto/models/helder_letter_data.dart';
import 'package:helder_proto/models/helder_tax_data.dart';
import 'package:helder_proto/models/helder_text_info_data.dart';
import 'package:helder_proto/utils/constants/enums.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();


  final String _textInfoTableName = 'TextInfo';
  final String _textInfoIdColumnName = 'Id';
  final String _textInfoContentColumnName = 'Content';
  final String _textInfoSimplifiedContentColumnName = 'SimplifiedContent';
  final String _textInfoSenderColumnName = 'Sender';
  final String _textInfoSubjectColumnName = 'Subject';

  final String _letterTableName = 'Letter';
  final String _letterIdColumnName = 'Id';
  final String _letterTextInfoIdColumnName = 'TextInfoId';

  final String _invoiceTableName = 'Invoice';
  final String _invoiceIdColumnName = 'Id';
  final String _invoiceTextInfoIdColumnName = 'TextInfoId';
  final String _invoiceInvoiceKindColumnName = 'SpecificKind';
  final String _invoiceAmountColumnName = 'Amount';
  final String _invoicePaymentDeadlineColumnName = 'PaymentDeadline';
  final String _invoiceIsPayedDateColumnName = 'IsPayedDate';
  final String _invoiceIsPayedColumnName = 'IsPayed';

  final String _taxTableName = 'Tax';
  final String _taxIdColumnName = 'Id';
  final String _taxTextInfoIdColumnName = 'TextInfoId';
  final String _taxTaxKindColumnName = 'SpecificKind';
  final String _taxAmountColumnName = 'Amount';
  final String _taxPaymentDeadlineColumnName = 'PaymentDeadline';
  final String _taxIsPayedDateColumnName = 'IsPayedDate';
  final String _taxIsPayedColumnName = 'IsPayed';

  final String _allowanceTableName = 'Allowance';
  final String _allowanceIdColumnName = 'Id';
  final String _allowanceTextInfoIdColumnName = 'TextInfoId';
  final String _allowanceAllowanceKindColumnName = 'SpecificKind';
  final String _allowanceAmountColumnName = 'Amount';
  final String _allowanceStartDateColumnName = 'StartDate';
  final String _allowanceEndDateColumnName = 'EndDate';

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
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_textInfoTableName (
            $_textInfoIdColumnName INTEGER PRIMARY KEY,
            $_textInfoContentColumnName TEXT NOT NULL,
            $_textInfoSimplifiedContentColumnName TEXT NOT NULL,
            $_textInfoSenderColumnName TEXT NOT NULL,
            $_textInfoSubjectColumnName TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE $_letterTableName (
            $_letterIdColumnName INTEGER PRIMARY KEY,
            $_letterTextInfoIdColumnName INTEGER NOT NULL,

            FOREIGN KEY ($_letterTextInfoIdColumnName) REFERENCES $_textInfoTableName ($_textInfoIdColumnName)
          );
        ''');

        await db.execute('''
          CREATE TABLE $_invoiceTableName (
            $_invoiceIdColumnName INTEGER PRIMARY KEY,
            $_invoiceTextInfoIdColumnName INTEGER NOT NULL,
            $_invoiceInvoiceKindColumnName TEXT NOT NULL,
            $_invoiceAmountColumnName NUM NOT NULL,
            $_invoicePaymentDeadlineColumnName TEXT NOT NULL,
            $_invoiceIsPayedDateColumnName TEXT,
            $_invoiceIsPayedColumnName INTEGER NOT NULL,

            FOREIGN KEY ($_invoiceTextInfoIdColumnName) REFERENCES $_textInfoTableName ($_textInfoIdColumnName)
          );
        ''');

        await db.execute('''
          CREATE TABLE $_taxTableName (
            $_taxIdColumnName INTEGER PRIMARY KEY,
            $_taxTextInfoIdColumnName INTEGER NOT NULL,
            $_taxTaxKindColumnName TEXT NOT NULL,
            $_taxAmountColumnName NUM NOT NULL,
            $_taxPaymentDeadlineColumnName TEXT NOT NULL,
            $_taxIsPayedDateColumnName TEXT,
            $_taxIsPayedColumnName INTEGER NOT NULL,

            FOREIGN KEY ($_taxTextInfoIdColumnName) REFERENCES $_textInfoTableName ($_textInfoIdColumnName)
          );
        ''');

        await db.execute('''
          CREATE TABLE $_allowanceTableName (
            $_allowanceIdColumnName INTEGER PRIMARY KEY,
            $_allowanceTextInfoIdColumnName INTEGER NOT NULL,
            $_allowanceAllowanceKindColumnName TEXT NOT NULL,
            $_allowanceAmountColumnName NUM NOT NULL,
            $_allowanceStartDateColumnName TEXT NOT NULL,
            $_allowanceEndDateColumnName TEXT NOT NULL,

            FOREIGN KEY ($_allowanceTextInfoIdColumnName) REFERENCES $_textInfoTableName ($_textInfoIdColumnName)
          );
        ''');
      }
    );

    return database;
  }

  Future<void> deleteDatabase(String path) =>
    databaseFactory.deleteDatabase(path);

  //Text Info
  Future<int> _addTextInfo(TextInfo textInfo) async {
    final db = await database;
    return await db.insert(
      _textInfoTableName, 
      textInfo.toMap()
    );
  }

  Future<List<TextInfo>> getTextInfos() async {
    final db = await database;
    final textInfoData = await db.query(_textInfoTableName);

    return textInfoData.map((e) => TextInfo.fromMap(e)).toList();
  }

  Future<TextInfo> getTextInfo(int textInfoId) async {
    final db = await database;
    final textInfoData = await db.query(
      _textInfoTableName, 
      where: '"$_textInfoIdColumnName" = ?',
      whereArgs: [textInfoId]
    );
    
    if (textInfoData.isNotEmpty) {
      return TextInfo.fromMap(textInfoData.first);
    }
    
    return TextInfo.empty();
  }

  //Letter
  Future<int> addLetter(HelderLetter letter) async {
    final db = await database;

    int textInfoId = await _addTextInfo(letter.textInfo);

    return await db.insert(
      _letterTableName,
      {
        _letterTextInfoIdColumnName: textInfoId,
      },
    );
  }

  Future<List<HelderLetter>> getLetters() async {
    final db = await database;
    final letterData = await db.query(_letterTableName);

    List<HelderLetter> letters = [];

    for (var letter in letterData) {
      int textInfoId = letter[_letterTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      letters.add(
        HelderLetter(
          textInfo: textInfo,
          kind: LetterKind.values.byName(letter['kind'] as String? ?? 'regular'),
        ),
      );
    }

    return letters;
  }

  Future<HelderLetter> getLetter(int letterId) async {
    final db = await database;
    final letterData = await db.query(
      _letterTableName,
      where: '"$_letterIdColumnName" = ?',
      whereArgs: [letterId],
    );

    if (letterData.isNotEmpty) {
      final letter = letterData.first;

      // Retrieve the TextInfo for the letter
      int textInfoId = letter[_letterTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      return HelderLetter(
        textInfo: textInfo,
        kind: LetterKind.values.byName(letter['kind'] as String? ?? 'regular'),
      );
    }

    return HelderLetter.empty();
  }
  
  //Invoice
  Future<int> addInvoice(HelderInvoice invoice) async {
    final db = await database;

    int textInfoId = await _addTextInfo(invoice.textInfo);

    return await db.insert(
      _invoiceTableName,
      {
        _invoiceTextInfoIdColumnName: textInfoId,
        _invoiceInvoiceKindColumnName: invoice.kind.name,
        _invoiceAmountColumnName: invoice.amount,
        _invoicePaymentDeadlineColumnName: invoice.paymentDeadline.toIso8601String(),
        _invoiceIsPayedDateColumnName: invoice.isPayedDate?.toIso8601String() ?? '',
        _invoiceIsPayedColumnName: invoice.isPayed ? 1 : 0,
      },
    );
  }

  Future<List<HelderInvoice>> getInvoices() async {
    final db = await database;
    final invoiceData = await db.query(_invoiceTableName);

    List<HelderInvoice> invoices = [];

    for (var invoice in invoiceData) {
      int textInfoId = invoice[_invoiceTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      invoices.add(
        HelderInvoice.fromMap(invoice, textInfo)
      );
    }

    return invoices;
  }

  Future<HelderInvoice> getInvoice(int invoiceId) async {
    final db = await database;
    final invoiceData = await db.query(
      _invoiceTableName,
      where: '"$_invoiceIdColumnName" = ?',
      whereArgs: [invoiceId],
    );

    if (invoiceData.isNotEmpty) {
      final invoice = invoiceData.first;

      int textInfoId = invoice[_invoiceTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      return HelderInvoice.fromMap(invoice, textInfo);
    }

    return HelderInvoice.empty();
  }

  Future<int> updateInvoice(HelderInvoice invoice) async {
    final db = await database;

    await db.update(
      _textInfoTableName,
      invoice.textInfo.toMap(),
      where: '$_textInfoIdColumnName = ?',
      whereArgs: [invoice.textInfo.id],
    );

    return await db.update(
      _invoiceTableName,
      {
        _invoiceInvoiceKindColumnName: invoice.kind.name,
        _invoiceAmountColumnName: invoice.amount,
        _invoicePaymentDeadlineColumnName: invoice.paymentDeadline.toIso8601String(),
        _invoiceIsPayedDateColumnName: invoice.isPayedDate!.toIso8601String(),
        _invoiceIsPayedColumnName: invoice.isPayed ? 1 : 0,
      },
      where: '$_invoiceIdColumnName = ?',
      whereArgs: [invoice.id],
    );
  }

  //Tax
  Future<int> addTax(HelderTax tax) async {
    final db = await database;

    int textInfoId = await _addTextInfo(tax.textInfo);

    return await db.insert(
      _taxTableName,
      {
        _taxTextInfoIdColumnName: textInfoId,
        _taxTaxKindColumnName: tax.kind.name,
        _taxAmountColumnName: tax.amount,
        _taxPaymentDeadlineColumnName: tax.paymentDeadline.toIso8601String(),
        _taxIsPayedDateColumnName: tax.isPayedDate?.toIso8601String() ?? '',
        _taxIsPayedColumnName: tax.isPayed ? 1 : 0,
      },
    );
  }

  Future<List<HelderTax>> getTaxes() async {
    final db = await database;
    final taxData = await db.query(_taxTableName);

    List<HelderTax> taxes = [];

    for (var tax in taxData) {
      int textInfoId = tax[_taxTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      taxes.add(
        HelderTax.fromMap(tax, textInfo)
      );
    }

    return taxes;
  }

  Future<HelderTax> getTax(int taxId) async {
    final db = await database;
    final taxData = await db.query(
      _taxTableName,
      where: '"$_taxIdColumnName" = ?',
      whereArgs: [taxId],
    );

    if (taxData.isNotEmpty) {
      final tax = taxData.first;

      int textInfoId = tax[_taxTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      return HelderTax.fromMap(tax, textInfo);
    }

    return HelderTax.empty();
  }

  Future<int> updateTax(HelderTax tax) async {
    final db = await database;

    await db.update(
      _textInfoTableName,
      tax.textInfo.toMap(),
      where: '$_textInfoIdColumnName = ?',
      whereArgs: [tax.textInfo.id],
    );

    return await db.update(
      _taxTableName,
      {
        _taxTaxKindColumnName: tax.kind.name,
        _taxAmountColumnName: tax.amount,
        _taxPaymentDeadlineColumnName: tax.paymentDeadline.toIso8601String(),
        _invoiceIsPayedDateColumnName: tax.isPayedDate!.toIso8601String(),
        _taxIsPayedColumnName: tax.isPayed ? 1 : 0,
      },
      where: '$_taxIdColumnName = ?',
      whereArgs: [tax.id],
    );
  }

  //Allowance
  Future<int> addAllowance(HelderAllowance allowance) async {
    final db = await database;
    int textInfoId = await _addTextInfo(allowance.textInfo);

    return await db.insert(
      _allowanceTableName,
      {
        _allowanceTextInfoIdColumnName: textInfoId,
        _allowanceAllowanceKindColumnName: allowance.kind.name,
        _allowanceAmountColumnName: allowance.amount,
        _allowanceStartDateColumnName: allowance.startDate.toIso8601String(),
        _allowanceEndDateColumnName: allowance.endDate.toIso8601String(),
      },
    );
  }

  Future<List<HelderAllowance>> getAllowances() async {
    final db = await database;
    final allowanceData = await db.query(_allowanceTableName);

    List<HelderAllowance> allowances = [];

    for (var allowance in allowanceData) {
      int textInfoId = allowance[_allowanceTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      allowances.add(
        HelderAllowance.fromMap(allowance, textInfo),
      );
    }

    return allowances;
  }

  Future<HelderAllowance> getAllowance(int allowanceId) async {
    final db = await database;
    final allowanceData = await db.query(
      _allowanceTableName,
      where: '"$_allowanceIdColumnName" = ?',
      whereArgs: [allowanceId],
    );

    if (allowanceData.isNotEmpty) {
      final allowance = allowanceData.first;

      int textInfoId = allowance[_allowanceTextInfoIdColumnName] as int;
      TextInfo textInfo = await getTextInfo(textInfoId);

      return HelderAllowance.fromMap(allowance, textInfo);
    }

    return HelderAllowance.empty();
  }

  Future<int> updateAllowance(HelderAllowance allowance) async {
    final db = await database;

    await db.update(
      _textInfoTableName,
      allowance.textInfo.toMap(),
      where: '$_textInfoIdColumnName = ?',
      whereArgs: [allowance.textInfo.id],
    );

    return await db.update(
      _allowanceTableName,
      {
        _allowanceAllowanceKindColumnName: allowance.kind.name,
        _allowanceAmountColumnName: allowance.amount,
        _allowanceStartDateColumnName: allowance.startDate.toIso8601String(),
        _allowanceEndDateColumnName: allowance.endDate.toIso8601String(),
      },
      where: '$_allowanceIdColumnName = ?',
      whereArgs: [allowance.id],
    );
  }

}