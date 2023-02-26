class ProductModel {
  String productName;
  String productImage;
  int productPrice;
  String productId;
  int? productQuantity;
  List<dynamic>? productUnit;
  ProductModel(
      {
        this.productQuantity,
       required this.productId,
        this.productUnit,
        required this.productImage,
        required this.productName,
        required this.productPrice});
}