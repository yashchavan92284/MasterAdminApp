import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "price")
  double? price;

  @JsonKey(name: "imageUrls")
  List<String>? imageUrls; // List of image URLs

  @JsonKey(name: "imageNames")
  List<String>? imageNames;

  Product(
      {this.id,
      this.name,
      this.description,
      // this.category,
      // this.image,
      this.price,
      this.imageNames,
      this.imageUrls});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
