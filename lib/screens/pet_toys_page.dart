// screens/pet_toys_page.dart
import 'package:flutter/material.dart';
import '../models/pet_toy.dart';
import '../widgets/pet_toy_card.dart';
import 'pet_toy_detail_page.dart';

class PetToysPage extends StatefulWidget {
  const PetToysPage({super.key});

  @override
  State<PetToysPage> createState() => _PetToysPageState();
}

class _PetToysPageState extends State<PetToysPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetToy> filteredToys = List.from(petToys);

  // Filter states
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  double _minPrice = 0;
  double _maxPrice = 100;
  bool _isPriceFiltered = false;

  final List<String> petTypes = ['All', 'Dog', 'Cat', 'Bird', 'Small Animal'];
  final List<String> categories = [
    'All',
    'Puzzle Toy',
    'Kicker Toy',
    'Chew Toy',
    'Interactive Wand',
    'Plush Toy',
    'Foraging Toy',
    'Electronic Toy',
    'Rope Toy',
  ];
  final List<String> brands = [
    'All',
    'Pawfect Play',
    'Meow Magic',
    'ChewMaster',
    'Whisker Wonder',
    'Playful Paws',
    'Avian Adventures',
    'TechCat',
    'Natural Pup',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterToys);

    // Calculate max price
    if (petToys.isNotEmpty) {
      final maxPriceInList = petToys
          .map((t) => t.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 20).ceilToDouble();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterToys() {
    setState(() {
      filteredToys = petToys.where((toy) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            toy.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            toy.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            toy.category.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesPetType =
            _selectedPetType == 'All' || toy.petType == _selectedPetType;

        final matchesCategory =
            _selectedCategory == 'All' || toy.category == _selectedCategory;

        final matchesBrand =
            _selectedBrand == 'All' || toy.brand == _selectedBrand;

        final matchesPrice = toy.price >= _minPrice && toy.price <= _maxPrice;

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
      final maxPriceInList = petToys
          .map((t) => t.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 20).ceilToDouble();
      _isPriceFiltered = false;
      _filterToys();
    });
  }

  void _showFilterDialog() {
    final maxPriceInList = petToys
        .map((t) => t.price)
        .reduce((a, b) => a > b ? a : b);
    final sliderMaxPrice = (maxPriceInList + 20).ceilToDouble();

    // Local dialog variables
    String dialogPetType = _selectedPetType;
    String dialogCategory = _selectedCategory;
    String dialogBrand = _selectedBrand;
    double dialogMinPrice = _minPrice;
    double dialogMaxPrice = _maxPrice > sliderMaxPrice
        ? sliderMaxPrice
        : _maxPrice;
    bool isPriceFiltered = _isPriceFiltered;

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
                            'Filter Toys',
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
                                divisions: (sliderMaxPrice ~/ 10).toInt(),
                                labels: RangeLabels(
                                  '\$${dialogMinPrice.toStringAsFixed(2)}',
                                  '\$${dialogMaxPrice.toStringAsFixed(2)}',
                                ),
                                onChanged: (values) {
                                  setState(() {
                                    dialogMinPrice = values.start;
                                    dialogMaxPrice = values.end;
                                    isPriceFiltered = true;
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
                                _isPriceFiltered =
                                    isPriceFiltered &&
                                    (dialogMinPrice > 0 ||
                                        dialogMaxPrice < sliderMaxPrice);
                              });
                              Navigator.pop(context);
                              _filterToys();
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
        title: const Text('Pet Toys', style: TextStyle(color: Colors.white)),
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
                hintText: 'Search toys by name, category, or description...',
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
                          _filterToys();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _filterToys();
              },
            ),
          ),

          // Active Filters (Only show if any filter is active)
          if (_selectedPetType != 'All' ||
              _selectedCategory != 'All' ||
              _selectedBrand != 'All' ||
              _isPriceFiltered)
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
                              _filterToys();
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
                              _filterToys();
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
                              _filterToys();
                            });
                          },
                        ),
                      if (_isPriceFiltered)
                        Chip(
                          label: Text(
                            'Price: \$${_minPrice.toStringAsFixed(2)} - \$${_maxPrice.toStringAsFixed(2)}',
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () {
                            setState(() {
                              _minPrice = 0;
                              final maxPriceInList = petToys
                                  .map((t) => t.price)
                                  .reduce((a, b) => a > b ? a : b);
                              _maxPrice = (maxPriceInList + 20).ceilToDouble();
                              _isPriceFiltered = false;
                              _filterToys();
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
                  '${filteredToys.length} Toys Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                if (_selectedPetType != 'All' ||
                    _selectedCategory != 'All' ||
                    _selectedBrand != 'All' ||
                    _isPriceFiltered ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Clear All Filters'),
                  ),
              ],
            ),
          ),

          // Toys Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredToys.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.toys, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No toys found',
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
                            childAspectRatio: 0.79,
                          ),
                      itemCount: filteredToys.length,
                      itemBuilder: (context, index) {
                        final toy = filteredToys[index];
                        return PetToyCard(
                          petToy: toy,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PetToyDetailPage(petToy: toy),
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
