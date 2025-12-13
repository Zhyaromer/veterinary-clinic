import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../models/pet_cage.dart';
import '../models/pet_food.dart';
import '../models/pet_toy.dart';
import '../models/sales_report.dart';
import '../widgets/report_widgets.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  late SalesReport report;
  DateTime selectedStartDate = DateTime.now().subtract(
    const Duration(days: 30),
  );
  DateTime selectedEndDate = DateTime.now();
  String selectedFilter = 'Last 30 Days';

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  void _generateReport() {
    setState(() {
      report = SalesReport.generate(
        startDate: selectedStartDate,
        endDate: selectedEndDate,
        medicines: medicines,
        cages: petCages,
        foods: petFoods,
        toys: petToys,
      );
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2025, 12, 31),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          selectedStartDate = picked;
        } else {
          selectedEndDate = picked;
        }
      });
      _generateReport();
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      final now = DateTime.now();

      switch (filter) {
        case 'Last 7 Days':
          selectedStartDate = now.subtract(const Duration(days: 7));
          break;
        case 'Last 30 Days':
          selectedStartDate = now.subtract(const Duration(days: 30));
          break;
        case 'Last 90 Days':
          selectedStartDate = now.subtract(const Duration(days: 90));
          break;
        case 'This Month':
          selectedStartDate = DateTime(now.year, now.month, 1);
          break;
        case 'Last Month':
          final firstDayLastMonth = DateTime(now.year, now.month - 1, 1);
          final lastDayLastMonth = DateTime(now.year, now.month, 0);
          selectedStartDate = firstDayLastMonth;
          selectedEndDate = lastDayLastMonth;
          break;
        case 'Custom Range':
          // Keep existing dates for custom range
          break;
      }
      selectedEndDate = now;
    });
    _generateReport();
  }

  String _getPeriodName() {
    final days = selectedEndDate.difference(selectedStartDate).inDays;
    if (days <= 7) return 'Week';
    if (days <= 30) return 'Month';
    if (days <= 90) return 'Quarter';
    return 'Period';
  }

  @override
  Widget build(BuildContext context) {
    final days = selectedEndDate.difference(selectedStartDate).inDays + 1;
    final showWeekly = days > 14;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Sales Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateReport,
            tooltip: 'Refresh Report',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stats
            _buildReportHeader(),
            const SizedBox(height: 20),

            // Date Range Selector
            _buildDateSelector(),
            const SizedBox(height: 20),

            // Performance Metrics
            _buildPerformanceMetrics(),
            const SizedBox(height: 20),

            // Category Analysis
            _buildCategoryAnalysis(),
            const SizedBox(height: 20),

            if (showWeekly) ...[
              WeeklyRevenueWidget(weeklyRevenue: report.weeklyRevenue),
              const SizedBox(height: 20),
            ],

            // Inventory & Growth Analysis
            Row(
              children: [
                Expanded(
                  child: InventoryAnalysisWidget(
                    inventoryTurnover: report.inventoryTurnover,
                    rating: report.getInventoryRating(),
                    products: report.productSales,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GrowthIndicatorWidget(
                    growthPercentage: report.growthPercentage,
                    period: _getPeriodName(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Growth
            CategoryGrowthWidget(categoryGrowth: report.categoryGrowth),
            const SizedBox(height: 20),

            // Profit Margins
            ProfitMarginWidget(products: report.productSales),
            const SizedBox(height: 20),

            // Top Products
            TopProductsCard(products: report.productSales),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A6FA5), Color(0xFF3B5998)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Report',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${report.totalRevenue.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+${report.growthPercentage.toStringAsFixed(1)}% growth',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.inventory,
                      color: Colors.white.withOpacity(0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${report.totalUnits} units sold',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateSelectorCard('From', selectedStartDate, true),
              const Icon(Icons.arrow_forward, color: Colors.grey, size: 20),
              _buildDateSelectorCard('To', selectedEndDate, false),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Last 7 Days'),
                const SizedBox(width: 8),
                _buildFilterChip('Last 30 Days'),
                const SizedBox(width: 8),
                _buildFilterChip('Last 90 Days'),
                const SizedBox(width: 8),
                _buildFilterChip('This Month'),
                const SizedBox(width: 8),
                _buildFilterChip('Last Month'),
                const SizedBox(width: 8),
                _buildFilterChip('Custom Range'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectorCard(String label, DateTime date, bool isStartDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isStartDate),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8F1FF), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: const Color(0xFF4A6FA5),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SummaryCard(
          title: 'Total Revenue',
          value: '\$${report.totalRevenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.green,
          subtitle: '${report.totalUnits} units sold',
        ),
        SummaryCard(
          title: 'Average Sale',
          value: '\$${report.averageSaleValue.toStringAsFixed(2)}',
          icon: Icons.trending_up,
          color: Colors.blue,
          subtitle: 'Per unit value',
        ),
        SummaryCard(
          title: 'Profit Margin',
          value: '${report.profitMargin.toStringAsFixed(1)}%',
          icon: Icons.pie_chart,
          color: Colors.purple,
          subtitle: 'Net profit ratio',
        ),
        SummaryCard(
          title: 'Performance',
          value: report.getPerformanceRating(),
          icon: Icons.star,
          color: Colors.orange,
          subtitle: 'Growth rating',
        ),
      ],
    );
  }

  Widget _buildCategoryAnalysis() {
    final categorySummaries = report.categorySales.entries.map((entry) {
      return CategorySummary(
        category: entry.key,
        revenue: entry.value,
        unitsSold: report.categoryUnits[entry.key] ?? 0,
        color: categoryColors[entry.key] ?? Colors.grey,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Analysis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        ...categorySummaries.map((summary) {
          final percentage = (summary.revenue / report.totalRevenue) * 100;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CategoryProgressCard(
              category: summary.category,
              revenue: summary.revenue,
              unitsSold: summary.unitsSold,
              percentage: percentage,
              color: summary.color,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () => _applyFilter(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF4A6FA5), Color(0xFF3B5998)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A6FA5) : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A6FA5).withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  void _exportReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Text('Select the export format and data range:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('PDF report generated successfully'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Export as PDF',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Excel report generated successfully'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text(
              'Export as Excel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
