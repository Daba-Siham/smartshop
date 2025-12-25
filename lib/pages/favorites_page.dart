import 'package:flutter/material.dart';
import '../services/db_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Map<String, dynamic>>> _load() => getFavorites();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoris")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _load(), 
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}"));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("Aucun favori"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              final p = data[index];
              return ListTile(
                leading: Image.asset(p["imagePath"], width: 50, height: 50),
                title: Text(p["name"]),
                subtitle: Text("${p["price"]} DH"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await deleteFavoriteByName(p["name"]);
                    setState(() {}); 
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
