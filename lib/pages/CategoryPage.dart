import 'package:contact/Helper/DbHelper.dart';
import 'package:contact/models/Category.dart';
import 'package:contact/pages/AddCategory.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:toast/toast.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  DbHelper _dbHelper = DbHelper();
  int count = 0;
  List<Category> categoryList;
  CategoryPageState() {
    print("ini category page");
    updateListCategory();
  }

  void addCategory(Category category) async {
    int result = await _dbHelper.insertCategory(category);
    if (result > 0) {
      print("berhasil menambah category");
      Toast.show("berhasil menambah category", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListCategory();
    }
  }

  void updateCategory(Category category) async {
    int result = await _dbHelper.updateCategory(category);
    if (result > 0) {
      print("berhasil update category");
      Toast.show("berhasil update category", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListCategory();
    }
  }

  void deleteCategory(Category category) async {
    int result = await _dbHelper.deleteCategory(category.id);
    if (result > 0) {
      print("berhasil menghapus category");
      Toast.show("berhasil menghapus category", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      updateListCategory();
    }
  }

  void updateListCategory() {
    final Future<Database> dbFuture = _dbHelper.initDb();
    dbFuture.then((database) {
      Future<List<Category>> categoryListFuture = _dbHelper.getCategoryList();
      categoryListFuture.then((categoryList) {
        setState(() {
          this.categoryList = categoryList;
          this.count = categoryList.length;
        });
      });
    });
  }

  Future<Category> navigateToEntryForm(
      BuildContext context, Category category) async {
    Category result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return AddCategory(category);
    }));
    return result;
  }

  showAlert(BuildContext context, Category category) {
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
                deleteCategory(category);
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

  @override
  Widget build(BuildContext context) {
    if (categoryList == null) {
      categoryList = List<Category>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(categoryList[index].category),
                trailing: Wrap(
                  spacing: 20, // space between two icons
                  children: <Widget>[
                    GestureDetector(
                        child: Icon(Icons.edit),
                        onTap: () async {
                          var category = await navigateToEntryForm(
                              context, categoryList[index]);
                          if (category != null) updateCategory(category);
                        }), // icon-2
                    GestureDetector(
                        child: Icon(Icons.delete),
                        onTap: () {
                          showAlert(context, categoryList[index]);
                        }), // icon-2
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var category = await navigateToEntryForm(context, null);
          if (category != null) addCategory(category);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
