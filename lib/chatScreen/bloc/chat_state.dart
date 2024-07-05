part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatInitialState extends ChatState {}

class ChatViewState extends ChatState {
  ChatViewState(this.personsData);

  final PersonsData? personsData;
}
