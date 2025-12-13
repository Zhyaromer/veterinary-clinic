import 'package:flutter/material.dart';
import '../models/animal_breed.dart';
import '../widgets/breed_card.dart';

class DogBreedsPage extends StatefulWidget {
  const DogBreedsPage({super.key});

  @override
  State<DogBreedsPage> createState() => _DogBreedsPageState();
}

class _DogBreedsPageState extends State<DogBreedsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AnimalBreed> filteredBreeds = List.from(dogBreeds);
  String _sortBy = 'Name (A-Z)';
  String _selectedSize = 'All';
  String _selectedEnergy = 'All';

  final Map<String, List<double>> sizeRanges = {
    'Small': [0, 11],
    'Medium': [11, 26],
    'Large': [26, 45],
    'Giant': [45, 100],
  };

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
    List<AnimalBreed> filtered = List.from(dogBreeds);

    // Search filter
    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((breed) {
        return breed.name.toLowerCase().contains(searchTerm) ||
            breed.description.toLowerCase().contains(searchTerm) ||
            breed.temperament.toLowerCase().contains(searchTerm) ||
            breed.idealHome.toLowerCase().contains(
              searchTerm,
            ) || // Added idealHome
            breed.origin.country.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Filter by size - FIXED LOGIC
    if (_selectedSize != 'All') {
      filtered = filtered.where((breed) {
        final avgWeight = (breed.weight.min + breed.weight.max) / 2;

        switch (_selectedSize) {
          case 'Small (0-11kg)':
            return avgWeight <= 11;
          case 'Medium (11-26kg)':
            return avgWeight > 11 && avgWeight <= 26;
          case 'Large (26-45kg)':
            return avgWeight > 26 && avgWeight <= 45;
          case 'Giant (45+kg)':
            return avgWeight > 45;
          default:
            return true;
        }
      }).toList();
    }

    // Filter by energy level - FIXED LOGIC
    if (_selectedEnergy != 'All') {
      filtered = filtered.where((breed) {
        final home = breed.idealHome.toLowerCase();
        final temperament = breed.temperament.toLowerCase();
        final description = breed.description.toLowerCase();

        // Combine all text fields for better matching
        final allText = '$home $temperament $description'.toLowerCase();

        switch (_selectedEnergy) {
          case 'Low Energy':
            return allText.contains('low exercise') ||
                allText.contains('moderate exercise') ||
                allText.contains('low energy') ||
                temperament.contains('calm') ||
                temperament.contains('gentle') ||
                temperament.contains('quiet') ||
                temperament.contains('relaxed') ||
                breed.name == 'Bulldog' ||
                breed.name == 'Shih Tzu' ||
                breed.name == 'French Bulldog';

          case 'Medium Energy':
            return allText.contains('moderate exercise') ||
                allText.contains('regular exercise') ||
                allText.contains('medium energy') ||
                temperament.contains('active') ||
                temperament.contains('playful') ||
                temperament.contains('energetic') ||
                breed.name == 'Beagle' ||
                breed.name == 'Dachshund' ||
                breed.name == 'Poodle';

          case 'High Energy':
            return allText.contains('intense exercise') ||
                allText.contains('high energy') ||
                allText.contains('active lifestyle') ||
                allText.contains('requires exercise') ||
                temperament.contains('energetic') ||
                temperament.contains('exuberant') ||
                temperament.contains('high energy') ||
                breed.name == 'Border Collie' ||
                breed.name == 'Australian Shepherd' ||
                breed.name == 'Siberian Husky' ||
                breed.name == 'German Shepherd' ||
                breed.name == 'Labrador Retriever';

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
      case 'Size (Small-Large)':
        list.sort((a, b) {
          final avgA = (a.weight.min + a.weight.max) / 2;
          final avgB = (b.weight.min + b.weight.max) / 2;
          return avgA.compareTo(avgB);
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
      'Size (Small-Large)',
      'Weight (Light-Heavy)',
      'Weight (Heavy-Light)',
      'Lifespan (Short-Long)',
      'Lifespan (Long-Short)',
    ];

    final sizeOptions = [
      'All',
      'Small (0-11kg)',
      'Medium (11-26kg)',
      'Large (26-45kg)',
      'Giant (45+kg)',
    ];

    final energyOptions = ['All', 'Low Energy', 'Medium Energy', 'High Energy'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Breeds', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2196F3),
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
                    hintText: 'Search dog breeds...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF2196F3),
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
                              color: Color(0xFF2196F3),
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
                    // Size Filter
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
                            value: _selectedSize,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.aspect_ratio,
                              size: 18,
                              color: Colors.blue,
                            ),
                            items: sizeOptions.map((option) {
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
                                _selectedSize = value!;
                                _filterBreeds();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Energy Filter
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
                            value: _selectedEnergy,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.bolt,
                              size: 18,
                              color: Colors.orange,
                            ),
                            items: energyOptions.map((option) {
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
                                _selectedEnergy = value!;
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
                  '${filteredBreeds.length} Dog Breeds',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                  ),
                ),
                if (_selectedSize != 'All' ||
                    _selectedEnergy != 'All' ||
                    _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSize = 'All';
                        _selectedEnergy = 'All';
                        _searchController.clear();
                        _filterBreeds();
                      });
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(color: Color(0xFF2196F3)),
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
                          Icons.pets,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No dog breeds found',
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
