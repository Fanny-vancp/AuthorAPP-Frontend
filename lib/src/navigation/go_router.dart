import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/characters.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'characters',
          builder: (BuildContext context, GoRouterState state) {
            return const AllCharacters();
          },
        ),
      ],
    ),
  ],
);