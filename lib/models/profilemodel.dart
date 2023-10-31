import 'dart:convert';

ProfileData profileDataFromJson(String str) =>
    ProfileData.fromJson(json.decode(str));

class ProfileData {
  Data data;

  ProfileData({
    required this.data,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  String id;
  String name;
  String email;
  String phone;
  DateTime registeredAt;
  Status status;

  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.registeredAt,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        registeredAt: DateTime.parse(json["registered_at"]),
        status: Status.fromJson(json["status"]),
      );
}

class Status {
  int code;
  String description;

  Status({
    required this.code,
    required this.description,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: json["code"],
        description: json["description"],
      );
}
