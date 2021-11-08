class Brand {
  Brand(
      {this.image = '', this.name = '', this.description = '', this.price = 0});

  String image;
  String name;
  String description;
  int price;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        image: json["image"],
      );
}
