import 'dart:io';
import 'package:contact/models/Category.dart';
import 'package:contact/models/Contact.dart';
import 'package:contact/models/Phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masked_text/masked_text.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class AddContact extends StatefulWidget {
  final Contact contact;
  final List<Category> categoryList;

  AddContact(this.contact, this.categoryList);
  @override
  State<StatefulWidget> createState() {
    return AddContactState(this.contact, this.categoryList);
  }
}

class AddContactState extends State<AddContact> {
  //final _formKey = GlobalKey<FormState>();
  List<DynamicInputPhone> inputDynamic = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController prioritasController = TextEditingController();
  Contact contact;
  String path = null;
  List<Category> categoryList;
  List<DropdownMenuItem<Category>> _dropdownMenuItems;
  Category _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  AddContactState(this.contact, this.categoryList);

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(categoryList);
    if (contact == null) {
      inputDynamic.add(DynamicInputPhone());
      _selectedCategory = _dropdownMenuItems[0].value;
    } else {
      var contactJson = jsonDecode(contact.phone)['phone'];
      List<String> contactList =
          contactJson != null ? List.from(contactJson) : null;
      contactList
          .forEach((val) => inputDynamic.add(DynamicInputPhone(value: val)));
      nameController.text = contact.name;
      emailController.text = contact.email;
      prioritasController.text = contact.prioritas.toString();
      path = contact.photo;
      //get index in dropdown items
      var getCategory = _dropdownMenuItems
          .firstWhere((val) => val.value.category == contact.nameCategory);
      var getIndex = _dropdownMenuItems.indexOf(getCategory);
      _selectedCategory = _dropdownMenuItems[getIndex].value;
    }

    setState(() {});
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
      print(_selectedCategory.id);
    });
  }

  void addNewPhoneField() {
    if (inputDynamic.length < 3) {
      inputDynamic.add(DynamicInputPhone());
      setState(() {});
    }
  }

  void removePhoneField(int index) {
    if (inputDynamic.length > 1) {
      inputDynamic.removeAt(index);
      setState(() {});
    }
  }

  void saveContact(BuildContext context) {
    int phoneValidate = 0;
    inputDynamic.forEach((key) {
      if (key._formKey.currentState.validate()) {
        phoneValidate += 1;
      }
    });
    if (_formKey.currentState.validate() &&
        phoneValidate == inputDynamic.length) {
      List<String> phone = List<String>();
      inputDynamic.forEach((widget) => phone.add(widget.controller.text));
      Phone p = Phone(phone);
      print(jsonEncode(p));

      if (this.contact == null) {
        contact = Contact(
            nameController.text,
            emailController.text,
            jsonEncode(p),
            path,
            int.parse(prioritasController.text),
            _selectedCategory.id);
      } else {
        contact.photo = path;
        contact.name = nameController.text;
        contact.email = emailController.text;
        contact.prioritas = int.parse(prioritasController.text);
        contact.phone = jsonEncode(p);
        contact.idCategory = _selectedCategory.id;
      }
      Navigator.pop(context, contact);
    }
  }

  pickImageFromGallery() async {
    final File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (path != null) {
        final dir = Directory(path);
        dir.deleteSync(recursive: true);
      }
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      path =
          '$appDocPath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
      await image.copy(path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final picture = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 120.0,
          height: 120.0,
          child: CircleAvatar(
            child: GestureDetector(
                child: path == null
                    ? Icon(Icons.camera_alt)
                    : Image.file(File(path)),
                onTap: () {
                  pickImageFromGallery();
                }), // icon-2
          ),
        ),
      ],
    );

    TextFormField inputName = TextFormField(
      controller: nameController,
      autofocus: true,
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(45),
      ],
      decoration: InputDecoration(
        labelText: 'Name',
        icon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your Name';
        }
        return null;
      },
    );

    TextFormField inputEmail = TextFormField(
      controller: emailController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'E-mail',
        icon: Icon(Icons.email),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your Email';
        }
        return null;
      },
    );

    TextFormField prioritas = TextFormField(
      controller: prioritasController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(3),
      ],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Prioritas',
        icon: Icon(Icons.priority_high),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter prioritas';
        }
        if (int.parse(value) <= 0 || int.parse(value) > 100) {
          return 'prioritas must between 1-100';
        }
        return null;
      },
    );

    SizedBox button = SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 20,
        children: <Widget>[
          Icon(Icons.category),
          DropdownButton(
            value: _selectedCategory,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),
        ],
      ),
    );

    ListView phone = ListView.builder(
        //padding: const EdgeInsets.all(8),
        itemCount: inputDynamic.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Icon(Icons.phone),
            title: inputDynamic[index],
            trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  removePhoneField(index);
                }),
          );
        });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: contact == null ? Text("Add Contact") : Text("Edit Contact"),
        actions: <Widget>[
          Container(
            child: IconButton(
                icon: Icon(
                  Icons.save,
                  size: 35,
                ),
                onPressed: () {
                  saveContact(context);
                }),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              picture,
              inputName,
              inputEmail,
              prioritas,
              button,
              Expanded(child: phone),
              RaisedButton(
                child: Text("Add Phone"),
                onPressed: () {
                  addNewPhoneField();
                },
                color: Colors.blue,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DynamicInputPhone extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DynamicInputPhone({String value = null}) {
    if (value != null) controller.text = value;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: TextFormField(
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(12),
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Phone',
            icon: Icon(Icons.priority_high),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your Phone Number';
            }
            return null;
          },
        ),
      ),
    );
  }
}
