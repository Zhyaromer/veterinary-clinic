// screens/medicines_page.dart
import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../widgets/medicine_card.dart';
import 'medicine_detail_page.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Medicine> filteredMedicines = List.from(medicines);

  // Filter states
  String _selectedAnimalType = 'All';
  String _selectedCategory = 'All';
  String _selectedManufacturer = 'All';
  String _selectedForm = 'All';
  double _minPrice = 0;
  double _maxPrice = 100;

  final List<String> animalTypes = ['All', 'Dogs', 'Cats', 'Dogs, Cats'];
  final List<String> categories = [
    'All',
    'Antibiotic',
    'Anti-parasitic',
    'Flea & Tick',
    'Pain Relief',
    'Anti-inflammatory',
    'Heartworm Prevention',
  ];
  final List<String> manufacturers = [
    'All',
    'VetPharm International',
    'PetMed Pharmaceuticals',
    'Zoetis Animal Health',
    'Pfizer Animal Health',
    'Boehringer Ingelheim',
    'Merial',
  ];
  final List<String> forms = [
    'All',
    'Injection',
    'Tablet',
    'Chewable Tablet',
    'Oral Suspension',
    'Topical Solution',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterMedicines);

    if (medicines.isNotEmpty) {
      final maxPriceInList = medicines
          .map((m) => m.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 20).ceilToDouble();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMedicines() {
    setState(() {
      filteredMedicines = medicines.where((medicine) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            medicine.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            medicine.category.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesAnimalType =
            _selectedAnimalType == 'All' ||
            medicine.animalType.contains(_selectedAnimalType);

        final matchesCategory =
            _selectedCategory == 'All' ||
            medicine.category == _selectedCategory;

        final matchesManufacturer =
            _selectedManufacturer == 'All' ||
            medicine.manufacturer.name == _selectedManufacturer;

        final matchesForm =
            _selectedForm == 'All' || medicine.form == _selectedForm;

        final matchesPrice =
            medicine.price >= _minPrice && medicine.price <= _maxPrice;

        return matchesSearch &&
            matchesAnimalType &&
            matchesCategory &&
            matchesManufacturer &&
            matchesForm &&
            matchesPrice;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedAnimalType = 'All';
      _selectedCategory = 'All';
      _selectedManufacturer = 'All';
      _selectedForm = 'All';
      _minPrice = 0;
      // Reset max price to actual max from medicines
      final maxPriceInList = medicines
          .map((m) => m.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 20).ceilToDouble();
      _filterMedicines();
    });
  }

  void _showFilterDialog() {
    final maxPriceInList = medicines
        .map((m) => m.price)
        .reduce((a, b) => a > b ? a : b);
    final sliderMaxPrice = (maxPriceInList + 20).ceilToDouble();

    // Local dialog variables
    String dialogAnimalType = _selectedAnimalType;
    String dialogCategory = _selectedCategory;
    String dialogManufacturer = _selectedManufacturer;
    String dialogForm = _selectedForm;
    double dialogMinPrice = _minPrice;
    double dialogMaxPrice = _maxPrice > sliderMaxPrice
        ? sliderMaxPrice
        : _maxPrice;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 730,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        children: const [
                          Icon(Icons.filter_list, color: Color(0xFF4A6FA5)),
                          SizedBox(width: 10),
                          Text(
                            'Filter Medicines',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Animal Type
                              const Text(
                                'Animal Type:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 12,
                                runSpacing: 5,
                                children: animalTypes.map((type) {
                                  return ChoiceChip(
                                    label: Text(type),
                                    selected: dialogAnimalType == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        dialogAnimalType = selected
                                            ? type
                                            : 'All';
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Category
                              const Text(
                                'Category:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 12,
                                runSpacing: 5,
                                children: categories.map((category) {
                                  return ChoiceChip(
                                    label: Text(category),
                                    selected: dialogCategory == category,
                                    onSelected: (selected) {
                                      setState(() {
                                        dialogCategory = selected
                                            ? category
                                            : 'All';
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Manufacturer
                              const Text(
                                'Manufacturer:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: manufacturers.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      title: Text(manufacturers[index]),
                                      value: manufacturers[index],
                                      groupValue: dialogManufacturer,
                                      onChanged: (value) {
                                        setState(() {
                                          dialogManufacturer = value.toString();
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Form
                              const Text(
                                'Form:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 5,
                                children: forms.map((form) {
                                  return ChoiceChip(
                                    label: Text(form),
                                    selected: dialogForm == form,
                                    onSelected: (selected) {
                                      setState(() {
                                        dialogForm = selected ? form : 'All';
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Price Range
                              const Text(
                                'Price Range:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RangeSlider(
                                values: RangeValues(
                                  dialogMinPrice,
                                  dialogMaxPrice,
                                ),
                                min: 0,
                                max: sliderMaxPrice,
                                divisions: (sliderMaxPrice ~/ 10).toInt(),
                                labels: RangeLabels(
                                  '\$${dialogMinPrice.toStringAsFixed(2)}',
                                  '\$${dialogMaxPrice.toStringAsFixed(2)}',
                                ),
                                onChanged: (values) {
                                  setState(() {
                                    dialogMinPrice = values.start;
                                    dialogMaxPrice = values.end;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Min: \$${dialogMinPrice.toStringAsFixed(2)}',
                                  ),
                                  Text(
                                    'Max: \$${dialogMaxPrice.toStringAsFixed(2)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _resetFilters();
                            },
                            child: const Text('Reset All'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedAnimalType = dialogAnimalType;
                                _selectedCategory = dialogCategory;
                                _selectedManufacturer = dialogManufacturer;
                                _selectedForm = dialogForm;
                                _minPrice = dialogMinPrice;
                                _maxPrice = dialogMaxPrice;
                              });
                              Navigator.pop(context);
                              _filterMedicines();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                            ),
                            child: const Text(
                              'Apply Filters',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicines Inventory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicines by name or category...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterMedicines();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _filterMedicines();
              },
            ),
          ),

          if (_selectedAnimalType != 'All' ||
              _selectedCategory != 'All' ||
              _selectedManufacturer != 'All' ||
              _selectedForm != 'All' ||
              _minPrice > 0 ||
              _maxPrice < 100)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Active Filters:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_selectedAnimalType != 'All')
                        Chip(
                          label: Text('Animal: $_selectedAnimalType'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedAnimalType = 'All';
                              _filterMedicines();
                            });
                          },
                        ),
                      if (_selectedCategory != 'All')
                        Chip(
                          label: Text('Category: $_selectedCategory'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _filterMedicines();
                            });
                          },
                        ),
                      if (_selectedManufacturer != 'All')
                        Chip(
                          label: Text('Manufacturer: $_selectedManufacturer'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedManufacturer = 'All';
                              _filterMedicines();
                            });
                          },
                        ),
                      if (_selectedForm != 'All')
                        Chip(
                          label: Text('Form: $_selectedForm'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedForm = 'All';
                              _filterMedicines();
                            });
                          },
                        ),
                      if (_minPrice > 0 || _maxPrice < 100)
                        Chip(
                          label: Text(
                            'Price: \$${_minPrice.toStringAsFixed(2)} - \$${_maxPrice.toStringAsFixed(2)}',
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _minPrice = 0;
                              final maxPriceInList = medicines
                                  .map((m) => m.price)
                                  .reduce((a, b) => a > b ? a : b);
                              _maxPrice = (maxPriceInList + 20).ceilToDouble();
                              _filterMedicines();
                            });
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

          // Results Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredMedicines.length} Medicines Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                if (_selectedAnimalType != 'All' ||
                    _selectedCategory != 'All' ||
                    _selectedManufacturer != 'All' ||
                    _selectedForm != 'All' ||
                    _minPrice > 0 ||
                    _maxPrice < 100 ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Clear All Filters'),
                  ),
              ],
            ),
          ),

          // Medicines Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredMedicines.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.medication_liquid,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No medicines found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Try different search terms or filters',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                            childAspectRatio: 0.84,
                          ),
                      itemCount: filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = filteredMedicines[index];
                        return MedicineCard(
                          medicine: medicine,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicineDetailPage(medicine: medicine),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
