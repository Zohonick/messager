import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger/chatScreen/bloc/chat_bloc.dart';
import 'package:messenger/entity/persons_data.dart';
import 'package:messenger/utils/utils.dart';

import '../utils/app_colors.dart';
import '../utils/my_painter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.data, required this.index});

  final PersonsData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ChatBloc(data)..add(ChatInitialEvent()),
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            switch (state) {
              case ChatViewState():
                return buildScaffold(context);
              default:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
            }
          },
        ));
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            HeaderView(data.persons?[index].name ?? ''),
            data.persons?[index].messages?.isNotEmpty ?? false
                ? chatView()
                : Container(),
            BottomView(
              index: index,
              rootContext: context,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget chatView() {
    DateTime? lastMessage;
    final scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: data.persons?[index].messages?.length,
            itemBuilder: (context, idx) {
              final yourMessage =
                  data.persons?[index].messages?[idx].your ?? false;

              final bool differenceDaysLeft = lastMessage == null
                  ? ((data.persons?[index].messages?[idx].dateTime
                              ?.difference(DateTime.now())
                              .inDays
                              .abs() ??
                          0) >
                      1)
                  : ((data.persons?[index].messages?[idx].dateTime
                              ?.difference(lastMessage!)
                              .inDays
                              .abs() ??
                          0) >
                      1);

              lastMessage = data.persons?[index].messages?[idx].dateTime;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: yourMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    if (differenceDaysLeft) ...[
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.8,
                            height: 1,
                            color: AppColors.gray,
                          ),
                          const Spacer(),
                          Text(
                            calculateLastDate(
                                data.persons?[index].messages?[idx].dateTime),
                            style: const TextStyle(
                                color: AppColors.gray, fontSize: 14),
                          ),
                          const Spacer(),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.8,
                            height: 1,
                            color: AppColors.gray,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!yourMessage)
                          SvgPicture.asset('assets/icons/vector_stroke.svg'),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                                color: yourMessage
                                    ? AppColors.green
                                    : AppColors.stroke,
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(20),
                                    topRight: const Radius.circular(20),
                                    bottomRight:
                                        Radius.circular(yourMessage ? 0 : 20),
                                    bottomLeft:
                                        Radius.circular(yourMessage ? 20 : 0))),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      data.persons?[index].messages?[idx]
                                              .message ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: yourMessage
                                              ? AppColors.darkGreen
                                              : Colors.black),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    '${data.persons?[index].messages?[idx].dateTime?.hour.toString()}:${data.persons?[index].messages?[idx].dateTime?.minute.toString()}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: yourMessage
                                            ? AppColors.darkGreen
                                            : Colors.black),
                                  ),
                                  const SizedBox(width: 4),
                                  if (yourMessage)
                                    SvgPicture.asset(
                                      data.persons?[index].messages?[idx]
                                                  .read ??
                                              false
                                          ? 'assets/icons/readed_icon.svg'
                                          : 'assets/icons/send_icon.svg',
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (yourMessage)
                          SvgPicture.asset('assets/icons/vector_messege.svg'),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class BottomView extends StatelessWidget {
  const BottomView({
    super.key,
    required this.index,
    required this.rootContext,
  });

  final int index;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: AppColors.stroke,
              ),
              child: IconButton(
                onPressed: () {
                  //TODO: some method;
                },
                icon: SvgPicture.asset(
                  'assets/icons/clip_icon.svg',
                  height: 50,
                  width: 50,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(
              height: 42,
              width: 230,
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: AppColors.stroke,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  hintText: 'Сообщение',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray,
                  ),
                ),
                onSubmitted: (value) {
                  rootContext
                      .read<ChatBloc>()
                      .add(SendMessageEvent(value, index));
                  textController.clear();
                },
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: AppColors.stroke,
              ),
              child: IconButton(
                onPressed: () {
                  //TODO: some method;
                },
                icon: SvgPicture.asset(
                  'assets/icons/microphone_icon.svg',
                  height: 50,
                  width: 50,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}

class HeaderView extends StatelessWidget {
  const HeaderView(this.fullName, {super.key});

  final String fullName;

  @override
  Widget build(BuildContext context) {
    final initialName = initialsName(fullName);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios)),
              Stack(
                alignment: Alignment.center,
                children: [
                  circleContainer(initialName),
                  Text(
                    initialName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'В сети',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
