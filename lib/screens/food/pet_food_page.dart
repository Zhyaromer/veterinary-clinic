// screens/food/pet_food_page.dart
import 'package:flutter/material.dart';
import '../../models/pet_food.dart';
import '../../services/food_firestore_service.dart';
import '../../widgets/pet_food_card.dart';
import 'pet_food_detail_page.dart';

class PetFoodPage extends StatefulWidget {
  const PetFoodPage({super.key});

  @override
  State<PetFoodPage> createState() => _PetFoodPageState();
}

class _PetFoodPageState extends State<PetFoodPage> {
  final TextEditingController _searchController = TextEditingController();
  final FoodFirestoreService _foodService = FoodFirestoreService();

  // Filter states
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _selectedLifeStage = 'All';
  double _minPrice = 0;
  double _maxPrice = 500;
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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters() {
    setState(() {});
  }

  List<PetFood> _getFilteredFoods(List<PetFood> allFoods) {
    if (allFoods.isEmpty) return [];

    final searchTerm = _searchController.text.toLowerCase();

    return allFoods.where((food) {
      final matchesSearch =
          searchTerm.isEmpty ||
          food.name.toLowerCase().contains(searchTerm) ||
          food.description.toLowerCase().contains(searchTerm) ||
          food.flavor.toLowerCase().contains(searchTerm);

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
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedPetType = 'All';
      _selectedCategory = 'All';
      _selectedLifeStage = 'All';
      _minPrice = 0;
      _maxPrice = 500;
      _isPriceFiltered = false;
      _showGrainFreeOnly = false;
      _showOrganicOnly = false;
    });
  }

  void _showFilterDialog() {
    String dialogPetType = _selectedPetType;
    String dialogCategory = _selectedCategory;
    String dialogLifeStage = _selectedLifeStage;
    double dialogMinPrice = _minPrice;
    double dialogMaxPrice = _maxPrice;
    bool showGrainFreeOnly = _showGrainFreeOnly;
    bool showOrganicOnly = _showOrganicOnly;

    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
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
                                    setDialogState(() {
                                      dialogPetType = selected ? type : 'All';
                                    });
                                  },
                                  backgroundColor: Colors.grey[100],
                                  selectedColor: const Color(
                                    0xFF4A6FA5,
                                  ).withOpacity(0.2),
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
                                setDialogState(() {
                                  dialogCategory = selected ? category : 'All';
                                });
                              },
                              backgroundColor: Colors.grey[100],
                              selectedColor: const Color(
                                0xFF4CAF50,
                              ).withOpacity(0.2),
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
                                    setDialogState(() {
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
                                setDialogState(() {
                                  showGrainFreeOnly = value ?? false;
                                });
                              },
                              activeColor: Colors.green,
                            ),
                            CheckboxListTile(
                              title: const Text('Organic Only'),
                              value: showOrganicOnly,
                              onChanged: (value) {
                                setDialogState(() {
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
                          max: 500,
                          divisions: 50,
                          labels: RangeLabels(
                            '\$${dialogMinPrice.toStringAsFixed(0)}',
                            '\$${dialogMaxPrice.toStringAsFixed(0)}',
                          ),
                          onChanged: (values) {
                            setDialogState(() {
                              dialogMinPrice = values.start;
                              dialogMaxPrice = values.end;
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _resetFilters();
                              },
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
                                      _showGrainFreeOnly = showGrainFreeOnly;
                                      _showOrganicOnly = showOrganicOnly;
                                      _isPriceFiltered =
                                          dialogMinPrice > 0 ||
                                          dialogMaxPrice < 500;
                                    });
                                    Navigator.pop(context);
                                    _updateFilters();
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
        centerTitle: true,
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
      body: StreamBuilder<List<PetFood>>(
        stream: _foodService.getFoodsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading foods from Firestore...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Error loading foods'),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allFoods = snapshot.data ?? [];

          // Show message if no data in Firestore
          if (allFoods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fastfood,
                    size: 80,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Food Items Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please add food items using the\nFood Management page.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to food management - adjust route as needed
                      Navigator.pushNamed(context, '/food-management');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Food Items'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                    ),
                  ),
                ],
              ),
            );
          }

          final filteredFoods = _getFilteredFoods(allFoods);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search food by name, flavor, or ingredients...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF4A6FA5),
                    ),
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
                              _updateFilters();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => _updateFilters(),
                ),
              ),

              // Active Filters
              if (hasActiveFilters)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
                            Chip(
                              label: Text('Pet: $_selectedPetType'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _selectedPetType = 'All';
                                });
                                _updateFilters();
                              },
                            ),
                          if (_selectedCategory != 'All')
                            Chip(
                              label: Text('Category: $_selectedCategory'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _selectedCategory = 'All';
                                });
                                _updateFilters();
                              },
                            ),
                          if (_selectedLifeStage != 'All')
                            Chip(
                              label: Text('Life Stage: $_selectedLifeStage'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _selectedLifeStage = 'All';
                                });
                                _updateFilters();
                              },
                            ),
                          if (_showGrainFreeOnly)
                            Chip(
                              label: const Text('Grain-Free'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _showGrainFreeOnly = false;
                                });
                                _updateFilters();
                              },
                            ),
                          if (_showOrganicOnly)
                            Chip(
                              label: const Text('Organic'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _showOrganicOnly = false;
                                });
                                _updateFilters();
                              },
                            ),
                          if (_isPriceFiltered)
                            Chip(
                              label: Text(
                                'Price: \$${_minPrice.toStringAsFixed(0)}-\$${_maxPrice.toStringAsFixed(0)}',
                              ),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _minPrice = 0;
                                  _maxPrice = 500;
                                  _isPriceFiltered = false;
                                });
                                _updateFilters();
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
                              Icons.filter_alt_off,
                              size: 80,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No matching food items',
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
          );
        },
      ),
    );
  }
}
