import 'package:checklist_app/app/core/constants/route_constants.dart';
import 'package:checklist_app/app/core/widgets/scaffold_bottom_nav.dart';
import 'package:checklist_app/screens/home/view/home_screen.dart';
import 'package:checklist_app/screens/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:checklist_app/screens/dashboard/view/dashboard_screen.dart';
import 'package:checklist_app/screens/setting/view/setting_screen.dart';

class AppRouter {
  AppRouter();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router => _goRouter;

  late final _goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteConstants.splash,
    onException: (context, state, router) => router.go(RouteConstants.home),
    routes: [
      ..._mainRoute,
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldBottomNav(navigationShell: navigationShell);
        },
        branches: [_homeBranch, _dashboardBranch, _settingBranch],
      ),
    ],
  );

  late final _mainRoute = <RouteBase>[
    GoRoute(
      path: RouteConstants.splash,
      name: RouteConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),
  ];

  late final _homeBranch = StatefulShellBranch(
    initialLocation: RouteConstants.home,
    routes: [
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );

  late final _dashboardBranch = StatefulShellBranch(
    initialLocation: RouteConstants.dashboard,
    routes: [
      GoRoute(
        path: RouteConstants.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );

  late final _settingBranch = StatefulShellBranch(
    initialLocation: RouteConstants.setting,
    routes: [
      GoRoute(
        path: RouteConstants.setting,
        builder: (context, state) => const SettingScreen(),
      ),
    ],
  );
}
