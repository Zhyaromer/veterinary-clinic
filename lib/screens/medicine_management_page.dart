import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../widgets/medicine_management_card.dart';
import 'add_edit_medicine_page.dart';

class MedicineManagementPage extends StatefulWidget {
  const MedicineManagementPage({super.key});

  @override
  State<MedicineManagementPage> createState() => _MedicineManagementPageState();
}

class _MedicineManagementPageState extends State<MedicineManagementPage> {
  late List<Medicine> medicinesList;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'Name (A-Z)';

  @override
  void initState() {
    super.initState();
    medicinesList = List.from(medicines);
    _searchController.addListener(_filterMedicines);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterMedicines() {
    final searchTerm = _searchController.text.toLowerCase();
    List<Medicine> filtered = List.from(medicines);

    if (searchTerm.isNotEmpty) {
      filtered = filtered.where((medicine) {
        return medicine.name.toLowerCase().contains(searchTerm) ||
            medicine.category.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedCategory != 'All') {
      filtered = filtered.where((medicine) {
        return medicine.category == _selectedCategory;
      }).toList();
    }

    // Apply sorting
    filtered = _sortMedicines(filtered);

    setState(() {
      medicinesList = filtered;
    });
  }

  List<Medicine> _sortMedicines(List<Medicine> list) {
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
      case 'Expiry Date (Near)':
        list.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
        break;
      case 'Expiry Date (Far)':
        list.sort((a, b) => b.expiryDate.compareTo(a.expiryDate));
        break;
    }
    return list;
  }

  void _addNewMedicine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditMedicinePage(),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          medicines.add(value as Medicine);
          _filterMedicines();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Medicine added successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _editMedicine(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMedicinePage(medicine: medicine),
        fullscreenDialog: true,
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          final index = medicines.indexWhere((m) => m.id == medicine.id);
          if (index != -1) {
            medicines[index] = value as Medicine;
            _filterMedicines();
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Medicine updated successfully'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _deleteMedicine(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text('Are you sure you want to delete "${medicine.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                medicines.removeWhere((m) => m.id == medicine.id);
                _filterMedicines();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${medicine.name}" deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _duplicateMedicine(Medicine medicine) {
    final newId = medicines.map((m) => m.id).reduce((a, b) => a > b ? a : b) + 1;
    final duplicatedMedicine = Medicine(
      id: newId,
      name: '${medicine.name} (Copy)',
      barcode: '${medicine.barcode}-COPY',
      batchNumber: '${medicine.batchNumber}-COPY',
      composition: medicine.composition,
      form: medicine.form,
      route: medicine.route,
      animalType: medicine.animalType,
      category: medicine.category,
      indications: List.from(medicine.indications),
      dosage: medicine.dosage,
      administrationInstructions: medicine.administrationInstructions,
      usage: medicine.usage,
      sideEffects: List.from(medicine.sideEffects),
      interactions: List.from(medicine.interactions),
      contraindications: List.from(medicine.contraindications),
      overdose: medicine.overdose,
      handlingPrecautions: medicine.handlingPrecautions,
      storage: MedicineStorage(
        temperature: medicine.storage.temperature,
        lightProtection: medicine.storage.lightProtection,
        afterOpening: medicine.storage.afterOpening,
      ),
      withdrawalPeriod: medicine.withdrawalPeriod,
      packaging: medicine.packaging,
      manufacturer: Manufacturer(
        name: medicine.manufacturer.name,
        address: medicine.manufacturer.address,
        phone: medicine.manufacturer.phone,
      ),
      regulatoryApprovalNumber: '${medicine.regulatoryApprovalNumber}-COPY',
      price: medicine.price,
      stock: medicine.stock,
      expiryDate: medicine.expiryDate,
      imageUrl: medicine.imageUrl,
    );

    setState(() {
      medicines.add(duplicatedMedicine);
      _filterMedicines();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${medicine.name}" duplicated successfully'),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _resetStock(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Stock'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current stock: ${medicine.stock} units'),
            const SizedBox(height: 16),
            const Text('Enter new stock quantity:'),
            const SizedBox(height: 8),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: medicine.stock.toString(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Stock Quantity',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // In a real app, you would update the stock here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Stock updated successfully'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...medicines.map((m) => m.category).toSet().toList()];
    final sortOptions = [
      'Name (A-Z)',
      'Name (Z-A)',
      'Price (Low-High)',
      'Price (High-Low)',
      'Stock (Low-High)',
      'Stock (High-Low)',
      'Expiry Date (Near)',
      'Expiry Date (Far)',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Medicines', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _addNewMedicine,
            tooltip: 'Add New Medicine',
          ),
        ],
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
                    hintText: 'Search medicines...',
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
                              _filterMedicines();
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => _filterMedicines(),
                ),
                const SizedBox(height: 16),
                
                // Filters Row
                Row(
                  children: [
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
                            icon: const Icon(Icons.arrow_drop_down),
                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value!;
                                _filterMedicines();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    
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
                                _filterMedicines();
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
                  '${medicinesList.length} Medicines',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF444444),
                  ),
                ),
                if (_selectedCategory != 'All' || _searchController.text.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = 'All';
                        _searchController.clear();
                        _filterMedicines();
                      });
                    },
                    child: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),

          // Medicines List
          Expanded(
            child: medicinesList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medication_liquid,
                          size: 80,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No medicines found',
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
                          onPressed: _addNewMedicine,
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Medicine'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6FA5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: medicinesList.length,
                    itemBuilder: (context, index) {
                      final medicine = medicinesList[index];
                      return MedicineManagementCard(
                        medicine: medicine,
                        onEdit: () => _editMedicine(medicine),
                        onDelete: () => _deleteMedicine(medicine),
                        onDuplicate: () => _duplicateMedicine(medicine),
                        onResetStock: () => _resetStock(medicine),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}