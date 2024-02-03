class Crypto {
  String? id;
  String? rank;
  String? symbol;
  double? price;
  double? changePercent24Hr;

  Crypto(this.id, this.rank, this.symbol, this.price, this.changePercent24Hr);

  factory Crypto.withJson(Map<String, dynamic> jsonMapObject) {
    return Crypto(
      jsonMapObject["id"],
      jsonMapObject["rank"],
      jsonMapObject["symbol"],
      double.parse(jsonMapObject["priceUsd"]),
      double.parse(jsonMapObject["changePercent24Hr"]),
    );
  }
}
