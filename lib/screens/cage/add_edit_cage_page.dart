import 'package:flutter/material.dart';
import '../../models/pet_cage.dart';

class AddEditCagePage extends StatefulWidget {
  final PetCage? cage;

  const AddEditCagePage({super.key, this.cage});

  @override
  State<AddEditCagePage> createState() => _AddEditCagePageState();
}

class _AddEditCagePageState extends State<AddEditCagePage> {
  final _formKey = GlobalKey<FormState>();
  final _featuresController = TextEditingController();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _petTypeController;
  late TextEditingController _dimensionsController;
  late TextEditingController _materialController;
  late TextEditingController _weightController;
  late TextEditingController _assemblyRequiredController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _brandController;
  late TextEditingController _manufacturerController;
  late TextEditingController _imageUrlController;
  late TextEditingController _cleaningInstructionsController;
  late TextEditingController _warrantyController;
  late TextEditingController _includedAccessoriesController;

  late List<String> _features;
  late bool _isPortable;
  late bool _hasWheels;

  @override
  void initState() {
    super.initState();

    final cage = widget.cage;

    _nameController = TextEditingController(text: cage?.name ?? '');
    _descriptionController = TextEditingController(
      text: cage?.description ?? '',
    );
    _categoryController = TextEditingController(text: cage?.category ?? '');
    _petTypeController = TextEditingController(text: cage?.petType ?? '');
    _dimensionsController = TextEditingController(text: cage?.dimensions ?? '');
    _materialController = TextEditingController(text: cage?.material ?? '');
    _weightController = TextEditingController(text: cage?.weight ?? '');
    _assemblyRequiredController = TextEditingController(
      text: cage?.assemblyRequired ?? '',
    );
    _priceController = TextEditingController(
      text: cage?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: cage?.stock.toString() ?? '',
    );
    _brandController = TextEditingController(text: cage?.brand ?? '');
    _manufacturerController = TextEditingController(
      text: cage?.manufacturer ?? '',
    );
    _imageUrlController = TextEditingController(text: cage?.imageUrl ?? '');
    _cleaningInstructionsController = TextEditingController(
      text: cage?.cleaningInstructions ?? '',
    );
    _warrantyController = TextEditingController(text: cage?.warranty ?? '');
    _includedAccessoriesController = TextEditingController(
      text: cage?.includedAccessories ?? '',
    );

    _features = cage?.features ?? [];
    _isPortable = cage?.isPortable ?? false;
    _hasWheels = cage?.hasWheels ?? false;

    _featuresController.text = _features.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _petTypeController.dispose();
    _dimensionsController.dispose();
    _materialController.dispose();
    _weightController.dispose();
    _assemblyRequiredController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _manufacturerController.dispose();
    _imageUrlController.dispose();
    _cleaningInstructionsController.dispose();
    _warrantyController.dispose();
    _includedAccessoriesController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  void _saveCage() {
    if (_formKey.currentState!.validate()) {
      final features = _featuresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final cage = PetCage(
        id: widget.cage?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        petType: _petTypeController.text,
        dimensions: _dimensionsController.text,
        material: _materialController.text,
        weight: _weightController.text,
        assemblyRequired: _assemblyRequiredController.text,
        features: features,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        brand: _brandController.text,
        manufacturer: _manufacturerController.text,
        imageUrl: _imageUrlController.text,
        cleaningInstructions: _cleaningInstructionsController.text,
        warranty: _warrantyController.text,
        isPortable: _isPortable,
        hasWheels: _hasWheels,
        includedAccessories: _includedAccessoriesController.text,
      );

      Navigator.pop(context, cage);
    }
  }

  void _showFeaturesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Features'),
        content: TextField(
          controller: _featuresController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter features separated by commas',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.cage != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Cage' : 'Add New Cage',style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF4A6FA5),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveCage,
            tooltip: 'Save',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _buildFormSection(
                title: 'Basic Information',
                icon: Icons.pets,
                color: Colors.blue,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Cage Name *',
                    hint: 'Enter cage name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cage name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description *',
                    hint: 'Enter description',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _categoryController,
                          label: 'Category *',
                          hint: 'e.g., Dog Crate, Bird Cage',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter category';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _petTypeController,
                          label: 'Pet Type *',
                          hint: 'e.g., Dog, Cat, Bird',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pet type';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Specifications
              _buildFormSection(
                title: 'Specifications',
                icon: Icons.settings,
                color: Colors.green,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _dimensionsController,
                          label: 'Dimensions *',
                          hint: 'e.g., 36"L x 24"W x 27"H',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter dimensions';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _materialController,
                          label: 'Material *',
                          hint: 'e.g., Steel, Plastic',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter material';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _weightController,
                          label: 'Weight *',
                          hint: 'e.g., 28 lbs',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _assemblyRequiredController,
                          label: 'Assembly Required *',
                          hint: 'e.g., Minimal assembly required',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter assembly info';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Features
              _buildFormSection(
                title: 'Features & Options',
                icon: Icons.star,
                color: Colors.orange,
                children: [
                  InkWell(
                    onTap: _showFeaturesDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Features (comma separated)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _featuresController.text.isEmpty
                                      ? 'Tap to edit features'
                                      : _featuresController.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _featuresController.text.isEmpty
                                        ? Colors.grey
                                        : Colors.black,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Portable'),
                          value: _isPortable,
                          onChanged: (value) {
                            setState(() {
                              _isPortable = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Has Wheels'),
                          value: _hasWheels,
                          onChanged: (value) {
                            setState(() {
                              _hasWheels = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _includedAccessoriesController,
                    label: 'Included Accessories',
                    hint: 'e.g., Divider panel, plastic tray',
                    maxLines: 2,
                  ),
                ],
              ),

              // Price & Stock
              _buildFormSection(
                title: 'Price & Stock',
                icon: Icons.attach_money,
                color: Colors.purple,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Price (\$) *',
                          hint: '0.00',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _stockController,
                          label: 'Stock (units) *',
                          hint: '0',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter stock quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Manufacturer & Warranty
              _buildFormSection(
                title: 'Manufacturer & Warranty',
                icon: Icons.business,
                color: Colors.teal,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _brandController,
                          label: 'Brand *',
                          hint: 'Enter brand name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter brand';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _manufacturerController,
                          label: 'Manufacturer *',
                          hint: 'Enter manufacturer',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter manufacturer';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _warrantyController,
                          label: 'Warranty',
                          hint: 'e.g., 1-year warranty',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _imageUrlController,
                          label: 'Image URL',
                          hint: 'Enter image URL',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _cleaningInstructionsController,
                    label: 'Cleaning Instructions',
                    hint: 'Enter cleaning instructions',
                    maxLines: 3,
                  ),
                ],
              ),

              // Action Buttons
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveCage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FA5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update Cage' : 'Add Cage',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
