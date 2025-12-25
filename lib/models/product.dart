class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final String category;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json["id"] as num).toInt(),
      name: json["name"].toString(),
      price: (json["price"] as num).toDouble(),
      image: json["image"].toString(),
      description: json["description"].toString(),
      category: json["category"].toString(),
      rating: (json["rating"] as num).toDouble(),
    );
  }
}
