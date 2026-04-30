import 'package:flutter/material.dart';

enum CartItemType { food, medicine, toy, cage }

class CartItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  final CartItemType type;
  final Color categoryColor;
  final int maxQuantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.type,
    required this.categoryColor,
    required this.maxQuantity,
  });

  double get subtotal => price * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
    CartItemType? type,
    Color? categoryColor,
    int? maxQuantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      categoryColor: categoryColor ?? this.categoryColor,
      maxQuantity: maxQuantity ?? this.maxQuantity,
    );
  }
}
