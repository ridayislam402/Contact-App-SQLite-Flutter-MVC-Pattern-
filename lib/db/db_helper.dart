import 'package:contect_app_flutter/model/contact_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
class DbHelper{
  static const String createTableContact = '''create table $tblContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColDob text,
  $tblContactColImage text,
  $tblContactColFavorate integer)''';

  static Future<Database> open() async{
    final rootPath = await getDatabasesPath(); // file location adding
    final dbPath = Path.join(rootPath, 'content.db'); //database name
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async{ //onCreate call one time just first time
        await db.execute(createTableContact); //sql query execute single or multiple
    });
  }

  static Future<int> insert(ContactModel contactModel) async{ // return int for row id
    final db = await open();
    return db.insert(tblContact, contactModel.toMap());
  }

  static Future<List<ContactModel>> getAll() async{
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }
  
  static Future<ContactModel> getById(int? id) async{
    final db = await open();
    final List<Map<String, dynamic>> mapList = await db.query(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  static Future<int> deleteById(int? id) async{
    final db = await open();
    return db.delete(tblContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  static Future<int> updateById(int? id, String column, dynamic value) async{
    final db = await open();
    return db.update(tblContact,{column : value}, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}