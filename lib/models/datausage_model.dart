import 'dart:convert';

DataUsage dataUsageFromJson(String str) => DataUsage.fromJson(json.decode(str));

class DataUsage {
  Data data;

  DataUsage({
    required this.data,
  });

  factory DataUsage.fromJson(Map<String, dynamic> json) => DataUsage(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Plan plan;
  Status status;

  Data({
    required this.plan,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plan: Plan.fromJson(json["plan"]),
        status: Status.fromJson(json["status"]),
      );
}

class Plan {
  String title;
  String name;
  String description;
  int timeLimit;
  int usersLimit;
  int dataLimit;

  Plan({
    required this.title,
    required this.name,
    required this.description,
    required this.timeLimit,
    required this.usersLimit,
    required this.dataLimit,
  });

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        title: json["title"],
        name: json["name"],
        description: json["description"],
        timeLimit: json["time_limit"],
        usersLimit: json["users_limit"],
        dataLimit: json["data_limit"],
      );
}

class Status {
  DateTime startedAt;
  DateTime expiresAt;
  String dataUsage;

  Status({
    required this.startedAt,
    required this.expiresAt,
    required this.dataUsage,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        startedAt: DateTime.parse(json["started_at"]),
        expiresAt: DateTime.parse(json["expires_at"]),
        dataUsage: (double.parse(json["data_usage"] ?? '0') / 1000000000)
            .toStringAsFixed(2),
      );
}
