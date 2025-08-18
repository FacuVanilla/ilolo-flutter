import 'package:crisp_chat/crisp_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/account/repository/profile_repository.dart';
import 'package:ilolo/features/account/view/account_screen.dart';
import 'package:ilolo/features/auth/repository/login_repository.dart';
import 'package:ilolo/features/book_mark/repository/book_mark_repository.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/features/home/repository/location_repository.dart';
import 'package:ilolo/features/message/repository/contact_repository.dart';
import 'package:ilolo/features/message/repository/notification_repository.dart';
import 'package:ilolo/features/sell/repository/form_data_repository.dart';
import 'package:ilolo/features/sell/sell.dart';
import 'package:ilolo/features/subscription/repository/plan_repository.dart';
import 'package:ilolo/widgets/app_bar/book_mark_app_bar_widget.dart';
import 'package:ilolo/widgets/app_bar/home_app_bar_widget.dart';
import 'package:ilolo/widgets/app_bar/message_app_bar_widget.dart';
import 'package:ilolo/widgets/app_bar/pricing_app_bar_widget.dart';
import 'package:ilolo/widgets/home/book_mark_widget.dart';
import 'package:ilolo/widgets/home/drawer_widget.dart';
import 'package:ilolo/widgets/home/home_widget.dart';
import 'package:ilolo/widgets/home/message_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String websiteID = '669263ef-acde-4082-b69a-f78f1d10b30d';
  late final CrispConfig crispConfig;
  int selectedNavIndex = 0;
  // dynamic appBarWidget = const HomeAppBar(title: "Explore ilolo in ");
  // fetch basic provider data
  @override
  void initState() {
    super.initState();
     // Initialize Crisp configuration
    crispConfig = CrispConfig(
      websiteID: websiteID,
    );
    context.read<AdvertRepository>().getAdverts();
    context.read<CategoryRepository>().getCategories();
    context.read<LocationRepository>().getStateAndLga();
    context.read<ProfileRepository>().getProfileData();
    context.read<BookMarkRepository>().getBookMarks();
    context.read<FormDataRepository>().getFormData();
    context.read<NotificationRepository>().getNotifications();
    context.read<ContactRepository>().getContacts();
    context.read<PlanRepository>().getPlans();
    context.read<LoginRepository>().googleAuthCheck();
  }

  changeNavIndex(int index, ctx) async {
    final bool isLogged = await authMiddleware();
    if (isLogged == false && index == 1) {
      return GoRouter.of(ctx).push('/login');
    } else if (isLogged == false && index == 2) {
      return GoRouter.of(ctx).push('/login');
    } else if (isLogged == true && index == 2) {
      if (Provider.of<ProfileRepository>(ctx, listen: false).profileData!.phoneVerified == 0) {
        return GoRouter.of(ctx).push('/verify-phone');
      } else {
        return GoRouter.of(ctx).go('/home/sell');
      }
    } else if (isLogged == false && index == 3) {
      return GoRouter.of(ctx).push('/login');
    } else if (isLogged == true && index == 4) {
      return Navigator.push(ctx, MaterialPageRoute(builder: (context) => const AccountScreen()));
    }else if(isLogged == false && index == 4){
      return GoRouter.of(ctx).push('/login');
    }
    setState(() => selectedNavIndex = index);
  }

  List<dynamic> appBarWidget = [
    const HomeAppBar(title: "Explore ilolo in "),
    const BookMarkAppBarkWidget(title: "Bookmark"),
    '',
    const MessageAppBarWidget(title: "Messages"),
    const PricingAppBarWidget()
  ];
  List<dynamic> selectViewWidget = [const HomeWidget(), const BookMarkWidget(), const SellScreen(), const MessengerWidget(), const AccountScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget[selectedNavIndex],
      drawer: selectedNavIndex == 0 ? const DrawerWidget() : null,
      body: selectViewWidget[selectedNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: const Color.fromRGBO(255, 255, 255, 1),
        unselectedItemColor: const Color.fromRGBO(255, 255, 255, .5),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedNavIndex,
        onTap: (value) => changeNavIndex(value, context),
        items: const [
          BottomNavigationBarItem(icon: Icon(Boxicons.bx_home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Boxicons.bx_bookmark), label: "Bookmark"),
          BottomNavigationBarItem(icon: Icon(Boxicons.bx_plus), label: "Sell"),
          BottomNavigationBarItem(icon: Icon(Boxicons.bxs_message_alt_dots), label: "Message"),
          BottomNavigationBarItem(icon: Icon(Boxicons.bx_user), label: "Profile"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FlutterCrispChat.openCrispChat(
            config: crispConfig,
          );
        },
        mini: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.contact_support),
      ),
    );
  }
}
