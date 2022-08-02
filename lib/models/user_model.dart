class UserModel {
  String? uId;
  String? phone;
  String? email;
  String? name;
  String? image;
  String? about;

  UserModel({
    required this.about,
    required this.email,
    required this.image,
    required this.name,
    required this.phone,
    required this.uId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    phone = json['phone'];
    email = json['email'];
    name = json['name'];
    image = json['image'];
    about = json['about'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'phone': phone,
      'email': email,
      'name': name,
      'image': image,
      'about': about,
    };
  }
}
