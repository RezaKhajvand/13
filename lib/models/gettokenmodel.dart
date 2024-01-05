import 'dart:convert';

GetToken getTokenFromJson(String str) => GetToken.fromJson(json.decode(str));

class GetToken {
  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  GetToken({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  factory GetToken.fromJson(Map<String, dynamic> json) => GetToken(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );
}
