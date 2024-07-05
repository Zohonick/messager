import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/entity/persons_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _key = 'personsData';

  PersonsData? personsData;

  Future<void> saveMessage(String message, int personIndex) async {
    personsData?.persons?[personIndex].messages?.add(Messages(
        message: message, dateTime: DateTime.now(), your: true, read: false));
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(personsData?.toJson());
    await prefs.setString(_key, json);
  }

  ChatBloc(PersonsData data) : super(ChatInitialState()) {
    on<ChatInitialEvent>((event, emit) {
      personsData = data;
      emit(ChatViewState(personsData));
    });

    on<SendMessageEvent>((event, emit) async {
      await saveMessage(event.message, event.personIndex);
      emit(ChatViewState(personsData));
    });
  }
}
