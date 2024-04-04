import 'package:flutter/material.dart';
import 'package:frontend/src/navigation2.0/route_delegate.dart';
import 'package:frontend/src/navigation2.0/route_information_parser.dart';

//import 'navigation/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: MyRouteInformationParser(),
      routerDelegate: MyRouteDelegate(),
      debugShowCheckedModeBanner: false,
      title: 'Universe Creation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
    );
  }
}