import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String avatar;
  final String telephone;
  final String address;
  final String job;


  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.avatar,
    required this.telephone,
    required this.address, 
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage(avatar)),
            const SizedBox(height: 16),
            Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text("Profession: $job", style: const TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Email: $email", style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.grey),
                const SizedBox(width: 8),
                Text("Téléphone: $telephone", style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text("Adresse: $address", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ),
              ],
            ),
            
          ],
        ),
      ),
    );
  }
}
