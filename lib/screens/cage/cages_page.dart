// screens/cages_page.dart
import 'package:flutter/material.dart';
import '../../models/pet_cage.dart';
import '../../widgets/pet_cage_card.dart';
import '../../services/cage_firestore_service.dart';
import 'cage_detail_page.dart';

class CagesPage extends StatefulWidget {
  const CagesPage({super.key});

  @override
  State<CagesPage> createState() => _CagesPageState();
}

class _CagesPageState extends State<CagesPage> {
  final TextEditingController _searchController = TextEditingController();
  final CageFirestoreService _cageService = CageFirestoreService();

  // Filter states
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _selectedBrand = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000;

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
    _searchController.addListener(_updateFilters);

    // Debug: Check Firestore connection
    _checkFirestoreConnection();
  }

  Future<void> _checkFirestoreConnection() async {
    final isConnected = await _cageService.checkConnection();
    print('Firestore connection status: $isConnected');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateFilters() {
    setState(() {});
  }

  List<PetCage> _getFilteredCages(List<PetCage> allCages) {
    print('Total cages in memory: ${allCages.length}');

    if (allCages.isEmpty) {
      print('No cages loaded from Firestore');
      return [];
    }

    final searchTerm = _searchController.text.toLowerCase();

    final filtered = allCages.where((cage) {
      final matchesSearch =
          searchTerm.isEmpty ||
          cage.name.toLowerCase().contains(searchTerm) ||
          cage.description.toLowerCase().contains(searchTerm) ||
          cage.category.toLowerCase().contains(searchTerm);

      final matchesPetType =
          _selectedPetType == 'All' || cage.petType == _selectedPetType;
      final matchesCategory =
          _selectedCategory == 'All' || cage.category == _selectedCategory;
      final matchesBrand =
          _selectedBrand == 'All' || cage.brand == _selectedBrand;
      final matchesPrice = cage.price >= _minPrice && cage.price <= _maxPrice;

      final matches =
          matchesSearch &&
          matchesPetType &&
          matchesCategory &&
          matchesBrand &&
          matchesPrice;

      if (!matches) {
        print(
          'Filtered out: ${cage.name} - PetType: ${cage.petType} (${_selectedPetType}), Category: ${cage.category} (${_selectedCategory}), Brand: ${cage.brand} (${_selectedBrand}), Price: ${cage.price} (${_minPrice}-${_maxPrice})',
        );
      }

      return matches;
    }).toList();

    print('Filtered cages count: ${filtered.length}');
    return filtered;
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedPetType = 'All';
      _selectedCategory = 'All';
      _selectedBrand = 'All';
      _minPrice = 0;
      _maxPrice = 1000;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        // Local dialog variables
        String dialogPetType = _selectedPetType;
        String dialogCategory = _selectedCategory;
        String dialogBrand = _selectedBrand;
        double dialogMinPrice = _minPrice;
        double dialogMaxPrice = _maxPrice;

        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
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
                                      setDialogState(() {
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
                                      setDialogState(() {
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
                                        setDialogState(() {
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
                                max: 1000,
                                divisions: 40,
                                labels: RangeLabels(
                                  '\$${dialogMinPrice.toStringAsFixed(2)}',
                                  '\$${dialogMaxPrice.toStringAsFixed(2)}',
                                ),
                                onChanged: (values) {
                                  setDialogState(() {
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
      body: StreamBuilder<List<PetCage>>(
        stream: _cageService.getCagesStream(),
        builder: (context, snapshot) {
          print('StreamBuilder state: ${snapshot.connectionState}');
          print('Has error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
          }
          print('Data: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Error loading cages'),
                  const SizedBox(height: 8),
                  Text(snapshot.error.toString()),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry logic could be added here
                      setState(() {});
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allCages = snapshot.data ?? [];
          print('All cages count from Firestore: ${allCages.length}');

          if (allCages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No cages found in database',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add some cages using the management page',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to add cage page
                      Navigator.pushNamed(context, '/cage-management');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Cage'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                    ),
                  ),
                ],
              ),
            );
          }

          final filteredCages = _getFilteredCages(allCages);

          return Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        'Search cages by name, category, or description...',
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
                              _updateFilters();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => _updateFilters(),
                ),
              ),

              // Active Filters (Only show if any filter is active)
              if (_selectedPetType != 'All' ||
                  _selectedCategory != 'All' ||
                  _selectedBrand != 'All' ||
                  _minPrice > 0 ||
                  _maxPrice < 1000)
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
                          if (_selectedBrand != 'All')
                            Chip(
                              label: Text('Brand: $_selectedBrand'),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _selectedBrand = 'All';
                                });
                                _updateFilters();
                              },
                            ),
                          if (_minPrice > 0 || _maxPrice < 1000)
                            Chip(
                              label: Text(
                                'Price: \$${_minPrice.toStringAsFixed(2)} - \$${_maxPrice.toStringAsFixed(2)}',
                              ),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                setState(() {
                                  _minPrice = 0;
                                  _maxPrice = 1000;
                                });
                                _updateFilters();
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
                      '${filteredCages.length} of ${allCages.length} Cages Found',
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
                        _maxPrice < 1000 ||
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
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.filter_alt_off,
                                size: 80,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No matching cages found',
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
                              const SizedBox(height: 24),
                              OutlinedButton.icon(
                                onPressed: _resetFilters,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Clear All Filters'),
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
          );
        },
      ),
    );
  }
}
