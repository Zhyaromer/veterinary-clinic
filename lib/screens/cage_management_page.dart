import 'package:flutter/material.dart';
import '../models/pet_cage.dart';
import '../widgets/cage_management_card.dart';
import 'add_edit_cage_page.dart';

class CageManagementPage extends StatefulWidget {
  const CageManagementPage({super.key});

  @override
  State<CageManagementPage> createState() => _CageManagementPageState();
}

class _CageManagementPageState extends State<CageManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetCage> filteredCages = List.from(petCages);
  String _selectedPetType = 'All';
  String _selectedCategory = 'All';
  String _sortBy = 'Name (A-Z)';

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

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCages() {
    final searchTerm = _searchController.text.toLowerCase();
    List<PetCage> filtered = List.from(petCages);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((cage) {
        return cage.name.toLowerCase().contains(searchTerm) ||
            cage.category.toLowerCase().contains(searchTerm) ||
            cage.description.toLowerCase().contains(searchTerm) ||
            cage.brand.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedPetType != 'All') {
      filtered = filtered.where((cage) {
        return cage.petType == _selectedPetType;
      }).toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered.where((cage) {
        return cage.category == _selectedCategory;
      }).toList();
    }

    filtered = _sortCages(filtered);

    setState(() {
      filteredCages = filtered;
    });
  }

  List<PetCage> _sortCages(List<PetCage> list) {
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

  void _addNewCage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditCagePage(),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          petCages.add(value as PetCage);
          _filterCages();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cage added successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _editCage(PetCage cage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditCagePage(cage: cage),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          final index = petCages.indexWhere((c) => c.id == cage.id);
          if (index != -1) {
            petCages[index] = value as PetCage;
            _filterCages();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cage updated successfully'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _deleteCage(PetCage cage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cage'),
        content: Text('Are you sure you want to delete "${cage.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                petCages.removeWhere((c) => c.id == cage.id);
                _filterCages();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${cage.name}" deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _duplicateCage(PetCage cage) {
    final newId = petCages.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
    final duplicatedCage = PetCage(
      id: newId,
      name: '${cage.name} (Copy)',
      description: cage.description,
      category: cage.category,
      petType: cage.petType,
      dimensions: cage.dimensions,
      material: cage.material,
      weight: cage.weight,
      assemblyRequired: cage.assemblyRequired,
      features: List.from(cage.features),
      price: cage.price,
      stock: cage.stock,
      brand: cage.brand,
      manufacturer: cage.manufacturer,
      imageUrl: cage.imageUrl,
      cleaningInstructions: cage.cleaningInstructions,
      warranty: cage.warranty,
      isPortable: cage.isPortable,
      hasWheels: cage.hasWheels,
      includedAccessories: cage.includedAccessories,
    );

    setState(() {
      petCages.add(duplicatedCage);
      _filterCages();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${cage.name}" duplicated successfully'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                  hintText: 'Search cages...',
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
                            _filterCages();
                          },
                        )
                      : null,
                ),
                onChanged: (value) => _filterCages(),
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
                              _filterCages();
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
                              _filterCages();
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
                            _filterCages();
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
                '${filteredCages.length} Cages',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF444444),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addNewCage,
                icon: const Icon(Icons.add, size: 18, color: Colors.white),
                label: const Text(
                  'Add New Cage',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5),
                ),
              ),
            ],
          ),
        ),

        // Cages List
        Expanded(
          child: filteredCages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.pets,
                        size: 80,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No cages found',
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
                        onPressed: _addNewCage,
                        icon: const Icon(Icons.add,color: Colors.white),
                        label: const Text('Add New Cage',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6FA5),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredCages.length,
                  itemBuilder: (context, index) {
                    final cage = filteredCages[index];
                    return CageManagementCard(
                      cage: cage,
                      onEdit: () => _editCage(cage),
                      onDelete: () => _deleteCage(cage),
                      onDuplicate: () => _duplicateCage(cage),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
