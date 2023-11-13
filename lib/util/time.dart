import 'package:intl/intl.dart';
String formatTimeAgo(String isoString) {
  final dateTime = DateTime.parse(isoString);
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds} detik yang lalu';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} menit yang lalu';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} jam yang lalu';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} hari yang lalu';
  } else {
    final formatter = DateFormat('dd MMMM y');
    return formatter.format(dateTime);
  }
}