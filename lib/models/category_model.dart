class CategoryModel {
  String idCategory;
  String nameCategory;
  String imageUrlCategory;
  String descriptionCategory;
  String uploadedBy;
  CategoryModel(
      {
        required this.idCategory,
        required this.nameCategory,
        required this.imageUrlCategory,
        required this.descriptionCategory,
        required this.uploadedBy
      });
}