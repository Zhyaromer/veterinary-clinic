import 'package:flutter/material.dart';

// Product Sale Class
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

// Category Summary Class
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

  double get percentageOfTotal => 0.0; // Will be calculated later
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

// Main Sales Report Class
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
  final Map<String, int> dailyUnits;
  final double growthPercentage;
  final double profitMargin;
  final double inventoryTurnover;
  final Map<String, double> weeklyRevenue;
  final Map<String, double> categoryGrowth;

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
    required this.dailyUnits,
    required this.growthPercentage,
    required this.profitMargin,
    required this.inventoryTurnover,
    required this.weeklyRevenue,
    required this.categoryGrowth,
  });

  factory SalesReport.generate({
    required DateTime startDate,
    required DateTime endDate,
    required List medicines,
    required List cages,
    required List foods,
    required List toys,
  }) {
    final days = endDate.difference(startDate).inDays + 1;
    final allProducts = <ProductSale>[];
    final dailyRevenue = <String, double>{};
    final dailyUnits = <String, int>{};
    final weeklyRevenue = <String, double>{};

    // Determine scale factor based on time period
    double timeScaleFactor = 1.0;
    if (days <= 7) {
      timeScaleFactor = 0.3; // Less sales in short period
    } else if (days <= 30) {
      timeScaleFactor = 1.0; // Normal scale
    } else if (days <= 90) {
      timeScaleFactor = 3.0; // More sales in longer period
    } else {
      timeScaleFactor = 4.0; // Extended period
    }

    // Generate sales for medicines
    for (var medicine in medicines) {
      final baseUnits = (medicine.stock * 0.1).round();
      final unitsSold = (baseUnits * timeScaleFactor).round().clamp(
        0,
        medicine.stock,
      );
      final revenue = medicine.price * unitsSold;
      final profit = revenue * 0.35;

      allProducts.add(
        ProductSale(
          name: medicine.name,
          category: 'Medicine',
          subCategory: medicine.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: profit,
          stockRemaining: medicine.stock - unitsSold,
          productType: 'Medicine',
        ),
      );
    }

    // Generate sales for cages
    for (var cage in cages) {
      final baseUnits = (cage.stock * 0.05).round();
      final unitsSold = (baseUnits * timeScaleFactor).round().clamp(
        0,
        cage.stock,
      );
      final revenue = cage.price * unitsSold;
      final profit = revenue * 0.40;

      allProducts.add(
        ProductSale(
          name: cage.name,
          category: 'Cage',
          subCategory: cage.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: profit,
          stockRemaining: cage.stock - unitsSold,
          productType: 'Cage',
        ),
      );
    }

    // Generate sales for foods
    for (var food in foods) {
      final baseUnits = (food.stock * 0.15).round();
      final unitsSold = (baseUnits * timeScaleFactor).round().clamp(
        0,
        food.stock,
      );
      final revenue = food.price * unitsSold;
      final profit = revenue * 0.30;

      allProducts.add(
        ProductSale(
          name: food.name,
          category: 'Food',
          subCategory: food.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: profit,
          stockRemaining: food.stock - unitsSold,
          productType: 'Food',
        ),
      );
    }

    // Generate sales for toys
    for (var toy in toys) {
      final baseUnits = (toy.stock * 0.12).round();
      final unitsSold = (baseUnits * timeScaleFactor).round().clamp(
        0,
        toy.stock,
      );
      final revenue = toy.price * unitsSold;
      final profit = revenue * 0.45;

      allProducts.add(
        ProductSale(
          name: toy.name,
          category: 'Toy',
          subCategory: toy.category,
          unitsSold: unitsSold,
          revenue: revenue,
          profit: profit,
          stockRemaining: toy.stock - unitsSold,
          productType: 'Toy',
        ),
      );
    }

    // Generate daily revenue and units data
    for (var i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = '${date.day}/${date.month}';

      // Simulate daily variations
      final dayOfWeekFactor = date.weekday == 6 || date.weekday == 7
          ? 1.5
          : 1.0; // Weekend boost
      final dailyFactor = (1 + (i % 7) * 0.1); // Weekly pattern

      final dailyTotal = allProducts.fold(
        0.0,
        (sum, sale) => sum + (sale.revenue / days),
      );
      final unitsTotal = allProducts.fold(
        0,
        (sum, sale) => sum + (sale.unitsSold ~/ days),
      );

      dailyRevenue[dateStr] =
          (dailyTotal * dailyFactor * dayOfWeekFactor) * timeScaleFactor;
      dailyUnits[dateStr] =
          (unitsTotal * dailyFactor * dayOfWeekFactor).round() *
          timeScaleFactor.toInt();
    }

    // Generate weekly revenue
    final weeks = (days / 7).ceil();
    for (var i = 0; i < weeks; i++) {
      final weekNum = i + 1;
      final weekRevenue = allProducts.fold(
        0.0,
        (sum, sale) => sum + (sale.revenue / weeks),
      );
      weeklyRevenue['Week $weekNum'] = weekRevenue * timeScaleFactor;
    }

    // Calculate category sales
    final categorySales = <String, double>{};
    final categoryUnits = <String, int>{};
    final categoryGrowth = <String, double>{};

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

      // Simulate category growth based on time period
      final growthFactor = days <= 30
          ? 0.1
          : days <= 90
          ? 0.25
          : 0.4;
      categoryGrowth[sale.category] =
          growthFactor * (sale.category == 'Food' ? 1.2 : 1.0);
    }

    // Calculate totals
    final totalRevenue =
        allProducts.fold(0.0, (sum, sale) => sum + sale.revenue) *
        timeScaleFactor;
    final totalUnits =
        allProducts.fold(0, (sum, sale) => sum + sale.unitsSold) *
        timeScaleFactor.toInt();
    final averageSaleValue = totalUnits > 0 ? totalRevenue / totalUnits : 0;

    // Find best sellers
    final bestSellingCategory = categorySales.entries.isNotEmpty
        ? categorySales.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'No Data';

    final bestSellingProduct = allProducts.isNotEmpty
        ? allProducts.reduce((a, b) => a.unitsSold > b.unitsSold ? a : b).name
        : 'No Data';

    // Calculate growth percentage (simulated based on time period)
    final growthPercentage = days <= 7
        ? 2.5
        : days <= 30
        ? 8.7
        : days <= 90
        ? 15.2
        : 22.4;

    // Calculate profit margin
    final totalProfit =
        allProducts.fold(0.0, (sum, sale) => sum + sale.profit) *
        timeScaleFactor;
    final profitMargin = totalRevenue > 0
        ? (totalProfit / totalRevenue) * 100
        : 0;

    // Calculate inventory turnover
    final totalCost = totalRevenue - totalProfit;
    final averageInventory = allProducts.isNotEmpty
        ? allProducts.fold(0.0, (sum, sale) => sum + sale.stockRemaining) /
              allProducts.length
        : 0;
    final inventoryTurnover = averageInventory > 0
        ? totalCost / averageInventory
        : 0;

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
      dailyUnits: dailyUnits,
      growthPercentage: growthPercentage,
      profitMargin: profitMargin as double,
      inventoryTurnover: inventoryTurnover as double,
      weeklyRevenue: weeklyRevenue,
      categoryGrowth: categoryGrowth,
    );
  }

  // Get performance rating
  String getPerformanceRating() {
    if (growthPercentage >= 20) return 'Excellent';
    if (growthPercentage >= 10) return 'Good';
    if (growthPercentage >= 5) return 'Average';
    return 'Needs Improvement';
  }

  // Get inventory rating
  String getInventoryRating() {
    if (inventoryTurnover >= 8) return 'Fast';
    if (inventoryTurnover >= 5) return 'Optimal';
    if (inventoryTurnover >= 3) return 'Slow';
    return 'Stagnant';
  }
}
