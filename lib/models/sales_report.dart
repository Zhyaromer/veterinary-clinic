import 'package:flutter/material.dart';

import 'purchase.dart';

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

  double get percentageOfTotal => 0.0;
  String get revenueFormatted => '\$${revenue.toStringAsFixed(2)}';
}

Map<String, Color> categoryColors = {
  'Medicine': const Color(0xFF2196F3),
  'Cage': const Color(0xFFFF9800),
  'Food': const Color(0xFF4CAF50),
  'Toy': const Color(0xFF9C27B0),
};

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

class SalesReport {
  final DateTime startDate;
  final DateTime endDate;
  final List<ProductSale> productSales;
  final Map<String, double> categorySales;
  final Map<String, int> categoryUnits;
  final double totalRevenue;
  final int totalUnits;
  final int averageSaleValue;
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

    double timeScaleFactor = 1.0;
    if (days <= 7) {
      timeScaleFactor = 0.3;
    } else if (days <= 30) {
      timeScaleFactor = 1.0;
    } else if (days <= 90) {
      timeScaleFactor = 3.0;
    } else {
      timeScaleFactor = 4.0;
    }

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

    for (var i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dateStr = '${date.day}/${date.month}';

      final dayOfWeekFactor = date.weekday == 6 || date.weekday == 7
          ? 1.5
          : 1.0;
      final dailyFactor = (1 + (i % 7) * 0.1);

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

    final weeks = (days / 7).ceil();
    for (var i = 0; i < weeks; i++) {
      final weekNum = i + 1;
      final weekRevenue = allProducts.fold(
        0.0,
        (sum, sale) => sum + (sale.revenue / weeks),
      );
      weeklyRevenue['Week $weekNum'] = weekRevenue * timeScaleFactor;
    }

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

      final growthFactor = days <= 30
          ? 0.1
          : days <= 90
          ? 0.25
          : 0.4;
      categoryGrowth[sale.category] =
          growthFactor * (sale.category == 'Food' ? 1.2 : 1.0);
    }

    final totalRevenue =
        allProducts.fold(0.0, (sum, sale) => sum + sale.revenue) *
        timeScaleFactor;
    final totalUnits =
        allProducts.fold(0, (sum, sale) => sum + sale.unitsSold) *
        timeScaleFactor.toInt();
    final int averageSaleValue = totalUnits > 0
        ? (totalRevenue / totalUnits).round()
        : 0;

    final bestSellingCategory = categorySales.entries.isNotEmpty
        ? categorySales.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'No Data';

    final bestSellingProduct = allProducts.isNotEmpty
        ? allProducts.reduce((a, b) => a.unitsSold > b.unitsSold ? a : b).name
        : 'No Data';

    final growthPercentage = days <= 7
        ? 2.5
        : days <= 30
        ? 8.7
        : days <= 90
        ? 15.2
        : 22.4;

    final totalProfit =
        allProducts.fold(0.0, (sum, sale) => sum + sale.profit) *
        timeScaleFactor;
    final profitMargin = totalRevenue > 0
        ? (totalProfit / totalRevenue) * 100
        : 0;

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
      averageSaleValue: averageSaleValue,
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

  static DateTime _dayStart(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _dayEnd(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  static String _dateKey(DateTime date) => '${date.day}/${date.month}';

  static String _categoryFromItemType(String itemType) {
    switch (itemType) {
      case 'medicine':
        return 'Medicine';
      case 'cage':
        return 'Cage';
      case 'food':
        return 'Food';
      case 'toy':
        return 'Toy';
      default:
        return 'Other';
    }
  }

  static double _profitRateForCategory(String category) {
    switch (category) {
      case 'Medicine':
        return 0.35;
      case 'Cage':
        return 0.40;
      case 'Food':
        return 0.30;
      case 'Toy':
        return 0.45;
      default:
        return 0.30;
    }
  }

  factory SalesReport.fromPurchases({
    required DateTime startDate,
    required DateTime endDate,
    required List<Purchase> purchases,
  }) {
    final start = _dayStart(startDate);
    final end = _dayEnd(endDate);
    final days = end.difference(start).inDays + 1;

    bool inRange(DateTime d) => !d.isBefore(start) && !d.isAfter(end);

    final current = purchases.where((p) => inRange(p.purchasedAt)).toList();

    final previousStart = start.subtract(Duration(days: days));
    final previousEnd = start.subtract(const Duration(milliseconds: 1));
    bool inPrevious(DateTime d) =>
        !d.isBefore(previousStart) && !d.isAfter(previousEnd);
    final previous = purchases.where((p) => inPrevious(p.purchasedAt)).toList();

    // Group product sales
    final Map<String, ProductSale> byProduct = {};

    // Daily buckets (fill all days for chart widgets)
    final dailyRevenue = <String, double>{};
    final dailyUnits = <String, int>{};
    for (var i = 0; i < days; i++) {
      final date = start.add(Duration(days: i));
      final key = _dateKey(date);
      dailyRevenue[key] = 0;
      dailyUnits[key] = 0;
    }

    // Weekly buckets
    final weeks = (days / 7).ceil().clamp(1, 10000);
    final weeklyRevenue = <String, double>{
      for (var i = 0; i < weeks; i++) 'Week ${i + 1}': 0,
    };

    for (final p in current) {
      final category = _categoryFromItemType(p.itemType);
      final key = '$category||${p.itemName}';

      final existing = byProduct[key];
      final revenue = p.subtotal;
      final units = p.quantity;
      final profit = revenue * _profitRateForCategory(category);

      if (existing == null) {
        byProduct[key] = ProductSale(
          name: p.itemName,
          category: category,
          subCategory: '',
          unitsSold: units,
          revenue: revenue,
          profit: profit,
          // We don't have reliable stock remaining from purchases alone.
          stockRemaining: 10,
          productType: category,
        );
      } else {
        byProduct[key] = ProductSale(
          name: existing.name,
          category: existing.category,
          subCategory: existing.subCategory,
          unitsSold: existing.unitsSold + units,
          revenue: existing.revenue + revenue,
          profit: existing.profit + profit,
          stockRemaining: existing.stockRemaining,
          productType: existing.productType,
        );
      }

      final dateKey = _dateKey(p.purchasedAt);
      dailyRevenue[dateKey] = (dailyRevenue[dateKey] ?? 0) + revenue;
      dailyUnits[dateKey] = (dailyUnits[dateKey] ?? 0) + units;

      final weekIndex = (p.purchasedAt.difference(start).inDays ~/ 7) + 1;
      final weekKey = 'Week $weekIndex';
      weeklyRevenue[weekKey] = (weeklyRevenue[weekKey] ?? 0) + revenue;
    }

    final productSales = byProduct.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final categorySales = <String, double>{};
    final categoryUnits = <String, int>{};

    for (final sale in productSales) {
      categorySales.update(
        sale.category,
        (v) => v + sale.revenue,
        ifAbsent: () => sale.revenue,
      );
      categoryUnits.update(
        sale.category,
        (v) => v + sale.unitsSold,
        ifAbsent: () => sale.unitsSold,
      );
    }

    final totalRevenue = productSales.fold(0.0, (s, p) => s + p.revenue);
    final totalUnits = productSales.fold(0, (s, p) => s + p.unitsSold);
    final int averageSaleValue = totalUnits > 0
        ? (totalRevenue / totalUnits).round()
        : 0;

    final bestSellingCategory = categorySales.entries.isNotEmpty
        ? categorySales.entries.reduce((a, b) => a.value > b.value ? a : b).key
        : 'No Data';

    final bestSellingProduct = productSales.isNotEmpty
        ? productSales.reduce((a, b) => a.unitsSold > b.unitsSold ? a : b).name
        : 'No Data';

    // Growth vs previous equal-length period
    final prevRevenue = previous.fold(0.0, (s, p) => s + p.subtotal);
    final growthPercentage = prevRevenue == 0
        ? (totalRevenue > 0 ? 100.0 : 0.0)
        : ((totalRevenue - prevRevenue) / prevRevenue) * 100;

    final totalProfit = productSales.fold(0.0, (s, p) => s + p.profit);
    final double profitMargin = totalRevenue > 0
        ? (totalProfit / totalRevenue) * 100
        : 0;

    // Inventory turnover can't be derived from purchases alone.
    final inventoryTurnover = 0.0;

    // Category growth (fraction; widget multiplies by 100)
    final prevByCat = <String, double>{};
    for (final p in previous) {
      final cat = _categoryFromItemType(p.itemType);
      prevByCat.update(cat, (v) => v + p.subtotal, ifAbsent: () => p.subtotal);
    }
    final categoryGrowth = <String, double>{};
    final allCats = <String>{...categorySales.keys, ...prevByCat.keys};
    for (final cat in allCats) {
      final curr = categorySales[cat] ?? 0;
      final prev = prevByCat[cat] ?? 0;
      categoryGrowth[cat] = prev == 0
          ? (curr > 0 ? 1.0 : 0.0)
          : (curr - prev) / prev;
    }

    return SalesReport(
      startDate: start,
      endDate: end,
      productSales: productSales,
      categorySales: categorySales,
      categoryUnits: categoryUnits,
      totalRevenue: totalRevenue,
      totalUnits: totalUnits,
      averageSaleValue: averageSaleValue,
      bestSellingCategory: bestSellingCategory,
      bestSellingProduct: bestSellingProduct,
      dailyRevenue: dailyRevenue,
      dailyUnits: dailyUnits,
      growthPercentage: growthPercentage,
      profitMargin: profitMargin,
      inventoryTurnover: inventoryTurnover,
      weeklyRevenue: weeklyRevenue,
      categoryGrowth: categoryGrowth,
    );
  }

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
