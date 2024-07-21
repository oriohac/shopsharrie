import 'dart:convert';
import 'package:http/http.dart'
    as http;

class Productsdata {
  final String name;
  final List<Photo> photos;
  final String? description;
  final bool isAvailable;
  final double currentprice;
  final double availableQuantity;
  final String uniqueid;
  // final List<String> categories;
  Productsdata(
      {required this.name,
      required this.photos,
      this.description,
      required this.isAvailable,
      required this.currentprice,
      required this.availableQuantity,
      required this.uniqueid,
      // required this.categories
      });

  factory Productsdata.fromJson(dynamic json) {
    var photoList = json['photos'] as List;
    List<Photo> photos = photoList.map((i) => Photo.fromJson(i)).toList();
    var currentPriceJson = json['current_price'][0]['NGN'][0];
    double currentPrice;
    if (currentPriceJson is String) {
      currentPrice = double.tryParse(currentPriceJson) ?? 0.0;
    } else if (currentPriceJson is int) {
      currentPrice = currentPriceJson.toDouble();
    } else if (currentPriceJson is double) {
      currentPrice = currentPriceJson;
    } else {
      currentPrice = 0.0;
    }
    // var categoriesList = json['categories'] as List? ?? [];
    // List<String> categories = categoriesList.map((i) => i as String).toList();
    return Productsdata(
      name: json['name'] ?? '',
      photos: photos,
      description: json['description'] ?? '',
      isAvailable: json['is_available'] ?? false,
      currentprice: currentPrice,
      availableQuantity: json['available_quantity'] ?? 0,
      uniqueid: json['unique_id'] ?? '',
      // categories: categories,
    );
  }
}

class Photo {
  final String url;
  final bool isFeatured;

  Photo({
    required this.url,
    required this.isFeatured,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      url: json['url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
    );
  }
}

class ProductsResponse {
  final List<Productsdata> items;

  ProductsResponse({required this.items});

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['items'] as List;
    List<Productsdata> itemsList =
        list.map((i) => Productsdata.fromJson(i)).toList();

    return ProductsResponse(items: itemsList);
  }
}


