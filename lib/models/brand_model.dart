List<Brand> brandsFromMap(List list) =>
    List<Brand>.from(list.map((x) => Brand.fromMap(x)));

class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.description,
    this.link,
    required this.userRate,
    required this.rate,
    required this.price,
    required this.image,
  });

  final int id;
  final String name;
  final String description;
  final String? link;
  final int userRate;
  final double rate;
  final int price;
  final String image;

  factory Brand.fromMap(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        description: json["description"] ?? '',
        link: json["link"],
        userRate: json["user_rate"].toInt(),
        rate: json["rate"].toDouble(),
        price: json["price"] ?? 0,
        image: json["image"],
      );
}
