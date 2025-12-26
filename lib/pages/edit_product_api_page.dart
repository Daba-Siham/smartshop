import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class EditProductApiPage extends StatefulWidget {
  const EditProductApiPage({super.key});

  @override
  State<EditProductApiPage> createState() => _EditProductApiPageState();
}

class _EditProductApiPageState extends State<EditProductApiPage> {
  List<Map<String, dynamic>> products = [];
  Map<String, dynamic>? selectedProduct;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  XFile? pickedImage;

  bool loading = false;
  bool loadingProducts = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final data = await ApiService.getProducts();
      setState(() {
        products = data.cast<Map<String, dynamic>>();
        loadingProducts = false;
      });
    } catch (e) {
      setState(() => loadingProducts = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur chargement produits : $e")),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        pickedImage = file;
      });
    }
  }

  Future<void> _edit() async {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choisissez un produit à modifier')),
      );
      return;
    }

    final newName = nameController.text.trim();
    final newDesc = descController.text.trim();
    final priceText = priceController.text.trim();

    if (newName.isEmpty || newDesc.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires')),
      );
      return;
    }

    final newPrice = double.tryParse(priceText);
    if (newPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prix invalide')),
      );
      return;
    }

    setState(() => loading = true);

    try {
      String? imgPathToSend = selectedProduct?['imgPath']?.toString();

      if (pickedImage != null) {
        final file = File(pickedImage!.path);
        imgPathToSend = await ApiService.uploadImage(file); 
      }

      await ApiService.updateProduct(
        id: selectedProduct!['id'] as int,
        name: newName,
        description: newDesc,
        price: newPrice,
        imgPath: imgPathToSend,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit modifié avec succès')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Widget _buildImagePreview() {
    if (pickedImage != null) {
      return Image.file(
        File(pickedImage!.path),
        height: 120,
        fit: BoxFit.cover,
      );
    }

    final existing = selectedProduct?['imgPath']?.toString();
    if (existing != null && existing.isNotEmpty) {
      if (existing.startsWith('http')) {
        return Image.network(
          existing,
          height: 120,
          fit: BoxFit.cover,
        );
      }

      final fullUrl = '${ApiService.serverBase}/uploads/$existing';

      return Image.network(
        fullUrl,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    return const Text("Aucune image");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier un produit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: loadingProducts
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choisir un produit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: selectedProduct,
                      items: products.map((p) {
                        return DropdownMenuItem(
                          value: p,
                          child: Text("${p['id']} — ${p['name']}"),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedProduct = value;
                          pickedImage = null; 
                          nameController.text =
                              selectedProduct?['name']?.toString() ?? '';
                          descController.text =
                              selectedProduct?['description']?.toString() ?? '';
                          priceController.text =
                              selectedProduct?['price']?.toString() ?? '';
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Prix',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Image du produit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildImagePreview(),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Choisir une nouvelle image"),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : _edit,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text("Modifier sur le serveur"),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
