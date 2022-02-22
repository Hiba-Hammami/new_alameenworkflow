// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserFromJson(Map<String, dynamic> json) {
  return UserData(
      id: json['id'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      url: json['url'] as String,
      setcookie: json['setcookie'],
      mobileToken: json['mobileToken'] as String);
}

Map<String, dynamic> _$UserToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'url': instance.url,
      'setcookie': instance.setcookie,
      'mobileToken': instance.mobileToken
    };
