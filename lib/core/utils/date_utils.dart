import "package:intl/intl.dart";

/// Date and time formatting utilities.
abstract class AppDateUtils {
  static final DateFormat _dateFormat = DateFormat("dd MMM yyyy");
  static final DateFormat _timeFormat = DateFormat("hh:mm a");
  static final DateFormat _dateTimeFormat = DateFormat("dd MMM yyyy, hh:mm a");
  static final DateFormat _dayMonthFormat = DateFormat("dd MMM");
  static final DateFormat _firestoreDateFormat = DateFormat("yyyy-MM-dd");

  static String formatDate(DateTime date) => _dateFormat.format(date);

  static String formatTime(DateTime date) => _timeFormat.format(date);

  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatDayMonth(DateTime date) => _dayMonthFormat.format(date);

  static String formatForFirestore(DateTime date) =>
      _firestoreDateFormat.format(date);

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static String relativeDate(DateTime date) {
    if (isToday(date)) return "Today";
    if (isTomorrow(date)) return "Tomorrow";
    if (isYesterday(date)) return "Yesterday";
    return formatDate(date);
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    if (diff.inDays < 7) return "${diff.inDays}d ago";
    return formatDate(date);
  }
}
