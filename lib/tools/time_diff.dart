import 'package:intl/intl.dart';

String formatTimeDiff(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else if (difference.inDays < 30) {
    return '${difference.inDays}d';
  } else if (now.year == dateTime.year) {
    return DateFormat('dd MMM').format(dateTime);
  } else {
    return DateFormat('dd MMM yy').format(dateTime);
  }
}