import 'package:flutter/material.dart';
import '../models/pet_food.dart';
import '../widgets/pet_food_card.dart';
import 'pet_food_detail_page.dart';

class PetFoodPage extends StatefulWidget {
  const PetFoodPage({super.key});

  @override
  State<PetFoodPage> createState() => _PetFoodPageState();
}

class _PetFoodPageState extends State<PetFoodPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetFood> filteredFoods = List.from(petFoods);

  // Filter states
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _selectedLifeStage = 'All';
  double _minPrice = 0;
  double _maxPrice = 100;
  bool _isPriceFiltered = false;
  bool _showGrainFreeOnly = false;
  bool _showOrganicOnly = false;

  final List<String> petTypes = [
    'All',
    'Dog',
    'Cat',
    'Bird',
    'Small Animal',
    'Reptile',
  ];
  final List<String> categories = [
    'All',
    'Dry Food',
    'Wet Food',
    'Treats',
    'Dental Treats',
    'Bird Food',
    'Small Animal Food',
    'Prescription Diet',
  ];
  final List<String> lifeStages = [
    'All',
    'Puppy/Kitten',
    'Adult',
    'Senior',
    'All Life Stages',
  ];
  final List<String> brands = [
    'All',
    'Wellness Core',
    'Royal Canin',
    'Purina',
    'Hill\'s Science Diet',
    'Stella & Chewy\'s',
    'Kaytee',
    'Greenies',
    'Oxbow',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFoods);

    // Calculate max price
    if (petFoods.isNotEmpty) {
      final maxPriceInList = petFoods
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

  void _filterFoods() {
    setState(() {
      filteredFoods = petFoods.where((food) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            food.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            food.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            food.flavor.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesPetType =
            _selectedPetType == 'All' || food.petType == _selectedPetType;

        final matchesCategory =
            _selectedCategory == 'All' || food.category == _selectedCategory;

        final matchesLifeStage =
            _selectedLifeStage == 'All' || food.lifeStage == _selectedLifeStage;

        final matchesPrice = food.price >= _minPrice && food.price <= _maxPrice;

        final matchesGrainFree = !_showGrainFreeOnly || food.isGrainFree;

        final matchesOrganic = !_showOrganicOnly || food.isOrganic;

        return matchesSearch &&
            matchesPetType &&
            matchesCategory &&
            matchesLifeStage &&
            matchesPrice &&
            matchesGrainFree &&
            matchesOrganic;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedPetType = 'All';
      _selectedCategory = 'All';
      _selectedLifeStage = 'All';
      _minPrice = 0;
      final maxPriceInList = petFoods
          .map((t) => t.price)
          .reduce((a, b) => a > b ? a : b);
      _maxPrice = (maxPriceInList + 20).ceilToDouble();
      _isPriceFiltered = false;
      _showGrainFreeOnly = false;
      _showOrganicOnly = false;
      _filterFoods();
    });
  }

  void _showFilterDialog() {
    final maxPriceInList = petFoods
        .map((t) => t.price)
        .reduce((a, b) => a > b ? a : b);
    final sliderMaxPrice = (maxPriceInList + 20).ceilToDouble();

    // Local dialog variables
    String dialogPetType = _selectedPetType;
    String dialogCategory = _selectedCategory;
    String dialogLifeStage = _selectedLifeStage;
    double dialogMinPrice = _minPrice;
    double dialogMaxPrice = _maxPrice > sliderMaxPrice
        ? sliderMaxPrice
        : _maxPrice;
    bool isPriceFiltered = _isPriceFiltered;
    bool showGrainFreeOnly = _showGrainFreeOnly;
    bool showOrganicOnly = _showOrganicOnly;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  maxHeight: 770,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Icon(
                              Icons.filter_list,
                              color: Color(0xFF4A6FA5),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Filter Food & Treats',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Pet Type Filter
                        const Text(
                          'Pet Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: petTypes.length,
                            itemBuilder: (context, index) {
                              final type = petTypes[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(type),
                                  selected: dialogPetType == type,
                                  onSelected: (selected) {
                                    setState(() {
                                      dialogPetType = selected ? type : 'All';
                                    });
                                  },
                                  backgroundColor: Colors.grey[100],
                                  selectedColor: const Color(
                                    0xFF4A6FA5,
                                  ).withOpacity(0.2),
                                  labelStyle: TextStyle(
                                    color: dialogPetType == type
                                        ? const Color(0xFF4A6FA5)
                                        : Colors.grey[700],
                                    fontWeight: dialogPetType == type
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Category Filter
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: categories.map((category) {
                            return ChoiceChip(
                              label: Text(category),
                              selected: dialogCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  dialogCategory = selected ? category : 'All';
                                });
                              },
                              backgroundColor: Colors.grey[100],
                              selectedColor: const Color(
                                0xFF4CAF50,
                              ).withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: dialogCategory == category
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey[700],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),

                        // Life Stage Filter
                        const Text(
                          'Life Stage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 60,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: lifeStages.length,
                            itemBuilder: (context, index) {
                              final stage = lifeStages[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(stage),
                                  selected: dialogLifeStage == stage,
                                  onSelected: (selected) {
                                    setState(() {
                                      dialogLifeStage = selected
                                          ? stage
                                          : 'All';
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Special Features
                        const Text(
                          'Special Features',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('Grain-Free Only'),
                              value: showGrainFreeOnly,
                              onChanged: (value) {
                                setState(() {
                                  showGrainFreeOnly = value ?? false;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            CheckboxListTile(
                              title: const Text('Organic Only'),
                              value: showOrganicOnly,
                              onChanged: (value) {
                                setState(() {
                                  showOrganicOnly = value ?? false;
                                });
                              },
                              activeColor: Colors.teal,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Price Range
                        const Text(
                          'Price Range',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF444444),
                          ),
                        ),
                        const SizedBox(height: 12),
                        RangeSlider(
                          values: RangeValues(dialogMinPrice, dialogMaxPrice),
                          min: 0,
                          max: sliderMaxPrice,
                          divisions: (sliderMaxPrice ~/ 10).toInt(),
                          labels: RangeLabels(
                            '\$${dialogMinPrice.toStringAsFixed(0)}',
                            '\$${dialogMaxPrice.toStringAsFixed(0)}',
                          ),
                          onChanged: (values) {
                            setState(() {
                              dialogMinPrice = values.start;
                              dialogMaxPrice = values.end;
                              isPriceFiltered = true;
                            });
                          },
                          activeColor: const Color(0xFF4A6FA5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                        const SizedBox(height: 30),

                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _resetFilters();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.refresh, size: 18),
                                  SizedBox(width: 8),
                                  Text('Reset All'),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedPetType = dialogPetType;
                                      _selectedCategory = dialogCategory;
                                      _selectedLifeStage = dialogLifeStage;
                                      _minPrice = dialogMinPrice;
                                      _maxPrice = dialogMaxPrice;
                                      _isPriceFiltered =
                                          isPriceFiltered &&
                                          (dialogMinPrice > 0 ||
                                              dialogMaxPrice < sliderMaxPrice);
                                      _showGrainFreeOnly = showGrainFreeOnly;
                                      _showOrganicOnly = showOrganicOnly;
                                    });
                                    Navigator.pop(context);
                                    _filterFoods();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4A6FA5),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
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
                      ],
                    ),
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
    final hasActiveFilters =
        _selectedPetType != 'All' ||
        _selectedCategory != 'All' ||
        _selectedLifeStage != 'All' ||
        _isPriceFiltered ||
        _showGrainFreeOnly ||
        _showOrganicOnly;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food & Treats',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 24),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search food by name, flavor, or ingredients...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4A6FA5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterFoods();
                        },
                      )
                    : null,
              ),
              onChanged: (value) => _filterFoods(),
            ),
          ),

          // Active Filters
          if (hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.grey[50],
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Filters:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: _resetFilters,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A6FA5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_selectedPetType != 'All')
                        _buildFilterChip(
                          '${Icons.pets} ${_selectedPetType}',
                          () {
                            setState(() {
                              _selectedPetType = 'All';
                              _filterFoods();
                            });
                          },
                        ),
                      if (_selectedCategory != 'All')
                        _buildFilterChip(
                          '${Icons.category} ${_selectedCategory}',
                          () {
                            setState(() {
                              _selectedCategory = 'All';
                              _filterFoods();
                            });
                          },
                        ),
                      if (_selectedLifeStage != 'All')
                        _buildFilterChip(
                          '${Icons.timeline} ${_selectedLifeStage}',
                          () {
                            setState(() {
                              _selectedLifeStage = 'All';
                              _filterFoods();
                            });
                          },
                        ),
                      if (_showGrainFreeOnly)
                        _buildFilterChip('${Icons.grain} Grain-Free', () {
                          setState(() {
                            _showGrainFreeOnly = false;
                            _filterFoods();
                          });
                        }),
                      if (_showOrganicOnly)
                        _buildFilterChip('${Icons.spa} Organic', () {
                          setState(() {
                            _showOrganicOnly = false;
                            _filterFoods();
                          });
                        }),
                      if (_isPriceFiltered)
                        _buildFilterChip(
                          '${Icons.attach_money} \$${_minPrice.toStringAsFixed(0)}-\$${_maxPrice.toStringAsFixed(0)}',
                          () {
                            setState(() {
                              _minPrice = 0;
                              final maxPriceInList = petFoods
                                  .map((t) => t.price)
                                  .reduce((a, b) => a > b ? a : b);
                              _maxPrice = (maxPriceInList + 20).ceilToDouble();
                              _isPriceFiltered = false;
                              _filterFoods();
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),

          // Results Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${filteredFoods.length} ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const TextSpan(
                        text: 'Products Found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasActiveFilters || _searchController.text.isNotEmpty)
                  OutlinedButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Clear Filters'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4A6FA5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Foods Grid
          Expanded(
            child: filteredFoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fastfood,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No food items found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        if (hasActiveFilters)
                          ElevatedButton(
                            onPressed: _resetFilters,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                            ),
                            child: const Text('Clear All Filters'),
                          ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.67,
                          ),
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods[index];
                        return PetFoodCard(
                          petFood: food,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PetFoodDetailPage(petFood: food),
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

  Widget _buildFilterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 13)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDeleted,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }
}
