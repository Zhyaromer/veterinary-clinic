import 'package:flutter/material.dart';
import '../models/pet_toy.dart';

class AddEditToyPage extends StatefulWidget {
  final PetToy? toy;

  const AddEditToyPage({super.key, this.toy});

  @override
  State<AddEditToyPage> createState() => _AddEditToyPageState();
}

class _AddEditToyPageState extends State<AddEditToyPage> {
  final _formKey = GlobalKey<FormState>();
  final _featuresController = TextEditingController();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _petTypeController;
  late TextEditingController _sizeController;
  late TextEditingController _materialController;
  late TextEditingController _safetyFeaturesController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _brandController;
  late TextEditingController _manufacturerController;
  late TextEditingController _imageUrlController;
  late TextEditingController _cleaningInstructionsController;
  late TextEditingController _warrantyController;
  late TextEditingController _ageSuitabilityController;

  late List<String> _features;
  late bool _isInteractive;
  late bool _isChewResistant;

  @override
  void initState() {
    super.initState();

    final toy = widget.toy;

    _nameController = TextEditingController(text: toy?.name ?? '');
    _descriptionController = TextEditingController(
      text: toy?.description ?? '',
    );
    _categoryController = TextEditingController(text: toy?.category ?? '');
    _petTypeController = TextEditingController(text: toy?.petType ?? '');
    _sizeController = TextEditingController(text: toy?.size ?? '');
    _materialController = TextEditingController(text: toy?.material ?? '');
    _safetyFeaturesController = TextEditingController(
      text: toy?.safetyFeatures ?? '',
    );
    _priceController = TextEditingController(text: toy?.price.toString() ?? '');
    _stockController = TextEditingController(text: toy?.stock.toString() ?? '');
    _brandController = TextEditingController(text: toy?.brand ?? '');
    _manufacturerController = TextEditingController(
      text: toy?.manufacturer ?? '',
    );
    _imageUrlController = TextEditingController(text: toy?.imageUrl ?? '');
    _cleaningInstructionsController = TextEditingController(
      text: toy?.cleaningInstructions ?? '',
    );
    _warrantyController = TextEditingController(text: toy?.warranty ?? '');
    _ageSuitabilityController = TextEditingController(
      text: toy?.ageSuitability ?? '',
    );

    _features = toy?.features ?? [];
    _isInteractive = toy?.isInteractive ?? false;
    _isChewResistant = toy?.isChewResistant ?? false;

    _featuresController.text = _features.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _petTypeController.dispose();
    _sizeController.dispose();
    _materialController.dispose();
    _safetyFeaturesController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _manufacturerController.dispose();
    _imageUrlController.dispose();
    _cleaningInstructionsController.dispose();
    _warrantyController.dispose();
    _ageSuitabilityController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  void _saveToy() {
    if (_formKey.currentState!.validate()) {
      final features = _featuresController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final toy = PetToy(
        id: widget.toy?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        petType: _petTypeController.text,
        size: _sizeController.text,
        material: _materialController.text,
        safetyFeatures: _safetyFeaturesController.text,
        features: features,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        brand: _brandController.text,
        manufacturer: _manufacturerController.text,
        imageUrl: _imageUrlController.text,
        cleaningInstructions: _cleaningInstructionsController.text,
        warranty: _warrantyController.text,
        isInteractive: _isInteractive,
        isChewResistant: _isChewResistant,
        ageSuitability: _ageSuitabilityController.text,
      );

      Navigator.pop(context, toy);
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
    final isEditing = widget.toy != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Toy' : 'Add New Toy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveToy,
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
                icon: Icons.toys,
                color: Colors.orange,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Toy Name *',
                    hint: 'Enter toy name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter toy name';
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
                          hint: 'e.g., Puzzle Toy, Chew Toy',
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
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _ageSuitabilityController,
                    label: 'Age Suitability *',
                    hint: 'e.g., Puppy to Senior, All Ages',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age suitability';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Specifications
              _buildFormSection(
                title: 'Specifications',
                icon: Icons.settings,
                color: Colors.blue,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _sizeController,
                          label: 'Size *',
                          hint: 'e.g., Medium (15x15 cm)',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter size';
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
                          hint: 'e.g., BPA-free plastic, rubber',
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
                  _buildTextField(
                    controller: _safetyFeaturesController,
                    label: 'Safety Features *',
                    hint: 'e.g., Non-toxic materials, no small parts',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter safety features';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Features
              _buildFormSection(
                title: 'Features',
                icon: Icons.star,
                color: Colors.purple,
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
                          title: const Text('Interactive'),
                          value: _isInteractive,
                          onChanged: (value) {
                            setState(() {
                              _isInteractive = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text('Chew Resistant'),
                          value: _isChewResistant,
                          onChanged: (value) {
                            setState(() {
                              _isChewResistant = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Price & Stock
              _buildFormSection(
                title: 'Price & Stock',
                icon: Icons.attach_money,
                color: Colors.green,
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
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _warrantyController,
                    label: 'Warranty',
                    hint: 'e.g., 1-year manufacturer warranty',
                  ),
                ],
              ),

              // Manufacturer & Care
              _buildFormSection(
                title: 'Manufacturer & Care',
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
                          controller: _cleaningInstructionsController,
                          label: 'Cleaning Instructions *',
                          hint: 'Enter cleaning instructions',
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter cleaning instructions';
                            }
                            return null;
                          },
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
                ],
              ),

              // Action Buttons
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveToy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FA5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update Toy' : 'Add Toy',
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
