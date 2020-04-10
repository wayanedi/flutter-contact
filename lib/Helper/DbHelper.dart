import 'package:contact/models/Category.dart';
import 'package:contact/models/Contact.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    String fullpath = "";
    await getDatabasesPath().then((path) => fullpath = '$path/corona6.db');

    //create, read databases
    var todoDatabase = openDatabase(fullpath, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE category (id INTEGER PRIMARY KEY AUTOINCREMENT, name_category TEXT)");
    await db.execute(
        "CREATE TABLE contact (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT, phone TEXT, photo TEXT, prioritas INTEGER, id_category INTEGER)");
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> selectCategory() async {
    Database db = await this.database;
    var mapList = await db.query('category', orderBy: 'name_category');
    return mapList;
  }

  Future<List<Category>> getCategoryList() async {
    var categorytMapList = await selectCategory();
    int count = categorytMapList.length;
    List<Category> categorytList = List<Category>();
    for (int i = 0; i < count; i++) {
      categorytList.add(Category.fromMap(categorytMapList[i]));
    }
    return categorytList;
  }

  Future<int> deleteCategory(int id) async {
    Database db = await this.database;
    int count = await db.delete('category', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<int> updateCategory(Category object) async {
    Database db = await this.database;
    int count = await db.update('category', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  Future<int> insertCategory(Category object) async {
    Database db = await this.database;
    int count = await db.insert('category', object.toMap());
    return count;
  }

  Future<List<Map<String, dynamic>>> selectContact() async {
    Database db = await this.database;
    var mapList = await db.rawQuery(
        "SELECT contact.id, contact.name, contact.email, contact.phone, contact.photo, contact.prioritas, contact.id_category, category.name_category FROM contact INNER JOIN category ON contact.id_category = category.id ORDER BY prioritas DESC");
    //print(mapList.length);
    return mapList;
  }

  Future<int> insertContact(Contact object) async {
    Database db = await this.database;
    int count = await db.insert('contact', object.toMap());
    return count;
  }

  Future<List<Contact>> getContactList(int prioritas) async {
    var contactMapList = await selectContact();
    int count = contactMapList.length;
    List<Contact> contactList = List<Contact>();
    List<Contact> contactList2 = List<Contact>();
    for (int i = 0; i < count; i++) {
      if (contactMapList[i]['id_category'] != prioritas) {
        contactList2.add(Contact.fromMap(contactMapList[i]));
      } else {
        contactList.add(Contact.fromMap(contactMapList[i]));
      }
    }

    contactList2.sort();
    if (contactList.length > 0) contactList.sort();
    contactList.addAll(contactList2);
    return contactList;
  }

  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    int count = await db.delete('contact', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<int> updateContact(Contact object) async {
    Database db = await this.database;
    int count = await db.update('contact', object.toMap(),
        where: 'id=?', whereArgs: [object.id]);
    return count;
  }
}
