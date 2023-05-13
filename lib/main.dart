import 'package:flutter/material.dart';
import 'package:healthroom_app/provider/usuario_provider.dart';
import 'package:healthroom_app/routes.dart';
import 'package:healthroom_app/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthroom_app/screen/loading_screen.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UsuarioProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível iniciar a aplicação'),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              title: 'Health Room',
              theme: appTheme,
              routes: appRoutes,
              debugShowCheckedModeBanner: false,
            );
          }

          return const Loading();
        });
  }
}
