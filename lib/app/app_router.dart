import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ilolo/app/app_middleware.dart';
import 'package:ilolo/features/account/view/business_details_screen.dart';
import 'package:ilolo/features/account/view/my_adverts_screen.dart';
import 'package:ilolo/features/account/view/my_subscription_screen.dart';
import 'package:ilolo/features/account/view/personal_details_screen.dart';
import 'package:ilolo/features/account/view/price_screen.dart';
import 'package:ilolo/features/account/view/profile_view_screen.dart';
import 'package:ilolo/features/account/view/successful_advert_update.dart';
import 'package:ilolo/features/auth/auth.dart';
import 'package:ilolo/features/auth/view/change_password.dart';
import 'package:ilolo/features/auth/view/verify_email_screen.dart';
import 'package:ilolo/features/auth/view/verify_phone_number_screen.dart';
import 'package:ilolo/features/home/home.dart';
import 'package:ilolo/features/home/view/state_screen.dart';
import 'package:ilolo/features/onboarding/onboarding.dart';
import 'package:ilolo/features/search/view/search_screen.dart';
import 'package:ilolo/features/sell/sell.dart';
import 'package:ilolo/features/sell/view/success_screen.dart';

Future<GoRouter> appRouter() async {
  final String initRoute = await appOnboardMiddleware();
  return GoRouter(
    initialLocation: initRoute,
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return OnBoarding();
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'sell',
            builder: (BuildContext context, GoRouterState state) {
              // return isLogged ? const SellScreen() : const LoginScreen();
              return const SellScreen();
            },
          ),
          GoRoute(
            path: 'search',
            builder: (BuildContext context, GoRouterState state) {
              return const SearchScreen();
            },
          ),
          GoRoute(
            path: 'location',
            builder: (BuildContext context, GoRouterState state) {
              return const StateScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: '/profile-view',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfileViewScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'personal',
            builder: (BuildContext context, GoRouterState state) {
              return const PersonalDetailsScreen();
            },
          ),
          GoRoute(
            path: 'business',
            builder: (BuildContext context, GoRouterState state) {
              return const BusinessDetailsScreen();
            },
          ),
        ],
      ),
      GoRoute(
        path: "/verify-phone",
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyPhoneNumberScreen();
        },
      ),
      GoRoute(
        path: '/my-adverts',
        builder: (BuildContext context, GoRouterState state) {
          return const MyAdvertScreen();
        },
      ),
      GoRoute(
        path: '/boost-ads',
        builder: (BuildContext context, GoRouterState state) {
          return const PriceWidget();
        },
      ),
      GoRoute(
        path: '/subscription',
        builder: (BuildContext context, GoRouterState state) {
          return const MySubscriptionScreen();
        },
      ),
      GoRoute(
        path: "/login",
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: "/register",
        builder: (BuildContext context, GoRouterState state) {
          return const VerifyEmailScreen();
        },
      ),
      GoRoute(
        path: "/post-success",
        builder: (BuildContext context, GoRouterState state) {
          return const PostAdSuccess();
        },
      ),
      GoRoute(
        path: "/update-success",
        builder: (BuildContext context, GoRouterState state) {
          return const UpdateAdSuccess();
        },
      ),
      GoRoute(
        path: "/forget-password",
        builder: (BuildContext context, GoRouterState state) {
          return const ForgetPasswordScreen();
        },
      ),
      GoRoute(
        path: "/change-password",
        builder: (BuildContext context, GoRouterState state) {
          return const ChangePasswordScreen();
        },
      )
    ],
  );
}
