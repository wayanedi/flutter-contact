import 'dart:io';
import 'package:contact/Helper/DbHelper.dart';
import 'package:contact/models/Category.dart';
import 'package:contact/models/Contact.dart';
import 'package:contact/pages/AddContact.dart';
import 'package:contact/pages/SettingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum WhyFarther { category, setting }

class _MyHomePageState extends State<MyHomePage> {
  DbHelper _dbHelper = DbHelper();
  SharedPreferences sp;
  int count = 0;
  int idPriority = 0;
  List<Contact> contactList;

  @override
  void initState() {
    SharedPreferences.getInstance().then((val) {
      sp = val;
      if (sp.getInt("category") != null)
        this.idPriority = sp.getInt("category");
      print(idPriority);
      updateListContact(idPriority);
      setState(() {});
    });
    super.initState();
  }

  void deleteContact(Contact contact) async {
    final dir = Directory(contact.photo);
    dir.deleteSync(recursive: true);
    int result = await _dbHelper.deleteContact(contact.id);
    if (result > 0) {
      print("berhasil menghapus kontak");
      Toast.show("berhasil menghapus kontak", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListContact(idPriority);
    }
  }

  void addContact(Contact contact) async {
    int result = await _dbHelper.insertContact(contact);
    if (result > 0) {
      print("berhasil menambah kontak");
      Toast.show("berhasil menambah kontak", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListContact(idPriority);
    }
  }

  void updateContact(Contact contact) async {
    int result = await _dbHelper.updateContact(contact);
    if (result > 0) {
      print("berhasil update kontak");
      Toast.show("berhasil update kontak", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListContact(idPriority);
    }
  }

  void updateListContact(int idPriority) {
    final Future<Database> dbFuture = _dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Contact>> contactListFuture =
          _dbHelper.getContactList(idPriority);
      contactListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
          //print(contactList.toString());
        });
      });
    });
  }

  Future<Contact> navigateToEntryForm(BuildContext context, Contact contact,
      List<Category> categoryList) async {
    Contact result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return AddContact(contact, categoryList);
    }));
    return result;
  }

  Future<int> navigateToSetting(
      BuildContext context, List<Category> categoryList) async {
    int result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return SettingPage(categoryList);
    }));
    return result;
  }

  showAlert(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text("Are You Sure Want To Proceed ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                //Put your code here which you want to execute on Yes button click.
                deleteContact(contact);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on No button click.
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void cekListSelect(WhyFarther select) async {
    switch (select) {
      case WhyFarther.category:
        Navigator.pushNamed(context, 'categoryPage');
        break;
      case WhyFarther.setting:
        List<Category> categoryList = await _dbHelper.getCategoryList();
        var id = await navigateToSetting(context, categoryList);
        if (id != null) {
          sp.setInt("category", id);
          this.idPriority = id;
          print(id);
          updateListContact(idPriority);
          setState(() {});
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) contactList = List<Contact>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        actions: <Widget>[
          PopupMenuButton<WhyFarther>(
            onSelected: (WhyFarther result) {
              cekListSelect(result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.category,
                child: ListTile(
                  title: Text("Category"),
                  leading: Icon(Icons.category),
                ),
              ),
              const PopupMenuItem<WhyFarther>(
                value: WhyFarther.setting,
                child: ListTile(
                  title: Text("Setting"),
                  leading: Icon(Icons.settings),
                ),
              ),
            ],
          )
        ],
      ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                leading: Image.file(
                  File(contactList[index].photo),
                  width: 50,
                ),
                title: Text(contactList[index].name),
                subtitle: Text(
                  contactList[index].nameCategory,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                trailing: Wrap(
                  spacing: 20, // space between two icons
                  children: <Widget>[
                    GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () async {
                          List<Category> categoryList =
                              await _dbHelper.getCategoryList();
                          var contact = await navigateToEntryForm(
                              context, contactList[index], categoryList);
                          if (contact != null) {
                            updateContact(contact);
                          }
                        }), // icon-2
                    GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          showAlert(context, contactList[index]);
                        }), // icon-2
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<Category> categoryList = await _dbHelper.getCategoryList();
          var contact = await navigateToEntryForm(context, null, categoryList);
          if (contact != null) {
            addContact(contact);
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
