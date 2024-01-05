import 'dart:convert';

ApiConfigs configsFromJson(String str) => ApiConfigs.fromJson(json.decode(str));

class ApiConfigs {
  Data data;

  ApiConfigs({
    required this.data,
  });

  factory ApiConfigs.fromJson(Map<String, dynamic> json) => ApiConfigs(
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Map<String, String> configs;

  Data({
    required this.configs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        configs: Map<String, String>.from(json["configs"]),
      );
}
