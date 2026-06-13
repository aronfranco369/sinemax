import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'data/fcm_service.dart';
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
import 'widgets/offline_banner.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
    GoRoute(
      path: '/detail/:id',
      builder: (_, state) => DetailScreen(contentId: state.pathParameters['id']!),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/discover', builder: (_, _) => const DiscoverScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/requests', builder: (_, _) => const RequestsScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/library', builder: (_, _) => const LibraryScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen())],
        ),
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
      routerConfig: appRouter,
      // Global offline banner — overlays every route, never blocks the UI.
      builder: (context, child) => ConnectivityOverlay(child: child!),
    );
  }
}

class _AppShell extends StatefulWidget {
  final StatefulNavigationShell shell;
  const _AppShell({required this.shell});

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  @override
  void initState() {
    super.initState();
    FcmService.init();
  }

  Future<void> _onBack(BuildContext context) async {
    final router = GoRouter.of(context);

    if (router.canPop()) {
      router.pop();
      return;
    }

    if (widget.shell.currentIndex != 0) {
      widget.shell.goBranch(0);
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
        body: widget.shell,
        bottomNavigationBar: SinemaxBottomNav(
          currentIndex: widget.shell.currentIndex,
          onTap: (i) => widget.shell.goBranch(i, initialLocation: i == widget.shell.currentIndex),
        ),
      ),
    );
  }
}
