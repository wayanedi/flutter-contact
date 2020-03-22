import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';

class AddContact extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddContactState();
  }
}

class AddContactState extends State<AddContact> {
  final _formKey = GlobalKey<FormState>();
  List<DynamicInputPhone> inputDynamic = [];

  @override
  void initState() {
    // TODO: implement initState
    inputDynamic.add(DynamicInputPhone());

    setState(() {});
    super.initState();
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

  void saveContact() {
    inputDynamic.forEach((widget) => print(widget.controller.text));
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
            child: Icon(
              Icons.camera_alt,
            ),
          ),
        ),
      ],
    );

    TextFormField inputName = TextFormField(
      controller: null,
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
      controller: null,
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

    MaskedTextField inputPhoneNumber = new MaskedTextField(
      maskedTextFieldController: null,
      mask: "xxxx-xxxx-xxxx",
      maxLength: 12,
      keyboardType: TextInputType.phone,
      inputDecoration: new InputDecoration(
        labelText: "Telefone",
        icon: Icon(Icons.phone),
      ),
    );

    ListView phone = ListView.builder(
        padding: const EdgeInsets.all(8),
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

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Add Contact"),
        actions: <Widget>[
          Container(
            child: IconButton(
                icon: Icon(
                  Icons.save,
                  size: 35,
                ),
                onPressed: () {
                  saveContact();
                }),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            picture,
            inputName,
            inputEmail,
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
    );
  }
}

class DynamicInputPhone extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: MaskedTextField(
        maskedTextFieldController: controller,
        mask: "xxxx-xxxx-xxxx",
        maxLength: 14,
        keyboardType: TextInputType.phone,
        inputDecoration: new InputDecoration(
          labelText: "Telefone",
        ),
      ),
    );
  }
}
