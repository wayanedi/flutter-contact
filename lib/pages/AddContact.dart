import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masked_text/masked_text.dart';

class AddContact extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
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

    ListView content = ListView(
      padding: EdgeInsets.all(20),
      children: <Widget>[
        SizedBox(height: 20),
        picture,
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                inputName,
                inputPhoneNumber,
                inputEmail,
              ],
            ))
      ],
    );
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
                  Navigator.of(context).pop();
                }),
          )
        ],
      ),
      body: Container(
        child: content,
      ),
    );
  }
}
