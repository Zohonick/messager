part of 'chat_bloc.dart';

abstract class ChatEvent {}

class ChatInitialEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  SendMessageEvent(this.message, this.personIndex);

  final String message;
  final int personIndex;
}
