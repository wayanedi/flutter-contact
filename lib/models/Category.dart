class Category {
  int _id;
  String _category;

  Category(String categoty, {id}) {
    this._category = categoty;
    this._id = id;
  }

  Category.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._category = map['name_category'];
  }

  int get id => this._id;
  String get category => this._category;

  set category(String value) {
    this._category = value;
  }

  set id(int value) {
    this._id = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this._id,
      'name_category': this._category,
    };
  }
}
