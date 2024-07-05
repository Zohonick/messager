// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persons_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonsData _$PersonsDataFromJson(Map<String, dynamic> json) => PersonsData(
      persons: (json['persons'] as List<dynamic>?)
          ?.map((e) => Persons.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonsDataToJson(PersonsData instance) =>
    <String, dynamic>{
      'persons': instance.persons,
    };

Persons _$PersonsFromJson(Map<String, dynamic> json) => Persons(
      name: json['name'] as String?,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Messages.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonsToJson(Persons instance) => <String, dynamic>{
      'name': instance.name,
      'messages': instance.messages,
    };

Messages _$MessagesFromJson(Map<String, dynamic> json) => Messages(
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      your: json['your'] as bool?,
      read: json['read'] as bool?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'dateTime': instance.dateTime?.toIso8601String(),
      'your': instance.your,
      'read': instance.read,
      'message': instance.message,
    };
