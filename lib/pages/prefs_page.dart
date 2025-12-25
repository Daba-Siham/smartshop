import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/theme_provider.dart';

class PrefsPage extends StatefulWidget {
  const PrefsPage({super.key});

  @override
  State<PrefsPage> createState() => _PrefsPageState();
}

class _PrefsPageState extends State<PrefsPage> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = prefs.getString("username") ?? "";
    });
  }

  Future<void> savePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("username", nameController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Préférences sauvegardées")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final textTheme = Theme.of(context).textTheme;

    final percent = (themeProvider.fontScale * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Préférences",
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------- Nom utilisateur ----------
            Text(
              "Profil",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom de l'utilisateur",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // --------- Thème clair / sombre ----------
            Text(
              "Apparence",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SwitchListTile(
              title: const Text("Mode sombre"),
              value: themeProvider.isDark,
              onChanged: (v) {
                themeProvider.toggleTheme(v);
              },
            ),

            const SizedBox(height: 24),

            // --------- Taille du texte ----------
            Text(
              "Taille du texte",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Taille actuelle : $percent%"),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        final newScale =
                            (themeProvider.fontScale - 0.1).clamp(0.8, 1.4);
                        themeProvider.setFontScale(newScale.toDouble());
                      },
                    ),
                    Text(
                      percent.toString(),
                      style: textTheme.bodyLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final newScale =
                            (themeProvider.fontScale + 0.1).clamp(0.8, 1.4);
                        themeProvider.setFontScale(newScale.toDouble());
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              "Aperçu de la taille du texte",
              style: textTheme.bodyMedium,
            ),

            const Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: savePrefs,
                child: const Text("Sauvegarder"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
