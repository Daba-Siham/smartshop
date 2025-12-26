import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ApiProductPage extends StatefulWidget {
  const ApiProductPage({super.key});

  @override
  State<ApiProductPage> createState() => _ApiProductPageState();
}

class _ApiProductPageState extends State<ApiProductPage> {
  late Future<List<ApiProduct>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.fetchProducts();
  }

  void _reload() {
    setState(() {
      futureProducts = ApiService.fetchProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await ApiService.deleteProduct(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supprimé sur le serveur')),
      );
      _reload();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produits '),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<ApiProduct>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Text('Aucun produit sur le serveur'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: (p.imgPath != null && p.imgPath!.isNotEmpty)
                    ? Image.network(
                        p.imgPath!.startsWith('http')
                            ? p.imgPath! 
                            : '${ApiService.serverBase}/uploads/${p.imgPath!}', // nouveau format : filename
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            child: Text(p.id.toString()),
                          );
                        },
                      )
                    : CircleAvatar(
                        child: Text(p.id.toString()),
                      ),
                title: Text(p.name),
                subtitle: Text(
                  '${p.price} DH\n${p.description}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _deleteProduct(p.id),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
