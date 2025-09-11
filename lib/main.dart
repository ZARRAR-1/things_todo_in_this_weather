import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_module/screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Locked orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// This widget is the root of your application:
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      debugShowFloatingThemeButton: true,
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primarySwatch: Colors.blue, // Example primary color
        // You can customize many other properties:
        // scaffoldBackgroundColor: Colors.white,
        // appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // buttonTheme: ButtonThemeData(...),
        // inputDecorationTheme: InputDecorationTheme(...),
        // cardTheme: CardTheme(...),
        // colorScheme: ColorScheme.light(primary: Colors.blue, secondary: Colors.amber),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch:
            Colors.blue, // You might want a different primary for dark mode
        // Or define specific dark theme colors:
        // scaffoldBackgroundColor: Colors.grey[850],
        // appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
        textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white70),
            bodyMedium: TextStyle(color: Colors.white54),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        // buttonTheme: ButtonThemeData(...),
        // inputDecorationTheme: InputDecorationTheme(...),
        // cardTheme: CardTheme(color: Colors.grey[800]),
        // colorScheme: ColorScheme.dark(primary: Colors.lightBlue, secondary: Colors.orangeAccent),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (ThemeData light, ThemeData dark) {
        return MaterialApp(
          title: 'LogicEra',
          theme: light,
          darkTheme: dark,
          home: const UserAuthPage(),
        );
      },
    );
  }
}
