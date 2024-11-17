import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quicpictodo/pressentation/todo_details/todo_details_screen.dart';

import '../pressentation/add_and_edit/todo_add_and_edit_screen.dart';
import '../pressentation/home/home_screen.dart';
import '../pressentation/onboarding/splash_screen.dart';
import '../pressentation/widgets/not_found_screen.dart';

class AppRouter {
  static const String initial = '/';
  static const String homeScreen = '/homeScreen';
  static const String todoDetailsScreen = '/todoDetailsScreen';
  static const String todoEditScreen = '/todoEditScreen';
  // static const String noInternet = '/noInternet';

  static Widget errorWidget(BuildContext context, GoRouterState state) =>
      const NotFoundPage();
// GoRouter configuration
  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: initial,
        path: initial,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        name: homeScreen,
        path: homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        name: todoDetailsScreen,
        path: todoDetailsScreen,
        builder: (context, state) => const TodoDetailsScreen(),
      ),
      GoRoute(
        name: todoEditScreen,
        path: todoEditScreen,
        builder: (context, state) => TodoAddAndEditScreen(
          isAddTask: state.uri.queryParameters['isAddTask'] ?? 'true',
        ),
      ),
      // GoRoute(
      //   name: otpVerificationScreen,
      //   path: otpVerificationScreen,
      //   builder: (context, state) => const VerifyOtpScreen(),
      // ),

      // GoRoute(
      //   name: sectionHomeScreen,
      //   path: sectionHomeScreen,
      //   builder: (context, state) => SectionHomeScreen(
      //     categoryid: state.uri.queryParameters['categoryid'] ?? '',
      //     sectionName: state.uri.queryParameters['sectionName'] ?? '',
      //   ),
      // ),
      // GoRoute(
      //   name: vibesHomeScreen,
      //   path: vibesHomeScreen,
      //   builder: (context, state) => const VibesHomeScreen(),
      // ),
      // GoRoute(
      //   name: productListByCategoryScreen,
      //   path: productListByCategoryScreen,
      //   builder: (context, state) => ProductListByCategoryScreen(
      //     categoryid: state.uri.queryParameters['categoryid'] ?? '',
      //     subCategoryId: state.uri.queryParameters['subCategoryId'] ?? '',
      //     categoryname: state.uri.queryParameters['categoryname'] ?? '',
      //     isBrand: state.uri.queryParameters['isBrand'] ?? 'false',
      //     isFromDealsScreen:
      //         state.uri.queryParameters['isFromDealsScreen'] ?? 'false',
      //   ),
      // ),
    ],
  );

  static GoRouter get router => _router;
}
