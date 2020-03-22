import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text('wayan edi sudarma'),
                trailing: Wrap(
                  spacing: 20, // space between two icons
                  children: <Widget>[
                    Icon(Icons.edit), // icon-1
                    Icon(Icons.delete), // icon-2
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'addContact');
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
