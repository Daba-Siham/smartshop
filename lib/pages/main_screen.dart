import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'favorites_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      CartPage(),
      const FavoritesPage(),
      ProfilePage(
        name: HomePage.profile['name']!,
        email: HomePage.profile['email']!,
        avatar: HomePage.profile['avatar']!,
        telephone: HomePage.profile['telephone']!,
        address: HomePage.profile['address']!,
        job: HomePage.profile['job']!,
      ),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (newIndex) => setState(() => index = newIndex),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Panier"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoris"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}
