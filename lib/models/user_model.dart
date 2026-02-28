class UserModel {
  Address? address;
  int? id;
  String email;
  String username;
  String password;
  Name? name;
  String phone;

  UserModel({
    this.address,
    this.id,
    this.email = '',
    required this.username,
    required this.password,
    this.name,
    this.phone = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'],
      password: json['password'],
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;
    if (name != null) {
      data['name'] = name!.toJson();
    }
    data['phone'] = phone;
    return data;
  }
}

class Name {
  String firstname;
  String lastname;

  Name({this.firstname = '', this.lastname = ''});

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;

    return data;
  }
}

class Address {
  Geolocation? geolocation;
  String city;
  String street;
  int? number;
  String zipcode;

  Address({
    this.geolocation,
    this.city = '',
    this.street = '',
    this.number,
    this.zipcode = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      geolocation: json['geolocation'] != null
          ? Geolocation.fromJson(json['geolocation'])
          : null,
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      number: json['number'],
      zipcode: json['zipcode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (geolocation != null) {
      data['geolocation'] = geolocation!.toJson();
    }
    data['city'] = city;
    data['street'] = street;
    data['number'] = number;
    data['zipcode'] = zipcode;
    return data;
  }
}

class Geolocation {
  String lat;
  String long;

  Geolocation({this.lat = '', this.long = ''});

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    return Geolocation(lat: json['lat'] ?? '', long: json['long'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;

    return data;
  }
}
