
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/account/repository/user_advert_repository.dart';
import 'package:ilolo/features/auth/repository/login_repository.dart';
import 'package:ilolo/features/auth/repository/logout_repository.dart';
import 'package:ilolo/features/auth/repository/register_repository.dart';
import 'package:ilolo/features/auth/repository/reset_password_repository.dart';
import 'package:ilolo/features/auth/repository/verify_number_email_repository.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/features/home/repository/advert_by_category_repository.dart';
import 'package:ilolo/features/home/repository/advert_by_location.dart';
import 'package:ilolo/features/home/repository/location_repository.dart';
import 'package:ilolo/features/home/repository/seller_repository.dart';
import 'package:ilolo/features/home/repository/single_advert_repository.dart';
import 'package:ilolo/features/message/repository/contact_repository.dart';
import 'package:ilolo/features/message/repository/message_repository.dart';
import 'package:ilolo/features/message/repository/notification_repository.dart';
import 'package:ilolo/features/review/repository/review_repository.dart';
import 'package:ilolo/features/search/repository/search_repository.dart';
import 'package:ilolo/features/sell/repository/form_data_repository.dart';
import 'package:ilolo/features/sell/repository/post_ad_repository.dart';
import 'package:ilolo/features/subscription/repository/plan_repository.dart';
import 'package:ilolo/features/subscription/repository/subscription_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> changeNotifierProvider = [
  ChangeNotifierProvider<AdvertRepository>(create: (context) => AdvertRepository()),
  ChangeNotifierProvider<SingleAdvertRepository>(create: (context) => SingleAdvertRepository()),
  ChangeNotifierProvider<SellerRepository>(create: (context) => SellerRepository()),
  ChangeNotifierProvider<VerifyNumberEmailRepository>(create: (context) => VerifyNumberEmailRepository()),
  ChangeNotifierProvider<PlanRepository>(create: (context) => PlanRepository()),
  ChangeNotifierProvider<SubscriptionRepository>(create: (context) => SubscriptionRepository()),
  ChangeNotifierProvider<MessageRepository>(create: (context) => MessageRepository()),
  ChangeNotifierProvider<ContactRepository>(create: (context) => ContactRepository()),
  ChangeNotifierProvider<ReviewRepository>(create: (context) => ReviewRepository()),
  ChangeNotifierProvider<NotificationRepository>(create: (context) => NotificationRepository()),
  ChangeNotifierProvider<AdvertByCategoryRepository>(create: (context) => AdvertByCategoryRepository()),
  ChangeNotifierProvider<AdvertByLocationRepository>(create: (context) => AdvertByLocationRepository()),
  ChangeNotifierProvider<CategoryRepository>(create: (context) => CategoryRepository()),
  ChangeNotifierProvider<LocationRepository>(create: (context) => LocationRepository()),
  ChangeNotifierProvider<SearchRepository>(create: (context) => SearchRepository()),
  ChangeNotifierProvider<LoginRepository>(create: (context) => LoginRepository()),
  ChangeNotifierProvider<ResetPasswordRepository>(create: (context) => ResetPasswordRepository()),
  ChangeNotifierProvider<RegisterRepository>(create: (context) => RegisterRepository()),
  ChangeNotifierProvider<ProfileRepository>(create: (context) => ProfileRepository()),
  ChangeNotifierProvider<LogoutRepository>(create: (context) => LogoutRepository()),
  ChangeNotifierProvider<BookMarkRepository>(create: (context) => BookMarkRepository()),
  ChangeNotifierProvider<FormDataRepository>(create: (context) => FormDataRepository()),
  ChangeNotifierProvider<PostAdRepository>(create: (context) => PostAdRepository()),
  ChangeNotifierProvider<UserAdvertRepository>(create: (context) => UserAdvertRepository()),
];
