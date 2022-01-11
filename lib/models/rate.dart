List<Rate> ratesFromMap(List list) => List<Rate>.from(
      list.map((x) => Rate.fromMap(x)),
    );

class Rate {
  Rate({
    required this.userId,
    required this.username,
    required this.rate,
    this.text = '',
    required this.time,
  });

  final int userId;
  final String username;
  final double rate;
  final String text;
  final DateTime time;

  factory Rate.fromMap(Map<String, dynamic> json) {
    double rate = json["rate"] ?? 0;
    if (rate < 0) rate = 0;
    if (rate > 5) rate = 10;
    return Rate(
      userId: json["user_id"],
      username: json["username"],
      rate: rate,
      text: json["text"],
      time: DateTime.parse(json["time"]),
    );
  }
}
