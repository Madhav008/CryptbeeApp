import 'dart:developer';

import 'package:cryptbee/Routing/route_names.dart';
import 'package:cryptbee/Screens/AuthScreens/sign_in_page.dart';
import 'package:cryptbee/Screens/AuthScreens/sign_up_page.dart';
import 'package:cryptbee/Screens/AuthScreens/mail_opener.dart';
import 'package:cryptbee/Screens/Homepage/Profile/change_password.dart';
import 'package:cryptbee/Screens/Homepage/Profile/profile_pan.dart';
import 'package:cryptbee/Screens/Homepage/Profile/security.dart';
import 'package:cryptbee/Screens/Homepage/coin_page.dart';
import 'package:cryptbee/Screens/Homepage/home_page.dart';
import 'package:cryptbee/Screens/Utilities/static_classes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    navigatorKey: App.navigatorKey,
    routes: [
      GoRoute(
        name: RouteNames.root,
        path: '/',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: App.isLoggedIn ? const HomePage() : SignInPage());
        },
      ),
      GoRoute(
        name: RouteNames.signIn,
        path: '/signin',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: SignInPage(),
          );
        },
      ),
      GoRoute(
        name: RouteNames.signUp,
        path: '/signup',
        pageBuilder: (context, state) {
          return MaterialPage(
            child: SignUpPage(),
          );
        },
        routes: [
          GoRoute(
            name: RouteNames.mailOpener,
            path: 'mailopener/:email',
            pageBuilder: (context, state) {
              return MaterialPage(
                child: MailOpener(
                  email: state.pathParameters['email']!,
                ),
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: RouteNames.homePage,
        path: '/homepage',
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HomePage(),
          );
        },
        routes: [
          GoRoute(
            name: RouteNames.coinPage,
            path: 'coinpage/:shortName',
            pageBuilder: (context, state) {
              log(state.pathParameters.toString());
              return MaterialPage(
                child: CoinPage(
                  shortName: state.pathParameters['shortName']!,
                ),
              );
            },
          ),
          GoRoute(
            name: RouteNames.personalDetails,
            path: 'personaldetails',
            pageBuilder: (context, state) {
              return MaterialPage(
                child: ProfilePan(),
              );
            },
          ),
          GoRoute(
            name: RouteNames.security,
            path: 'security',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: Security(),
              );
            },
            routes: [
              GoRoute(
                name: RouteNames.changePassword,
                path: 'changepassword',
                pageBuilder: (context, state) {
                  return MaterialPage(
                    child: ChangePassword(),
                  );
                },
              ),
            ],
          )
        ],
      ),
    ],
  );
}
