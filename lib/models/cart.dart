import 'package:flutter/material.dart';
import 'cart_item.dart';

class Cart {
  static final Cart _instance = Cart._internal();

  final List<CartItem> _items = [];
  final ValueNotifier<int> _itemCountNotifier = ValueNotifier<int>(0);

  factory Cart() {
    return _instance;
  }

  Cart._internal();

  List<CartItem> get items => _items;
  ValueNotifier<int> get itemCountNotifier => _itemCountNotifier;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.subtotal);

  double get tax => subtotal * 0.1;

  double get total => subtotal + tax;

  void addItem(CartItem item) {
    // Check if item already exists
    final existingIndex = _items.indexWhere((i) => i.id == item.id);

    if (existingIndex >= 0) {
      // Item exists, update quantity but respect stock limit
      final maxQuantity = item.maxQuantity;
      final newQuantity = _items[existingIndex].quantity + item.quantity;

      _items[existingIndex] = _items[existingIndex].copyWith(
        quantity: newQuantity > maxQuantity ? maxQuantity : newQuantity,
      );
    } else {
      // New item
      _items.add(item);
    }
    _itemCountNotifier.value = itemCount;
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final maxQuantity = _items[index].maxQuantity;
      final finalQuantity = newQuantity > maxQuantity
          ? maxQuantity
          : newQuantity;

      _items[index] = _items[index].copyWith(quantity: finalQuantity);
      _itemCountNotifier.value = itemCount;
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _itemCountNotifier.value = itemCount;
  }

  void clearCart() {
    _items.clear();
    _itemCountNotifier.value = 0;
  }

  bool hasItems() => _items.isNotEmpty;

  // Check if item exists in cart
  CartItem? getItem(String itemId) {
    try {
      return _items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }
}
