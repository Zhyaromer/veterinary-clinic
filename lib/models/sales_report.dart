import 'package:flutter/material.dart';
import 'package:vet_clinic/models/medicine.dart';
import 'package:vet_clinic/models/pet_cage.dart';
import 'package:vet_clinic/models/pet_food.dart';
import 'package:vet_clinic/models/pet_toy.dart';

class SalesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<ProductSale> productSales;
  final Map<String, double> categorySales;
  final Map<String, int> categoryUnits;
  final double totalRevenue;
  final int totalUnits;
  final double averageSaleValue;
  final String bestSellingCategory;
  final String bestSellingProduct;
  final Map<String, double> dailyRevenue;

  SalesReport({
    required this.startDate,
    required this.endDate,
    required this.productSales,
    required this.categorySales,
    required this.categoryUnits,
    required this.totalRevenue,
    required this.totalUnits,
    required this.averageSaleValue,
    required this.bestSellingCategory,
    required this.bestSellingProduct,
    required this.dailyRevenue,
  });

  factory SalesReport.generate({
    required DateTime startDate,
    required DateTime endDate,
    required List<Medicine> medicines,
    required List<PetCage> cages,
    required List<PetFood> foods,
    required List<PetToy> toys,
  }) {
    final allProducts = <ProductSale>[];

    // Generate sample sales data for medicines
    for (var medicine in medicines) {
      final unitsSold = (medicine.stock * 0.3).round(); // 30% of stock sold
      final revenue = medicine.price * unitsSold;
      allProducts.add(
        ProductSale(
          name: medicine.name,
          category: 'Medicine',
          subCategory: medicine.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: revenue * 0.35, // 35% profit margin
          stockRemaining: medicine.stock - unitsSold,
          productType: 'Medicine',
        ),
      );
    }

    // Generate sample sales data for cages
    for (var cage in cages) {
      final unitsSold = (cage.stock * 0.25).round(); // 25% of stock sold
      final revenue = cage.price * unitsSold;
      allProducts.add(
        ProductSale(
          name: cage.name,
          category: 'Cage',
          subCategory: cage.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: revenue * 0.40, // 40% profit margin
          stockRemaining: cage.stock - unitsSold,
          productType: 'Cage',
        ),
      );
    }

    // Generate sample sales data for foods
    for (var food in foods) {
      final unitsSold = (food.stock * 0.45).round(); // 45% of stock sold
      final revenue = food.price * unitsSold;
      allProducts.add(
        ProductSale(
          name: food.name,
          category: 'Food',
          subCategory: food.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: revenue * 0.30, // 30% profit margin
          stockRemaining: food.stock - unitsSold,
          productType: 'Food',
        ),
      );
    }

    // Generate sample sales data for toys
    for (var toy in toys) {
      final unitsSold = (toy.stock * 0.35).round(); // 35% of stock sold
      final revenue = toy.price * unitsSold;
      allProducts.add(
        ProductSale(
          name: toy.name,
          category: 'Toy',
          subCategory: toy.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: revenue * 0.45, // 45% profit margin
          stockRemaining: toy.stock - unitsSold,
          productType: 'Toy',
        ),
      );
    }

    // Calculate category sales
    final categorySales = <String, double>{};
    final categoryUnits = <String, int>{};

    for (var sale in allProducts) {
      categorySales.update(
        sale.category,
        (value) => value + sale.revenue,
        ifAbsent: () => sale.revenue,
      );

      categoryUnits.update(
        sale.category,
        (value) => value + sale.unitsSold,
        ifAbsent: () => sale.unitsSold,
      );
    }

    // Calculate totals
    final totalRevenue = allProducts.fold(
      0.0,
      (sum, sale) => sum + sale.revenue,
    );
    final totalUnits = allProducts.fold(0, (sum, sale) => sum + sale.unitsSold);
    final averageSaleValue = totalUnits > 0 ? totalRevenue / totalUnits : 0;

    // Find best sellers
    final bestSellingCategory = categorySales.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    final bestSellingProduct = allProducts
        .reduce((a, b) => a.unitsSold > b.unitsSold ? a : b)
        .name;

    // Generate daily revenue (sample data)
    final dailyRevenue = <String, double>{};
    final days = endDate.difference(startDate).inDays + 1;

    for (var i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = '${date.day}/${date.month}';
      // Random revenue between $500 and $5000
      dailyRevenue[dateStr] = 500.0 + (i * 200.0);
    }

    return SalesReport(
      startDate: startDate,
      endDate: endDate,
      productSales: allProducts,
      categorySales: categorySales,
      categoryUnits: categoryUnits,
      totalRevenue: totalRevenue,
      totalUnits: totalUnits,
      averageSaleValue: averageSaleValue as double,
      bestSellingCategory: bestSellingCategory,
      bestSellingProduct: bestSellingProduct,
      dailyRevenue: dailyRevenue,
    );
  }
}

class ProductSale {
  final String name;
  final String category;
  final String subCategory;
  final int unitsSold;
  final double revenue;
  final double profit;
  final int stockRemaining;
  final String productType;

  ProductSale({
    required this.name,
    required this.category,
    required this.subCategory,
    required this.unitsSold,
    required this.revenue,
    required this.profit,
    required this.stockRemaining,
    required this.productType,
  });

  double get profitMargin => revenue > 0 ? (profit / revenue) * 100 : 0;
  String get revenueFormatted => '\$${revenue.toStringAsFixed(2)}';
  String get profitFormatted => '\$${profit.toStringAsFixed(2)}';
  String get profitMarginFormatted => '${profitMargin.toStringAsFixed(1)}%';
}

class CategorySummary {
  final String category;
  final double revenue;
  final int unitsSold;
  final Color color;

  CategorySummary({
    required this.category,
    required this.revenue,
    required this.unitsSold,
    required this.color,
  });

  double get percentageOfTotal {
    // This will be calculated relative to total
    return 0.0;
  }

  String get revenueFormatted => '\$${revenue.toStringAsFixed(2)}';
}

// Category colors
Map<String, Color> categoryColors = {
  'Medicine': const Color(0xFF2196F3),
  'Cage': const Color(0xFFFF9800),
  'Food': const Color(0xFF4CAF50),
  'Toy': const Color(0xFF9C27B0),
};

// Get icon for category
IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Medicine':
      return Icons.medical_services;
    case 'Cage':
      return Icons.home;
    case 'Food':
      return Icons.restaurant;
    case 'Toy':
      return Icons.toys;
    default:
      return Icons.category;
  }
}
