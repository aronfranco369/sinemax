import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/requests_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/search_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (_, _) => const SplashScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (_, _) => const SearchScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (_, state) => DetailScreen(contentId: state.pathParameters['id']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _AppShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home',     builder: (_, _) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/discover', builder: (_, _) => const DiscoverScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/requests', builder: (_, _) => const RequestsScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/library',  builder: (_, _) => const LibraryScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/profile',  builder: (_, _) => const ProfileScreen()),
        ]),
      ],
    ),
  ],
);

class SinemaxApp extends StatelessWidget {
  const SinemaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SINEMAX',
      debugShowCheckedModeBanner: false,
      theme: buildSinemaxTheme(),
      routerConfig: _router,
    );
  }
}

class _AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const _AppShell({required this.shell});

  Future<void> _onBack(BuildContext context) async {
    final router = GoRouter.of(context);

    if (router.canPop()) {
      router.pop();
      return;
    }

    if (shell.currentIndex != 0) {
      shell.goBranch(0);
      return;
    }

    final exit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Sinemax?'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Exit')),
        ],
      ),
    );
    if (exit == true && context.mounted) SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => _onBack(context),
      child: Scaffold(
        body: shell,
        bottomNavigationBar: SinemaxBottomNav(
          currentIndex: shell.currentIndex,
          onTap: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        ),
      ),
    );
  }
}
