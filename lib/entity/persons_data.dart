import 'package:json_annotation/json_annotation.dart';

part 'persons_data.g.dart';


@JsonSerializable()
class PersonsData {
  List<Persons>? persons;

  PersonsData({this.persons});

  factory PersonsData.fromJson(Map<String, dynamic> json) =>
      _$PersonsDataFromJson(json);

  Map<String, dynamic> toJson() => _$PersonsDataToJson(this);

}

@JsonSerializable()
class Persons {
  String? name;
  List<Messages>? messages;

  Persons({this.name, this.messages});

  factory Persons.fromJson(Map<String, dynamic> json) =>
      _$PersonsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonsToJson(this);
}

@JsonSerializable()
class Messages {
  DateTime? dateTime;
  bool? your;
  bool? read;
  String? message;

  Messages({this.dateTime, this.your, this.read, this.message});

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesToJson(this);
}

