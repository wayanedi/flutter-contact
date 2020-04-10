import 'package:contact/models/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCategory extends StatefulWidget {
  final Category category;
  AddCategory(this.category);
  @override
  State<StatefulWidget> createState() {
    return AddCategoryState(this.category);
  }
}

class AddCategoryState extends State<AddCategory> {
  Category category;
  AddCategoryState(Category category) {
    this.category = category;
    print("ini add category page");
  }
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      controller.text = category.category;
    }
    TextFormField inputCategory = TextFormField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
        labelText: 'Category',
        icon: Icon(Icons.category),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your Name';
        }
        return null;
      },
    );

    RaisedButton button = RaisedButton.icon(
      onPressed: () {
        if (category == null) {
          category = Category(controller.text);
        } else {
          category.category = controller.text;
        }
        Navigator.pop(context, category);
      },
      icon: Icon(Icons.save),
      label: Text("save"),
      color: Colors.blue,
      textColor: Colors.white,
    );
    return Scaffold(
        appBar: AppBar(
          title:
              category == null ? Text("Add Category") : Text("Update Category"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              inputCategory,
              button,
            ],
          ),
        ));
  }
}
