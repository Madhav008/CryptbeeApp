class Coin {
  String fullName;
  String shortForm;
  String image;
  String? status;
  String? type;
  double price;
  double? holding;
  double? changePercent;
  double? orderPrice;
  double? closedPrice;
  double? commision;

  Coin(
      {required this.fullName,
      required this.shortForm,
      required this.image,
      this.type,
      this.status,
      required this.price,
      this.holding,
      this.changePercent,
      this.orderPrice,
      this.closedPrice,
      this.commision});
}
