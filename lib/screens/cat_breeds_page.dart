import 'package:flutter/material.dart';
import '../models/animal_breed.dart';
import '../widgets/breed_card.dart';

class CatBreedsPage extends StatefulWidget {
  const CatBreedsPage({super.key});

  @override
  State<CatBreedsPage> createState() => _CatBreedsPageState();
}

class _CatBreedsPageState extends State<CatBreedsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AnimalBreed> filteredBreeds = List.from(catBreeds);
  String _sortBy = 'Name (A-Z)';
  String _selectedWeight = 'All';
  String _selectedLifespan = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterBreeds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterBreeds() {
    final searchTerm = _searchController.text.toLowerCase();
    List<AnimalBreed> filtered = List.from(catBreeds);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((breed) {
        return breed.name.toLowerCase().contains(searchTerm) ||
            breed.description.toLowerCase().contains(searchTerm) ||
            breed.temperament.toLowerCase().contains(searchTerm) ||
            breed.origin.country.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Filter by weight range
    if (_selectedWeight != 'All') {
      filtered = filtered.where((breed) {
        final avgWeight = (breed.weight.min + breed.weight.max) / 2;
        switch (_selectedWeight) {
          case 'Small (<4kg)':
            return avgWeight < 4;
          case 'Medium (4-6kg)':
            return avgWeight >= 4 && avgWeight <= 6;
          case 'Large (>6kg)':
            return avgWeight > 6;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by lifespan
    if (_selectedLifespan != 'All') {
      filtered = filtered.where((breed) {
        final avgLifespan = (breed.lifespan.min + breed.lifespan.max) / 2;
        switch (_selectedLifespan) {
          case 'Short (<12 years)':
            return avgLifespan < 12;
          case 'Medium (12-16 years)':
            return avgLifespan >= 12 && avgLifespan <= 16;
          case 'Long (>16 years)':
            return avgLifespan > 16;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sorting
    filtered = _sortBreeds(filtered);

    setState(() {
      filteredBreeds = filtered;
    });
  }

  List<AnimalBreed> _sortBreeds(List<AnimalBreed> list) {
    switch (_sortBy) {
      case 'Name (A-Z)':
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name (Z-A)':
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Weight (Light-Heavy)':
        list.sort((a, b) {
          final avgA = (a.weight.min + a.weight.max) / 2;
          final avgB = (b.weight.min + b.weight.max) / 2;
          return avgA.compareTo(avgB);
        });
        break;
      case 'Weight (Heavy-Light)':
        list.sort((a, b) {
          final avgA = (a.weight.min + a.weight.max) / 2;
          final avgB = (b.weight.min + b.weight.max) / 2;
          return avgB.compareTo(avgA);
        });
        break;
      case 'Lifespan (Short-Long)':
        list.sort((a, b) {
          final avgA = (a.lifespan.min + a.lifespan.max) / 2;
          final avgB = (b.lifespan.min + b.lifespan.max) / 2;
          return avgA.compareTo(avgB);
        });
        break;
      case 'Lifespan (Long-Short)':
        list.sort((a, b) {
          final avgA = (a.lifespan.min + a.lifespan.max) / 2;
          final avgB = (b.lifespan.min + b.lifespan.max) / 2;
          return avgB.compareTo(avgA);
        });
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      'Name (A-Z)',
      'Name (Z-A)',
      'Weight (Light-Heavy)',
      'Weight (Heavy-Light)',
      'Lifespan (Short-Long)',
      'Lifespan (Long-Short)',
    ];

    final weightOptions = [
      'All',
      'Small (<4kg)',
      'Medium (4-6kg)',
      'Large (>6kg)',
    ];

    final lifespanOptions = [
      'All',
      'Short (<12 years)',
      'Medium (12-16 years)',
      'Long (>16 years)',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breeds', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF9800),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
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
                    hintText: 'Search cat breeds...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFFF9800),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _filterBreeds();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => _filterBreeds(),
                ),
                const SizedBox(height: 16),

                // Filters Row
                Row(
                  children: [
                    // Sort Filter
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
                            value: _sortBy,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.sort,
                              color: Color(0xFFFF9800),
                            ),
                            items: sortOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _sortBy = value!;
                                _filterBreeds();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Additional Filters
                Row(
                  children: [
                    // Weight Filter
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
                            value: _selectedWeight,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.fitness_center,
                              size: 18,
                              color: Colors.blue,
                            ),
                            items: weightOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedWeight = value!;
                                _filterBreeds();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Lifespan Filter
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
                            value: _selectedLifespan,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.timeline,
                              size: 18,
                              color: Colors.green,
                            ),
                            items: lifespanOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLifespan = value!;
                                _filterBreeds();
                              });
                            },
                          ),
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
                  '${filteredBreeds.length} Cat Breeds',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                  ),
                ),
                if (_selectedWeight != 'All' ||
                    _selectedLifespan != 'All' ||
                    _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedWeight = 'All';
                        _selectedLifespan = 'All';
                        _searchController.clear();
                        _filterBreeds();
                      });
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(color: Color(0xFFFF9800)),
                    ),
                  ),
              ],
            ),
          ),

          // Breeds Grid
          Expanded(
            child: filteredBreeds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.catching_pokemon,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No cat breeds found',
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
                            childAspectRatio: 0.75,
                          ),
                      itemCount: filteredBreeds.length,
                      itemBuilder: (context, index) {
                        final breed = filteredBreeds[index];
                        return BreedCard(breed: breed);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
