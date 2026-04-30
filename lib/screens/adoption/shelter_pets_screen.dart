import 'package:flutter/material.dart';
import '../../models/shelter_pet.dart';
import '../../widgets/shelter_pet_card.dart';
import 'pet_adoption_detail_screen.dart';

class ShelterPetsScreen extends StatefulWidget {
  const ShelterPetsScreen({super.key});

  @override
  State<ShelterPetsScreen> createState() => _ShelterPetsScreenState();
}

class _ShelterPetsScreenState extends State<ShelterPetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ShelterPet> filteredPets = List.from(shelterPets);

  // Filter states
  String _selectedPetType = 'All';
  String _selectedGender = 'All';
  String _selectedSize = 'All';
  String _selectedLocation = 'All';
  String _selectedHealthStatus = 'All';
  bool _showOnlyAvailable = true;
  String _sortBy = 'Newest Arrivals';

  final List<String> petTypes = [
    'All',
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Small Animal',
  ];
  final List<String> genders = ['All', 'Male', 'Female'];
  final List<String> sizes = ['All', 'Small', 'Medium', 'Large'];
  final List<String> locations = [
    'All',
    'Main Shelter',
    'Foster Home',
    'Special Care Unit',
    'Puppy Room',
    'Small Animal Room',
  ];
  final List<String> healthStatuses = [
    'All',
    'Excellent',
    'Good',
    'Fair',
    'Needs Attention',
  ];
  final List<String> sortOptions = [
    'Newest Arrivals',
    'Longest Residents',
    'Lowest Fee',
    'Highest Fee',
    'Name (A-Z)',
    'Name (Z-A)',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterPets);
    _applySorting();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPets() {
    setState(() {
      filteredPets = shelterPets.where((pet) {
        // Search filter
        final matchesSearch =
            _searchController.text.isEmpty ||
            pet.name.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            pet.breed.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            pet.description.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        // Type filter
        final matchesType =
            _selectedPetType == 'All' || pet.type == _selectedPetType;

        // Gender filter
        final matchesGender =
            _selectedGender == 'All' || pet.gender == _selectedGender;

        // Size filter
        final matchesSize = _selectedSize == 'All' || pet.size == _selectedSize;

        // Location filter
        final matchesLocation =
            _selectedLocation == 'All' || pet.location == _selectedLocation;

        // Health status filter
        final matchesHealth =
            _selectedHealthStatus == 'All' ||
            pet.healthStatus == _selectedHealthStatus;

        // Availability filter
        final matchesAvailability = !_showOnlyAvailable || !pet.isAdopted;

        return matchesSearch &&
            matchesType &&
            matchesGender &&
            matchesSize &&
            matchesLocation &&
            matchesHealth &&
            matchesAvailability;
      }).toList();

      _applySorting();
    });
  }

  void _applySorting() {
    setState(() {
      switch (_sortBy) {
        case 'Newest Arrivals':
          filteredPets.sort((a, b) => b.arrivalDate.compareTo(a.arrivalDate));
          break;
        case 'Longest Residents':
          filteredPets.sort(
            (a, b) => a.daysInShelter.compareTo(b.daysInShelter),
          );
          break;
        case 'Lowest Fee':
          filteredPets.sort((a, b) => a.adoptionFee.compareTo(b.adoptionFee));
          break;
        case 'Highest Fee':
          filteredPets.sort((a, b) => b.adoptionFee.compareTo(a.adoptionFee));
          break;
        case 'Name (A-Z)':
          filteredPets.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Name (Z-A)':
          filteredPets.sort((a, b) => b.name.compareTo(a.name));
          break;
      }
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedPetType = 'All';
      _selectedGender = 'All';
      _selectedSize = 'All';
      _selectedLocation = 'All';
      _selectedHealthStatus = 'All';
      _showOnlyAvailable = true;
      _sortBy = 'Newest Arrivals';
      _filterPets();
    });
  }

  void _showFilterDialog() {
    // Local dialog variables
    String dialogPetType = _selectedPetType;
    String dialogGender = _selectedGender;
    String dialogSize = _selectedSize;
    String dialogLocation = _selectedLocation;
    String dialogHealthStatus = _selectedHealthStatus;
    bool dialogShowOnlyAvailable = _showOnlyAvailable;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: Colors.blue.shade700,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Filter & Sort Pets',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content (no scroll, auto-sized)
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sort Options Section
                            _buildSectionHeader('Sort By', Icons.sort_rounded),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: sortOptions.map((option) {
                                final isSelected = _sortBy == option;
                                return ChoiceChip(
                                  label: Text(option),
                                  selected: isSelected,
                                  selectedColor: Colors.blue.shade600,
                                  backgroundColor: Colors.white,
                                  elevation: isSelected ? 2 : 0,
                                  shadowColor: Colors.blue.withOpacity(0.3),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.blue.shade600
                                        : Colors.grey.shade300,
                                    width: isSelected ? 0 : 1,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  checkmarkColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      _sortBy = option;
                                    });
                                    _applySorting();
                                    Navigator.pop(context);
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),

                            // Pet Type Filter
                            _buildSectionHeader('Pet Type', Icons.pets_rounded),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: petTypes.map((type) {
                                final isSelected = dialogPetType == type;
                                return FilterChip(
                                  label: Text(type),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      dialogPetType = selected ? type : 'All';
                                    });
                                  },
                                  selectedColor: Colors.blue.shade600,
                                  backgroundColor: Colors.white,
                                  elevation: isSelected ? 2 : 0,
                                  shadowColor: Colors.blue.withOpacity(0.3),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.blue.shade600
                                        : Colors.grey.shade300,
                                    width: isSelected ? 0 : 1,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  checkmarkColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),

                            // Gender Filter
                            _buildSectionHeader('Gender', Icons.wc_rounded),
                            const SizedBox(height: 12),
                            Row(
                              children: genders.map((gender) {
                                final isSelected = dialogGender == gender;
                                return SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: gender != genders.last ? 10 : 0,
                                    ),
                                    child: FilterChip(
                                      label: SizedBox(
                                        width: 75,
                                        child: Text(
                                          gender,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          dialogGender = selected
                                              ? gender
                                              : 'All';
                                        });
                                      },
                                      selectedColor: Colors.blue.shade600,
                                      backgroundColor: Colors.white,
                                      elevation: isSelected ? 2 : 0,
                                      shadowColor: Colors.blue.withOpacity(0.3),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Colors.blue.shade600
                                            : Colors.grey.shade300,
                                        width: isSelected ? 0 : 1,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                      checkmarkColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),

                            // Size Filter
                            _buildSectionHeader(
                              'Size',
                              Icons.straighten_rounded,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: sizes.map((size) {
                                final isSelected = dialogSize == size;
                                return SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: size != sizes.last ? 10 : 0,
                                    ),
                                    child: FilterChip(
                                      label: SizedBox(
                                        width: 75,
                                        child: Text(
                                          size,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          dialogSize = selected ? size : 'All';
                                        });
                                      },
                                      selectedColor: Colors.blue.shade600,
                                      backgroundColor: Colors.white,
                                      elevation: isSelected ? 2 : 0,
                                      shadowColor: Colors.blue.withOpacity(0.3),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Colors.blue.shade600
                                            : Colors.grey.shade300,
                                        width: isSelected ? 0 : 1,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                      ),
                                      checkmarkColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),

                            // Health Status Filter
                            _buildSectionHeader(
                              'Health Status',
                              Icons.favorite_rounded,
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: healthStatuses.map((status) {
                                final isSelected = dialogHealthStatus == status;
                                return FilterChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setModalState(() {
                                      dialogHealthStatus = selected
                                          ? status
                                          : 'All';
                                    });
                                  },
                                  selectedColor: Colors.blue.shade600,
                                  backgroundColor: Colors.white,
                                  elevation: isSelected ? 2 : 0,
                                  shadowColor: Colors.blue.withOpacity(0.3),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.blue.shade600
                                        : Colors.grey.shade300,
                                    width: isSelected ? 0 : 1,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                                  checkmarkColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),

                            // Availability Filter
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: SwitchListTile(
                                title: const Text(
                                  'Show Only Available Pets',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Hide pets that have already been adopted',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                value: dialogShowOnlyAvailable,
                                activeColor: Colors.blue.shade700,
                                onChanged: (value) {
                                  setModalState(() {
                                    dialogShowOnlyAvailable = value;
                                  });
                                },
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Buttons
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(28),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _resetFilters,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                'Reset All',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPetType = dialogPetType;
                                  _selectedGender = dialogGender;
                                  _selectedSize = dialogSize;
                                  _selectedLocation = dialogLocation;
                                  _selectedHealthStatus = dialogHealthStatus;
                                  _showOnlyAvailable = dialogShowOnlyAvailable;
                                });
                                _filterPets();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Apply Filters',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper method for section headers
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  void _adoptPet(ShelterPet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetAdoptionDetailScreen(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availablePets = shelterPets.where((pet) => !pet.isAdopted).length;
    final totalPets = shelterPets.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pet Shelter & Adoption',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterDialog,
            tooltip: 'Filter & Sort',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.pets,
                  value: totalPets.toString(),
                  label: 'Total Pets',
                  color: Colors.blue,
                ),
                _buildStatItem(
                  icon: Icons.home,
                  value: availablePets.toString(),
                  label: 'Available',
                  color: Colors.green,
                ),
                _buildStatItem(
                  icon: Icons.favorite,
                  value: '${totalPets - availablePets}',
                  label: 'Adopted',
                  color: Colors.purple,
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search pets by name, breed, or description...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterPets();
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              onChanged: (value) => _filterPets(),
            ),
          ),

          // Active Filters & Results
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filteredPets.length} pets found',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Sorted by: $_sortBy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(height: 12),
                  ],
                ),
                if (_selectedPetType != 'All' ||
                    _selectedGender != 'All' ||
                    _selectedSize != 'All' ||
                    _selectedLocation != 'All' ||
                    _selectedHealthStatus != 'All' ||
                    !_showOnlyAvailable ||
                    _searchController.text.isNotEmpty)
                  TextButton.icon(
                    onPressed: _resetFilters,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),

          // Active Filters Chips
          if (_selectedPetType != 'All' ||
              _selectedGender != 'All' ||
              _selectedSize != 'All' ||
              _selectedLocation != 'All' ||
              _selectedHealthStatus != 'All' ||
              !_showOnlyAvailable)
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 16,
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (_selectedPetType != 'All')
                    _buildActiveFilterChip(
                      'Type: $_selectedPetType',
                      onDelete: () {
                        setState(() {
                          _selectedPetType = 'All';
                        });
                        _filterPets();
                      },
                    ),
                  if (_selectedGender != 'All')
                    _buildActiveFilterChip(
                      'Gender: $_selectedGender',
                      onDelete: () {
                        setState(() {
                          _selectedGender = 'All';
                        });
                        _filterPets();
                      },
                    ),
                  if (_selectedSize != 'All')
                    _buildActiveFilterChip(
                      'Size: $_selectedSize',
                      onDelete: () {
                        setState(() {
                          _selectedSize = 'All';
                        });
                        _filterPets();
                      },
                    ),
                  if (_selectedLocation != 'All')
                    _buildActiveFilterChip(
                      'Location: $_selectedLocation',
                      onDelete: () {
                        setState(() {
                          _selectedLocation = 'All';
                        });
                        _filterPets();
                      },
                    ),
                  if (_selectedHealthStatus != 'All')
                    _buildActiveFilterChip(
                      'Health: $_selectedHealthStatus',
                      onDelete: () {
                        setState(() {
                          _selectedHealthStatus = 'All';
                        });
                        _filterPets();
                      },
                    ),
                  if (!_showOnlyAvailable)
                    _buildActiveFilterChip(
                      'Show All',
                      onDelete: () {
                        setState(() {
                          _showOnlyAvailable = true;
                        });
                        _filterPets();
                      },
                    ),
                ],
              ),
            ),

          // Pets List
          Expanded(
            child: filteredPets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pets, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 20),
                        const Text(
                          'No pets found',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Try adjusting your filters or search terms',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _resetFilters,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Reset All Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = filteredPets[index];
                      return ShelterPetCard(
                        pet: pet,
                        onTap: () => _adoptPet(pet),
                        onAdopt: pet.isAdopted ? null : () => _adoptPet(pet),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildActiveFilterChip(
    String label, {
    required VoidCallback onDelete,
  }) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide(color: Colors.blue.shade200, width: 1),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onDelete,
    );
  }
}
