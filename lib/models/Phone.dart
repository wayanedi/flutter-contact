class Phone {
  List<String> phone;

  Phone(this.phone);

  Phone.fromJson(Map<String, dynamic> json) {
    this.phone = List<String>();
    json['phone'].foreach((phone) => this.phone.add(phone));
  }

  Map<String, dynamic> toJson() => {
        'phone': this.phone,
      };
}
