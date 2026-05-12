import 'package:flutter/material.dart';
import '../../models/pet_toy.dart';
import '../../services/toy_firestore_service.dart';
import '../../widgets/toy_management_card.dart';
import 'add_edit_toy_page.dart';

class ToyManagementPage extends StatefulWidget {
  const ToyManagementPage({super.key});

  @override
  State<ToyManagementPage> createState() => _ToyManagementPageState();
}

class _ToyManagementPageState extends State<ToyManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final ToyFirestoreService _toyService = ToyFirestoreService();
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _sortBy = 'Name (A-Z)';

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

  List<PetToy> _getFilteredToys(List<PetToy> allToys) {
    final searchTerm = _searchController.text.toLowerCase();
    List<PetToy> filtered = List.from(allToys);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((toy) {
        return toy.name.toLowerCase().contains(searchTerm) ||
            toy.category.toLowerCase().contains(searchTerm) ||
            toy.description.toLowerCase().contains(searchTerm) ||
            toy.brand.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedPetType != 'All') {
      filtered = filtered
          .where((toy) => toy.petType == _selectedPetType)
          .toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((toy) => toy.category == _selectedCategory)
          .toList();
    }

    return _sortToys(filtered);
  }

  List<PetToy> _sortToys(List<PetToy> list) {
    switch (_sortBy) {
      case 'Name (A-Z)':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z-A)':
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price (Low-High)':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price (High-Low)':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Stock (Low-High)':
        list.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'Stock (High-Low)':
        list.sort((a, b) => b.stock.compareTo(a.stock));
        break;
    }
    return list;
  }

  void _addNewToy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditToyPage(),
        fullscreenDialog: true,
      ),
    ).then((value) async {
      if (value != null) {
        try {
          final toy = value as PetToy;
          await _toyService.addToy(toy);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Toy added successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error adding toy: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });
  }

  void _editToy(PetToy toy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditToyPage(toy: toy),
        fullscreenDialog: true,
      ),
    ).then((value) async {
      if (value != null) {
        try {
          final updatedToy = value as PetToy;
          await _toyService.updateToy(toy.id, updatedToy);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Toy updated successfully'),
                backgroundColor: Colors.blue,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error updating toy: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    });
  }

  void _deleteToy(PetToy toy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Toy'),
        content: Text('Are you sure you want to delete "${toy.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _toyService
                  .deleteToy(toy.id)
                  .then((_) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${toy.name}" deleted successfully'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  })
                  .catchError((e) {
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error deleting toy: $e'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _duplicateToy(PetToy toy) {
    final duplicatedToy = PetToy(
      id: '',
      name: '${toy.name} (Copy)',
      description: toy.description,
      category: toy.category,
      petType: toy.petType,
      size: toy.size,
      material: toy.material,
      safetyFeatures: toy.safetyFeatures,
      features: List.from(toy.features),
      price: toy.price,
      stock: toy.stock,
      brand: toy.brand,
      manufacturer: toy.manufacturer,
      imageUrl: toy.imageUrl,
      cleaningInstructions: toy.cleaningInstructions,
      warranty: toy.warranty,
      isInteractive: toy.isInteractive,
      isChewResistant: toy.isChewResistant,
      ageSuitability: toy.ageSuitability,
    );

    _toyService
        .addToy(duplicatedToy)
        .then((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"${toy.name}" duplicated successfully'),
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
                content: Text('Error duplicating toy: $e'),
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
    ];

    return StreamBuilder<List<PetToy>>(
      stream: _toyService.getToysStream(),
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
                const Text('Error loading toys'),
                const SizedBox(height: 8),
                Text(snapshot.error.toString()),
              ],
            ),
          );
        }

        final allToys = snapshot.data ?? [];
        final filteredToys = _getFilteredToys(allToys);

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
                      hintText: 'Search toys...',
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
                    onChanged: (_) => _updateFilters(),
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
                    '${filteredToys.length} Toys',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF444444),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _addNewToy,
                    icon: const Icon(Icons.add, size: 18, color: Colors.white),
                    label: const Text(
                      'Add New Toy',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                    ),
                  ),
                ],
              ),
            ),

            // Toys List
            Expanded(
              child: filteredToys.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.toys,
                            size: 80,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No toys found',
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
                            onPressed: _addNewToy,
                            icon: const Icon(Icons.add),
                            label: const Text('Add New Toy'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A6FA5),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredToys.length,
                      itemBuilder: (context, index) {
                        final toy = filteredToys[index];
                        return ToyManagementCard(
                          toy: toy,
                          onEdit: () => _editToy(toy),
                          onDelete: () => _deleteToy(toy),
                          onDuplicate: () => _duplicateToy(toy),
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
