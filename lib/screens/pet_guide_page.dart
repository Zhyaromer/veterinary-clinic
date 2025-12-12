// screens/pet_guide_page.dart
import 'package:flutter/material.dart';
import '../models/pet_guide.dart';
import '../widgets/pet_card.dart';
import 'pet_detail_page.dart';

class PetGuidePage extends StatefulWidget {
  const PetGuidePage({super.key});

  @override
  State<PetGuidePage> createState() => _PetGuidePageState();
}

class _PetGuidePageState extends State<PetGuidePage> {
  final TextEditingController _searchController = TextEditingController();
  List<PetGuide> filteredPets = List.from(petGuides);

  // Filter states
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Dog',
    'Cat',
    'Bird',
    'Small Mammal',
    'Reptile',
    'Fish',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPets);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPets() {
    setState(() {
      filteredPets = petGuides.where((pet) {
        final matchesSearch =
            _searchController.text.isEmpty ||
            pet.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            pet.category.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            pet.scientificName.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final matchesCategory =
            _selectedCategory == 'All' || pet.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      filteredPets = List.from(petGuides);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Care Guides',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4A6FA5),
        actions: [
          if (_selectedCategory != 'All' || _searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetFilters,
              tooltip: 'Clear Filters',
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
                hintText:
                    'Search pets by name, category, or scientific name...',
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
                          _filterPets();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                _filterPets();
              },
            ),
          ),

          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Category:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          checkmarkColor: Colors.white,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = selected ? category : 'All';
                              _filterPets();
                            });
                          },
                          selectedColor: const Color(0xFF4A6FA5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
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
                  '${filteredPets.length} Care Guides Found',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                if (_selectedCategory != 'All' ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Clear All'),
                  ),
              ],
            ),
          ),

          // Pets Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: filteredPets.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No pet guides found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Try different search terms',
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
                            childAspectRatio: 0.75,
                          ),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        final petGuide = filteredPets[index];
                        return PetCard(
                          petGuide: petGuide,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PetDetailPage(petGuide: petGuide),
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
