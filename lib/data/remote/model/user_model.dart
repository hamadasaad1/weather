class UserModel {
  String? userId, email, name, location;

  UserModel({this.userId, this.email, this.name, this.location});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    email = map['email'];
    name = map['name'];
    location = map['location']??'';
  }

  toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'location': location,
    };
  }
}
