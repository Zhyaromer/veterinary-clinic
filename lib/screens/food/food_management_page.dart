// screens/food/food_management_page.dart
import 'package:flutter/material.dart';
import '../../models/pet_food.dart';
import '../../services/food_firestore_service.dart';
import '../../widgets/food_management_card.dart';
import 'add_edit_food_page.dart';

class FoodManagementPage extends StatefulWidget {
  const FoodManagementPage({super.key});

  @override
  State<FoodManagementPage> createState() => _FoodManagementPageState();
}

class _FoodManagementPageState extends State<FoodManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final FoodFirestoreService _foodService = FoodFirestoreService();

  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _sortBy = 'Name (A-Z)';

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
    final searchTerm = _searchController.text.toLowerCase();

    List<PetFood> filtered = List.from(allFoods);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((food) {
        return food.name.toLowerCase().contains(searchTerm) ||
            food.category.toLowerCase().contains(searchTerm) ||
            food.description.toLowerCase().contains(searchTerm) ||
            food.brand.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedPetType != 'All') {
      filtered = filtered.where((food) {
        return food.petType == _selectedPetType;
      }).toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered.where((food) {
        return food.category == _selectedCategory;
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Name (A-Z)':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z-A)':
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price (Low-High)':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (High-Low)':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Stock (Low-High)':
        filtered.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'Stock (High-Low)':
        filtered.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case 'Expiry Date (Near)':
        filtered.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
    }

    return filtered;
  }

  void _addNewFood() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditFoodPage(),
        fullscreenDialog: true,
      ),
    ).then((value) async {
      if (value != null) {
        try {
          final food = value as PetFood;
          await _foodService.addFood(food);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Food added successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error adding food: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });
  }

  void _editFood(PetFood food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditFoodPage(food: food),
        fullscreenDialog: true,
      ),
    ).then((value) async {
      if (value != null) {
        try {
          final updatedFood = value as PetFood;
          await _foodService.updateFood(food.id, updatedFood);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Food updated successfully'),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating food: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });
  }

  void _deleteFood(PetFood food) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Food'),
        content: Text('Are you sure you want to delete "${food.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _foodService.deleteFood(food.id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${food.name}" deleted successfully'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting food: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _duplicateFood(PetFood food) {
    final duplicatedFood = PetFood(
      id: '',
      name: '${food.name} (Copy)',
      description: food.description,
      category: food.category,
      petType: food.petType,
      lifeStage: food.lifeStage,
      flavor: food.flavor,
      primaryProtein: food.primaryProtein,
      ingredients: List.from(food.ingredients),
      keyNutrients: List.from(food.keyNutrients),
      size: food.size,
      weight: food.weight,
      price: food.price,
      stock: food.stock,
      brand: food.brand,
      manufacturer: food.manufacturer,
      imageUrl: food.imageUrl,
      feedingGuidelines: food.feedingGuidelines,
      storageInstructions: food.storageInstructions,
      expiryDate: food.expiryDate,
      isGrainFree: food.isGrainFree,
      isOrganic: food.isOrganic,
      isPrescriptionRequired: food.isPrescriptionRequired,
      nutritionalGuarantee: food.nutritionalGuarantee,
    );

    _foodService
        .addFood(duplicatedFood)
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"${food.name}" duplicated successfully'),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        })
        .catchError((e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error duplicating food: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Name (A-Z)',
      'Name (Z-A)',
      'Price (Low-High)',
      'Price (High-Low)',
      'Stock (Low-High)',
      'Stock (High-Low)',
      'Expiry Date (Near)',
    ];

    return StreamBuilder<List<PetFood>>(
      stream: _foodService.getFoodsStream(),
      builder: (context, snapshot) {
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
                const Text('Error loading foods'),
                const SizedBox(height: 8),
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }

        final allFoods = snapshot.data ?? [];
        final filteredFoods = _getFilteredFoods(allFoods);

        return Column(
          children: [
            // Search and Filters
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search food items...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                  const SizedBox(height: 16),

                  // Filters Row
                  Row(
                    children: [
                      // Pet Type Filter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedPetType,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: petTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedPetType = value!;
                                });
                                _updateFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Category Filter
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              icon: const Icon(Icons.category),
                              items: categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                                _updateFilters();
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Sort Filter
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            icon: const Icon(Icons.sort),
                            items: sortOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _sortBy = value!;
                              });
                              _updateFilters();
                            },
                          ),
                        ),
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
                  Text(
                    '${filteredFoods.length} Food Items',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF444444),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addNewFood,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text(
                      'Add New Food',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                    ),
                  ),
                ],
              ),
            ),

            // Foods List
            Expanded(
              child: filteredFoods.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant,
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
                          ElevatedButton.icon(
                            onPressed: _addNewFood,
                            icon: const Icon(Icons.add),
                            label: const Text('Add New Food'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final food = filteredFoods[index];
                        return FoodManagementCard(
                          food: food,
                          onEdit: () => _editFood(food),
                          onDelete: () => _deleteFood(food),
                          onDuplicate: () => _duplicateFood(food),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
