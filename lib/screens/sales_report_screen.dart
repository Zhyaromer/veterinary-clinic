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
      }
      selectedEndDate = now;
    });
    _generateReport();
  }

  @override
  Widget build(BuildContext context) {
    final categorySummaries = report.categorySales.entries.map((entry) {
      return CategorySummary(
        category: entry.key,
        revenue: entry.value,
        unitsSold: report.categoryUnits[entry.key] ?? 0,
        color: categoryColors[entry.key] ?? Colors.grey,
      );
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        title: const Text(
          'Sales Report',
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
            icon: const Icon(Icons.download),
            onPressed: () {
              // Export report functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Report exported successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Range Selector
            Container(
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
                      _buildDateSelector('From', selectedStartDate, true),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      _buildDateSelector('To', selectedEndDate, false),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Cards
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
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
                  title: 'Best Category',
                  value: report.bestSellingCategory,
                  icon: Icons.star,
                  color: Colors.orange,
                  subtitle: 'By revenue',
                ),
                SummaryCard(
                  title: 'Best Product',
                  value: report.bestSellingProduct.split(' ').take(3).join(' '),
                  icon: Icons.leaderboard,
                  color: Colors.purple,
                  subtitle: 'Most units sold',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Category Breakdown
            Text(
              'Category Breakdown',
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
            const SizedBox(height: 20),

            SizedBox(child: ProfitMarginWidget(products: report.productSales)),
            const SizedBox(height: 20),

            // Top Products
            TopProductsCard(products: report.productSales),
            const SizedBox(height: 20),

            // Export Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Export Report'),
                      content: const Text('Select export format:'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'PDF report generated successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text('PDF'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Excel report generated successfully',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text('Excel'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.download_outlined),
                label: const Text(
                  'Export Full Report',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime date, bool isStartDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(context, isStartDate),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: const Color(0xFF4A6FA5),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () => _applyFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A6FA5) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF4A6FA5) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
