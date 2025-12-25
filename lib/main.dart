import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/main_screen.dart';
import 'providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartShopApp());
}

class SmartShopApp extends StatelessWidget {
  const SmartShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final baseLight = ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          );

          final baseDark = ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SmartShop',
            theme: baseLight,
            darkTheme: baseDark,
            themeMode: themeProvider.themeMode,

            // 🔥 ICI on applique la taille de texte globale
            builder: (context, child) {
              final mediaQuery = MediaQuery.of(context);
              return MediaQuery(
                data: mediaQuery.copyWith(
                  textScaleFactor: themeProvider.fontScale, // 0.8 → 1.4
                ),
                child: child!,
              );
            },

            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
