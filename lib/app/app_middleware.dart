// middle function
import 'package:ilolo/app/app_storage.dart';

Future<String> appOnboardMiddleware() async {
  final dynamic isBoarded = await AppStorage().isOnboarded();
  if (isBoarded == true) {
    return '/home';
  } else {
    return '/';
  }
}

Future<bool> authMiddleware() async {
  final dynamic isLoggedIn = await AppStorage().getAuthToken();
  if (isLoggedIn != null) {
    return true;
  } else {
    return false;
  }
}
