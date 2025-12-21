import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsPage extends StatefulWidget {
  const PrefsPage({super.key});

  @override
  State<PrefsPage> createState() => _PrefsPageState();
}

class _PrefsPageState extends State<PrefsPage> {
  TextEditingController nameController = TextEditingController();
  bool darkMode = false;
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  Future<void> loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      nameController.text = prefs.getString("username") ?? "";
      darkMode = prefs.getBool("darkmode") ?? false;
      cartCount = prefs.getInt("cart") ?? 0;
    });
  }

  Future<void> savePrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("username", nameController.text);
    await prefs.setBool("darkmode", darkMode);
    await prefs.setInt("cart", cartCount);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Préférences sauvegardées")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Préférences")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom de l'utilisateur",
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text("Mode sombre"),
              value: darkMode,
              onChanged: (v) => setState(() => darkMode = v),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Articles dans le panier", style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (cartCount > 0) {
                          setState(() => cartCount--);
                        }
                      },
                    ),
                    Text(cartCount.toString(), style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => cartCount++);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: savePrefs,
                child: const Text("Sauvegarder"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
