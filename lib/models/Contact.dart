class Contact implements Comparable<Contact> {
  int _id;
  String _name;
  String _email;
  String _phone;
  String _photo;
  int _prioritas;
  int _idCategory;
  String _nameCategory;

  Contact(this._name, this._email, this._phone, this._photo, this._prioritas,
      this._idCategory);

  @override
  int compareTo(Contact other) {
    int diff = this._prioritas - other.prioritas;

    return (diff == 0 ? this._name.compareTo(other.name) : diff);
  }

  Contact.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._email = map['email'];
    this._phone = map['phone'];
    this._photo = map['photo'];
    this._prioritas = map['prioritas'];
    this._idCategory = map['id_category'];
    this._nameCategory = map['name_category'];
  }

  int get id => this._id;
  String get name => this._name;
  String get email => this._email;
  String get phone => this._phone;
  String get photo => this._photo;
  String get nameCategory => this._nameCategory;
  int get prioritas => this._prioritas;
  int get idCategory => this._idCategory;

  set id(int val) {
    this._id = val;
  }

  set name(String val) {
    this._name = val;
  }

  set email(String val) {
    this._email = val;
  }

  set phone(String val) {
    this._phone = val;
  }

  set photo(String val) {
    this._photo = val;
  }

  set nameCategory(String val) {
    this._nameCategory = val;
  }

  set prioritas(int val) {
    this._prioritas = val;
  }

  set idCategory(int val) {
    this._idCategory = val;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'name': this._name,
      'email': this._email,
      'phone': this._phone,
      'photo': this._photo,
      'prioritas': this._prioritas,
      'id_category': this._idCategory,
    };
  }
}
