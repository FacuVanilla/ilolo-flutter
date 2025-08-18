import 'package:intl/intl.dart';

String formatPriceToMoney(int price) {
  final moneyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
  String formattedPrice = moneyFormat.format(price);

  if (formattedPrice.endsWith('.00')) {
    formattedPrice = formattedPrice.substring(0, formattedPrice.length - 3);
  }

  return formattedPrice;
}

  // my personal truncate string method
  String truncate(String words, int limit) {
    if (words.length >= limit) {
      String newLength = words.substring(0, 30);
      return "$newLength...";
    } else {
      return words;
    }
  }

  // customer function to covert date
  String timeAgo(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      return '${difference.inDays ~/ 7} weeks ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
  