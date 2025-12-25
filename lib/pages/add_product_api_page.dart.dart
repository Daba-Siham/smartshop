import 'package:flutter/material.dart';
import 'dart:io';
import '../services/api_service.dart';
import 'package:image_picker/image_picker.dart';



class AddProductApiPage extends StatefulWidget {
  const AddProductApiPage({super.key});

  @override
  State<AddProductApiPage> createState() => _AddProductApiPageState();
}
class _AddProductApiPageState extends State<AddProductApiPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController imgPathController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;

  bool loading = false;

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        pickedImage = img;
      });
    }
  }

  Future<void> _send() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final desc = descController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom et prix sont obligatoires')),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prix invalide')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      String? imgUrl;

      if (pickedImage != null) {
        final file = File(pickedImage!.path);          
        imgUrl = await ApiService.uploadImage(file); 
      }

      await ApiService.addProduct(
        name: name,
        price: price,
        description: desc,
        imgPath: imgUrl, 
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit envoyé avec succès !')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter produit '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom',
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
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Choisir une image depuis la galerie'),
            ),
            const SizedBox(height: 8),
            if (pickedImage != null)
              Text(
                pickedImage!.name,
                style: const TextStyle(fontSize: 12),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : _send,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('Envoyer au serveur'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}