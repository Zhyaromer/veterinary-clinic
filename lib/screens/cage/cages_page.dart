// screens/cages_page.dart
import 'package:flutter/material.dart';
import '../../models/pet_cage.dart';
import '../../widgets/pet_cage_card.dart';
import 'cage_detail_page.dart';

class CagesPage extends StatefulWidget {
  const CagesPage({super.key});

  @override
  State<CagesPage> createState() => _CagesPageState();
}

class _CagesPageState extends State<CagesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetCage> filteredCages = List.from(petCages);

  // Filter states
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  double _minPrice = 0;
  double _maxPrice = 300;

  final List<String> petTypes = ['All', 'Dog', 'Cat', 'Bird', 'Small Animal'];
  final List<String> categories = [
    'All',
    'Dog Crate',
    'Cat Condo',
    'Bird Cage',
    'Small Animal Habitat',
    'Travel Carrier',
    'Outdoor Kennel',
    'Playpen',
  ];
  final List<String> brands = [
    'All',
    'PetSafe',
    'Whisker City',
    'Prevue Hendryx',
    'Kaytee',
    'Sherpa',
    'Frisco',
    'IRIS',
    'Midwest',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCages);

    // Calculate max price
    if (petCages.isNotEmpty) {
      final maxPriceInList = petCages
          .map((c) => c.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 50).ceilToDouble();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCages() {
    setState(() {
      filteredCages = petCages.where((cage) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            cage.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            cage.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            cage.category.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesPetType =
            _selectedPetType == 'All' || cage.petType == _selectedPetType;

        final matchesCategory =
            _selectedCategory == 'All' || cage.category == _selectedCategory;

        final matchesBrand =
            _selectedBrand == 'All' || cage.brand == _selectedBrand;

        final matchesPrice = cage.price >= _minPrice && cage.price <= _maxPrice;

        return matchesSearch &&
            matchesPetType &&
            matchesCategory &&
            matchesBrand &&
            matchesPrice;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedPetType = 'All';
      _selectedCategory = 'All';
      _selectedBrand = 'All';
      _minPrice = 0;
      final maxPriceInList = petCages
          .map((c) => c.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 50).ceilToDouble();
      _filterCages();
    });
  }

  void _showFilterDialog() {
    final maxPriceInList = petCages
        .map((c) => c.price)
        .reduce((a, b) => a > b ? a : b);
    final sliderMaxPrice = (maxPriceInList + 50).ceilToDouble();

    // Local dialog variables
    String dialogPetType = _selectedPetType;
    String dialogCategory = _selectedCategory;
    String dialogBrand = _selectedBrand;
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
                  maxHeight: 640,
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
                            'Filter Cages & Habitats',
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
                              // Pet Type Filter
                              const Text(
                                'Pet Type:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 12,
                                runSpacing: 5,
                                children: petTypes.map((type) {
                                  return ChoiceChip(
                                    label: Text(type),
                                    selected: dialogPetType == type,
                                    onSelected: (selected) {
                                      setState(() {
                                        dialogPetType = selected ? type : 'All';
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 16),

                              // Category Filter
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

                              // Brand Filter
                              const Text(
                                'Brand:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: brands.length,
                                  itemBuilder: (context, index) {
                                    return RadioListTile(
                                      title: Text(brands[index]),
                                      value: brands[index],
                                      groupValue: dialogBrand,
                                      onChanged: (value) {
                                        setState(() {
                                          dialogBrand = value.toString();
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Price Range
                              const Text(
                                'Price Range:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              RangeSlider(
                                values: RangeValues(
                                  dialogMinPrice,
                                  dialogMaxPrice,
                                ),
                                min: 0,
                                max: sliderMaxPrice,
                                divisions: (sliderMaxPrice ~/ 25).toInt(),
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
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Max: \$${dialogMaxPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Actions
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
                                _selectedPetType = dialogPetType;
                                _selectedCategory = dialogCategory;
                                _selectedBrand = dialogBrand;
                                _minPrice = dialogMinPrice;
                                _maxPrice = dialogMaxPrice;
                              });
                              Navigator.pop(context);
                              _filterCages();
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
          'Cages & Habitats',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cages by name, category, or description...',
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
                          _filterCages();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _filterCages();
              },
            ),
          ),

          // Active Filters (Only show if any filter is active)
          if (_selectedPetType != 'All' ||
              _selectedCategory != 'All' ||
              _selectedBrand != 'All' ||
              _minPrice > 0 ||
              _maxPrice < 300)
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
                      if (_selectedPetType != 'All')
                        Chip(
                          label: Text('Pet: $_selectedPetType'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedPetType = 'All';
                              _filterCages();
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
                              _filterCages();
                            });
                          },
                        ),
                      if (_selectedBrand != 'All')
                        Chip(
                          label: Text('Brand: $_selectedBrand'),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _selectedBrand = 'All';
                              _filterCages();
                            });
                          },
                        ),
                      if (_minPrice > 0 || _maxPrice < 300)
                        Chip(
                          label: Text(
                            'Price: \$${_minPrice.toStringAsFixed(2)} - \$${_maxPrice.toStringAsFixed(2)}',
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _minPrice = 0;
                              final maxPriceInList = petCages
                                  .map((c) => c.price)
                                  .reduce((a, b) => a > b ? a : b);
                              _maxPrice = (maxPriceInList + 50).ceilToDouble();
                              _filterCages();
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
                  '${filteredCages.length} Cages Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                if (_selectedPetType != 'All' ||
                    _selectedCategory != 'All' ||
                    _selectedBrand != 'All' ||
                    _minPrice > 0 ||
                    _maxPrice < 300 ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Clear All Filters'),
                  ),
              ],
            ),
          ),

          // Cages Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredCages.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No cages found',
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
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                      itemCount: filteredCages.length,
                      itemBuilder: (context, index) {
                        final cage = filteredCages[index];
                        return PetCageCard(
                          petCage: cage,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CageDetailPage(petCage: cage),
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
