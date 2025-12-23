import 'package:flutter/material.dart';
import '../models/pet_profile.dart';

class PetManagementPage extends StatefulWidget {
  const PetManagementPage({super.key});

  @override
  State<PetManagementPage> createState() => _PetManagementPageState();
}

class _PetManagementPageState extends State<PetManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';
  String _sortBy = 'Name (A-Z)';
  late List<PetProfile> _filteredPets;

  @override
  void initState() {
    super.initState();
    _filteredPets = List.from(petProfiles);
    _searchController.addListener(_applyFilters);
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final term = _searchController.text.toLowerCase();
    List<PetProfile> temp = List.from(petProfiles);

    if (term.isNotEmpty) {
      temp = temp.where((p) {
        return p.name.toLowerCase().contains(term) ||
            p.breed.toLowerCase().contains(term) ||
            p.type.toLowerCase().contains(term);
      }).toList();
    }

    if (_selectedType != 'All') {
      temp = temp.where((p) => p.type == _selectedType).toList();
    }

    temp.sort((a, b) {
      switch (_sortBy) {
        case 'Name (Z-A)':
          return b.name.compareTo(a.name);
        default:
          return a.name.compareTo(b.name);
      }
    });

    setState(() {
      _filteredPets = temp;
    });
  }

  int _nextId() {
    if (petProfiles.isEmpty) return 1;
    return petProfiles.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  void _addPet() {
    _openPetForm();
  }

  void _editPet(PetProfile pet) {
    _openPetForm(pet: pet);
  }

  void _deletePet(PetProfile pet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Delete "${pet.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              petProfiles.removeWhere((p) => p.id == pet.id);
              _applyFilters();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${pet.name} deleted'),
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

  void _openPetForm({PetProfile? pet}) {
    final isEditing = pet != null;
    final nameCtrl = TextEditingController(text: pet?.name ?? '');
    final typeCtrl = TextEditingController(text: pet?.type ?? 'Dog');
    final breedCtrl = TextEditingController(text: pet?.breed ?? '');
    final ageCtrl = TextEditingController(text: pet?.age ?? '');
    final notesCtrl = TextEditingController(text: pet?.notes ?? '');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? 'Edit Pet' : 'Add Pet',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTextField('Name', nameCtrl),
              const SizedBox(height: 12),
              _buildTextField('Type (Dog, Cat...)', typeCtrl),
              const SizedBox(height: 12),
              _buildTextField('Breed', breedCtrl),
              const SizedBox(height: 12),
              _buildTextField('Age (e.g., 3 years)', ageCtrl),
              const SizedBox(height: 12),
              _buildTextField('Notes', notesCtrl, maxLines: 3),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(
                    isEditing ? 'Update Pet' : 'Save Pet',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A6FA5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (nameCtrl.text.trim().isEmpty ||
                        typeCtrl.text.trim().isEmpty ||
                        breedCtrl.text.trim().isEmpty ||
                        ageCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please fill required fields'),
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final newPet = PetProfile(
                      id: isEditing ? pet.id : _nextId(),
                      name: nameCtrl.text.trim(),
                      type: typeCtrl.text.trim(),
                      breed: breedCtrl.text.trim(),
                      age: ageCtrl.text.trim(),
                      notes: notesCtrl.text.trim(),
                    );

                    if (isEditing) {
                      final idx = petProfiles.indexWhere((p) => p.id == pet.id);
                      if (idx != -1) {
                        petProfiles[idx] = newPet;
                      }
                    } else {
                      petProfiles.add(newPet);
                    }

                    _applyFilters();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing ? 'Pet updated' : 'Pet added'),
                        backgroundColor: isEditing ? Colors.blue : Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeOptions = ['All', ...petProfiles.map((p) => p.type).toSet()];
    final sortOptions = ['Name (A-Z)', 'Name (Z-A)'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Pet Profiles',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addPet,
            tooltip: 'Add Pet',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search pets...',
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
                              _applyFilters();
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Type',
                        value: _selectedType,
                        items: typeOptions,
                        onChanged: (value) {
                          setState(() => _selectedType = value!);
                          _applyFilters();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Sort',
                        value: _sortBy,
                        items: sortOptions,
                        onChanged: (value) {
                          setState(() => _sortBy = value!);
                          _applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredPets.isEmpty
                ? const Center(child: Text('No pets found'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pet = _filteredPets[index];
                      return _PetCard(
                        pet: pet,
                        onEdit: () => _editPet(pet),
                        onDelete: () => _deletePet(pet),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _PetCard extends StatelessWidget {
  const _PetCard({
    required this.pet,
    required this.onEdit,
    required this.onDelete,
  });

  final PetProfile pet;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Color(0xFF4A6FA5)),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${pet.type} • ${pet.breed}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              'Age: ${pet.age}',
              style: const TextStyle(color: Colors.black54),
            ),
            if (pet.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(pet.notes, style: const TextStyle(color: Colors.black87)),
            ],
          ],
        ),
      ),
    );
  }
}
