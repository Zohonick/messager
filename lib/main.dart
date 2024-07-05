import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger/utils/app_colors.dart';
import 'package:messenger/bloc/main_bloc.dart';
import 'package:messenger/chatScreen/chat_screen.dart';
import 'package:messenger/entity/persons_data.dart';

import 'utils/my_painter.dart';
import 'utils/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Messenger',
      theme: ThemeData(
        fontFamily: 'Gilroy',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => MainBloc()..add(MainInitialEvent()),
        child: BlocBuilder<MainBloc, MainState>(
          builder: (context, state) {
            switch (state) {
              case MainViewState():
                return buildScaffold(state.data, context);
              default:
                return buildLoadingState();
            }
          },
        ));
  }

  Widget buildLoadingState() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Scaffold buildScaffold(PersonsData? data, BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const HeaderView(),
            const Divider(),
            data?.persons != null
                ? Expanded(
                    child: ListView.builder(
                        itemCount: data!.persons!.length,
                        itemBuilder: (context, index) {
                          return CardView(data, index, context);
                        }),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class HeaderView extends StatelessWidget {
  const HeaderView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Чаты',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 6,
          ),
          SizedBox(
            height: 42,
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                  height: 24,
                  fit: BoxFit.scaleDown,
                ),
                filled: true,
                fillColor: AppColors.stroke,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                hintText: 'Поиск',
                hintStyle: const TextStyle(
                  fontSize: 16,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray,
                ),
              ),
              onChanged: (value) {},
            ),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  const CardView(this.data, this.index, this.rootContext, {super.key});

  final PersonsData data;
  final int index;
  final BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    final initialName = initialsName(data.persons?[index].name ?? '');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              data: data,
              index: index,
            ),
          ),
        ).whenComplete(() {
          rootContext.read<MainBloc>().add(MainInitialEvent());
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    circleContainer(initialName),
                    Text(
                      textAlign: TextAlign.end,
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
                      data.persons?[index].name ?? 'unknown name',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        if (data.persons?[index].messages?.last.your ?? false)
                          const Text(
                            'Вы: ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        Text(
                          ellipsisText(
                              data.persons?[index].messages?.last.message),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.darkGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  calculateLastDate(
                      data.persons?[index].messages?.last.dateTime,
                      withMinutes: true),
                  style:
                      const TextStyle(color: AppColors.darkGray, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
