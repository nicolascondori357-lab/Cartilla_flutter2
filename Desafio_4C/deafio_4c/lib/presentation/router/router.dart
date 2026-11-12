import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/inicio_screen.dart';
import '../screens/login_screen.dart';
import '../screens/posts_screen.dart';
import '../screens/detalle_screen.dart';
import '../screens/perfil_screen.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;

    int seccion = 0;

    if (location.startsWith('/posts')) seccion = 1;
    if (location.startsWith('/profile')) seccion = 2;

    return Scaffold(
      body: child,

      bottomNavigationBar: NavigationBar(
        selectedIndex: seccion,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/posts');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (context, state) {
    final bool esLogin = state.uri.path == '/login';

    if (!sesionIniciada && !esLogin) {
      return '/login';
    }

    if (sesionIniciada && esLogin) {
      return '/';
    }

    return null;
  },

  routes: [
   
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const InicioScreen(),
        ),

        GoRoute(
          path: '/posts',
          builder: (context, state) => const PostsScreen(),

          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final int id = int.parse(
                  state.pathParameters['id']!,
                );

                return DetalleScreen(postId: id);
              },
            ),
          ],
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const PerfilScreen(),
        ),
      ],
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],

  // Pantalla para rutas inexistentes
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Página no encontrada: ${state.uri}'),
    ),
  ),
);