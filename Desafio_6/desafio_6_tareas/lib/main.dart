import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'presentation/screens/tareas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('preferencias');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('preferencias');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),

      builder: (context, box, _) {
        final bool modoOscuro =
            box.get('modoOscuro', defaultValue: false);

        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Mis tareas',

          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
          ),

          themeMode: modoOscuro
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const TareasScreen(),
        );
      },
    );
  }
}