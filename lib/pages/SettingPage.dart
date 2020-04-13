import 'package:contact/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  final List<Category> categoryList;
  SettingPage(this.categoryList);
  @override
  State<StatefulWidget> createState() {
    return SettingPageState(categoryList);
  }
}

class SettingPageState extends State<SettingPage> {
  List<Category> categoryList;
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;
  SettingPageState(this.categoryList);
  SharedPreferences sp;

  @override
  void initState() {
    categoryList.insert(0, Category("None", id: 0));
    _dropdownMenuItems = buildDropdownMenuItems(categoryList);

    SharedPreferences.getInstance().then((val) {
      sp = val;
      if (sp.getInt('category') == null) {
        _selectedCategory = _dropdownMenuItems[0].value;
      } else {
        var getCategory = _dropdownMenuItems
            .firstWhere((val) => val.value.id == sp.getInt('category'));
        var getIndex = _dropdownMenuItems.indexOf(getCategory);
        print("index: $getIndex");
        _selectedCategory = _dropdownMenuItems[getIndex].value;
      }
      setState(() {});
    });

    super.initState();
  }

  List<DropdownMenuItem<Category>> buildDropdownMenuItems(
      List<Category> categories) {
    List<DropdownMenuItem<Category>> items = List();
    for (Category category in categories) {
      items.add(
        DropdownMenuItem(
          value: category,
          child: Text(category.category),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Category selectedCategory) {
    setState(() {
      _selectedCategory = selectedCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Wrap(
          spacing: 20,
          direction: Axis.vertical,
          children: <Widget>[
            Text("set Category Priority"),
            DropdownButton(
              value: _selectedCategory,
              items: _dropdownMenuItems,
              onChanged: onChangeDropdownItem,
            ),
            RaisedButton(
              child: Text("Set Priority"),
              onPressed: () {
                Navigator.pop(context, _selectedCategory.id);
              },
              color: Colors.blue,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
