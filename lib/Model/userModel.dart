import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  static UserModel instance = new UserModel.empty();
  String? _firstName;

  String? get firstName => _firstName;

  set firstName(String? firstName) {
    _firstName = firstName;
  }

  String? _lastName;

  String? get lastName => _lastName;

  set lastName(String? lastName) {
    _lastName = lastName;
  }

  String? _email;

  String? get email => _email;

  set email(String? email) {
    _email = email;
  }

  UserModel.empty();

  UserModel.withMap(Map<String, Object?> json) {
    this._firstName = json["firstName"]! as String;
    this._lastName = json["lastName"]! as String;
    this._email = json["email"]! as String;
  }

  UserModel(
  {firstName,
  lastName,
  email});

  void createUserModel(
  {firstName,
  lastName,
  email,
  password}) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
  }

  UserModel.fromJson(Map<String, Object?> json) : this.withMap(json);

  Map<String, Object?> toJson() {
    return {
      "firstName": this.firstName,
      "lastName": this.lastName,
      "email": this.email,
    };
  }
}