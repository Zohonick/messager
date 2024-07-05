import 'package:intl/intl.dart';

String initialsName(String fullName) {
  List<String> nameParts = fullName.split(" ");
  String initials = nameParts.map((name) => name[0]).join("");
  return initials;
}

String calculateLastDate(DateTime? lastMessageDataTime, {bool? withMinutes}) {
  if (lastMessageDataTime != null) {
    final diff = lastMessageDataTime.difference(DateTime.now()).inDays.abs();
    switch (diff) {
      case 0:
        if (withMinutes != null && withMinutes) {
          final diffMinutes =
              lastMessageDataTime.difference(DateTime.now()).inMinutes.abs();
          if (diffMinutes < 1) return 'только что';
          return diffMinutes < 30
              ? '$diffMinutes ${plural(diffMinutes)} назад'
              : 'Сегодня';
        } else {
          return 'Сегодня';
        }
      case 1:
        return 'Вчера';
      default:
        return DateFormat('dd.MM.yy').format(lastMessageDataTime);
    }
  } else {
    return '';
  }
}

String plural(int diffMinutes) {
  switch (diffMinutes) {
    case 0:
      return 'минут';
    case 1:
      return 'минута';
    case 2:
      return 'минуты';
    case 3:
      return 'минуты';
    case 4:
      return 'минуты';
    default:
      return 'минут';
  }
}

String ellipsisText(String? message) {
  return message != null && message.length > 15
      ? '${message.substring(0, 15)}...'
      : message ?? '';
}
