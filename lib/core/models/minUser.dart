import 'package:todolist/core/models/model.dart';

class MinUser extends Model {
  MinUser({
    this.fullname,
    this.email,
    this.photo,
    this.uid,
  });

  String fullname;
  String email;
  String photo;
  String uid;

  factory MinUser.fromJson(Map<String, dynamic> json) => MinUser(
        fullname: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        photo: json["photo"] == null ? null : json["photo"],
        uid: json["uid"] == null ? null : json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "name": fullname == null ? null : fullname,
        "email": email == null ? null : email,
        "photo": photo == null ? null : photo,
        "uid": uid == null ? null : uid,
      };
}
