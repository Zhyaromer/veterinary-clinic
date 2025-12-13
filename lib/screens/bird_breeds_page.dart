import 'package:flutter/material.dart';
import '../models/animal_breed.dart';
import '../widgets/breed_card.dart';

class BirdBreedsPage extends StatefulWidget {
  const BirdBreedsPage({super.key});

  @override
  State<BirdBreedsPage> createState() => _BirdBreedsPageState();
}

class _BirdBreedsPageState extends State<BirdBreedsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AnimalBreed> filteredBreeds = List.from(birdBreeds);
  String _sortBy = 'Name (A-Z)';
  String _selectedSize = 'All';
  String _selectedNoiseLevel = 'All';

  final Map<String, List<double>> sizeRanges = {
    'Small': [0, 0.05], // 0-50g (Finches, Budgies)
    'Medium': [0.05, 0.3], // 50g-300g (Cockatiels, Conures)
    'Large': [0.3, 1.0], // 300g-1kg (African Greys, small Cockatoos)
    'Extra Large': [1.0, 2.0], // 1kg+ (Macaws, large Cockatoos)
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
    List<AnimalBreed> filtered = List.from(birdBreeds);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((breed) {
        return breed.name.toLowerCase().contains(searchTerm) ||
            breed.description.toLowerCase().contains(searchTerm) ||
            breed.temperament.toLowerCase().contains(searchTerm) ||
            breed.idealHome.toLowerCase().contains(searchTerm) ||
            breed.origin.country.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedSize != 'All') {
      filtered = filtered.where((breed) {
        final avgWeight = (breed.weight.min + breed.weight.max) / 2;

        switch (_selectedSize) {
          case 'Small (0-50g)':
            return avgWeight <= 0.05;
          case 'Medium (50g-300g)':
            return avgWeight > 0.05 && avgWeight <= 0.3;
          case 'Large (300g-1kg)':
            return avgWeight > 0.3 && avgWeight <= 1.0;
          case 'Extra Large (1kg+)':
            return avgWeight > 1.0;
          default:
            return true;
        }
      }).toList();
    }

    if (_selectedNoiseLevel != 'All') {
      filtered = filtered.where((breed) {
        final characteristics = breed.characteristics.join(' ').toLowerCase();
        final temperament = breed.temperament.toLowerCase();
        final description = breed.description.toLowerCase();
        final allText = '$characteristics $temperament $description'
            .toLowerCase();

        switch (_selectedNoiseLevel) {
          case 'Quiet':
            return allText.contains('quiet') ||
                allText.contains('soft') ||
                allText.contains('gentle') ||
                allText.contains('peaceful') ||
                breed.name.toLowerCase().contains('canary') ||
                breed.name.toLowerCase().contains('finch') ||
                breed.name.toLowerCase().contains('dove') ||
                breed.name.toLowerCase().contains('budgerigar') ||
                breed.name.toLowerCase().contains('budgie');

          case 'Moderate':
            return allText.contains('moderate') ||
                allText.contains('can be loud') ||
                allText.contains('good singer') ||
                allText.contains('vocal') ||
                breed.name.toLowerCase().contains('conure') ||
                breed.name.toLowerCase().contains('lovebird') ||
                breed.name.toLowerCase().contains('parrotlet') ||
                breed.name.toLowerCase().contains('cockatiel') ||
                breed.name.toLowerCase().contains('parakeet');

          case 'Loud':
            return allText.contains('loud') ||
                allText.contains('very loud') ||
                allText.contains('noisy') ||
                allText.contains('powerful voice') ||
                breed.name.toLowerCase().contains('macaw') ||
                breed.name.toLowerCase().contains('cockatoo') ||
                breed.name.toLowerCase().contains('african grey') ||
                breed.name.toLowerCase().contains('ringneck');

          default:
            return true;
        }
      }).toList();
    }

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
      case 'Size (Small-Large)':
        list.sort((a, b) {
          final avgA = (a.weight.min + a.weight.max) / 2;
          final avgB = (b.weight.min + b.weight.max) / 2;
          return avgA.compareTo(avgB);
        });
        break;
      case 'Size (Large-Small)':
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
      case 'Talking Ability':
        list.sort((a, b) {
          final aTalks = a.characteristics.any(
            (c) =>
                c.toLowerCase().contains('talk') ||
                c.toLowerCase().contains('mimic') ||
                c.toLowerCase().contains('voice'),
          );
          final bTalks = b.characteristics.any(
            (c) =>
                c.toLowerCase().contains('talk') ||
                c.toLowerCase().contains('mimic') ||
                c.toLowerCase().contains('voice'),
          );
          if (aTalks && !bTalks) return -1;
          if (!aTalks && bTalks) return 1;
          return 0;
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
      'Size (Large-Small)',
      'Lifespan (Short-Long)',
      'Lifespan (Long-Short)',
      'Talking Ability',
    ];

    final sizeOptions = [
      'All',
      'Small (0-50g)',
      'Medium (50g-300g)',
      'Large (300g-1kg)',
      'Extra Large (1kg+)',
    ];

    final noiseOptions = ['All', 'Quiet', 'Moderate', 'Loud'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bird Breeds', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4CAF50),
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
                    hintText: 'Search bird breeds...',
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF4CAF50),
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
                              color: Color(0xFF4CAF50),
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
                              color: Colors.green,
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

                    // Noise Level Filter
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
                            value: _selectedNoiseLevel,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.volume_up,
                              size: 18,
                              color: Colors.orange,
                            ),
                            items: noiseOptions.map((option) {
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
                                _selectedNoiseLevel = value!;
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
                  '${filteredBreeds.length} Bird Breeds',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                  ),
                ),
                if (_selectedSize != 'All' ||
                    _selectedNoiseLevel != 'All' ||
                    _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedSize = 'All';
                        _selectedNoiseLevel = 'All';
                        _searchController.clear();
                        _filterBreeds();
                      });
                    },
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(color: Color(0xFF4CAF50)),
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
                          Icons.air,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No bird breeds found',
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
