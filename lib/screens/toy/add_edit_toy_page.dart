import 'package:flutter/material.dart';
import '../../models/pet_toy.dart';

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

  // Dropdown values
  late String _selectedCategory;
  late String _selectedPetType;
  late String _selectedAgeSuitability;
  late String _selectedSize;
  late String _selectedMaterial;
  late String _selectedWarranty;
  late String _selectedManufacturer;

  late List<String> _features;
  late bool _isInteractive;
  late bool _isChewResistant;

  // Dropdown options based on the filter image
  final List<String> _categoryOptions = [
    'All',
    'Puzzle Toy',
    'Kicker Toy',
    'Chew Toy',
    'Interactive Wand',
    'Plush Toy',
    'Foraging Toy',
    'Electronic Toy',
    'Rope Toy',
  ];

  final List<String> _petTypeOptions = [
    'All',
    'Dog',
    'Cat',
    'Bird',
    'Small Animal',
  ];

  final List<String> _ageSuitabilityOptions = [
    'Puppy/Kitten (0-1 year)',
    'Adult (1-7 years)',
    'Senior (7+ years)',
    'All Ages',
  ];

  final List<String> _sizeOptions = [
    'Extra Small (XS)',
    'Small (S)',
    'Medium (M)',
    'Large (L)',
    'Extra Large (XL)',
  ];

  final List<String> _materialOptions = [
    'Natural Rubber',
    'BPA-Free Plastic',
    'Organic Cotton',
    'Hemp',
    'Recycled Materials',
    'Wood',
    'Silicone',
    'Nylon',
    'Rope',
  ];

  final List<String> _warrantyOptions = [
    'No Warranty',
    '30 Days',
    '90 Days',
    '6 Months',
    '1 Year',
    '2 Years',
    'Lifetime',
  ];

  final List<String> _manufacturerOptions = [
    'Pawfect Play',
    'Meow Magic',
    'Happy Paws Co.',
    'EcoPet Toys',
    'K9 Creations',
    'Feline Fun Ltd.',
    'Birdie Bliss',
    'Small Pet Paradise',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    final toy = widget.toy;

    _nameController = TextEditingController(text: toy?.name ?? '');
    _descriptionController = TextEditingController(
      text: toy?.description ?? '',
    );
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

    // Initialize dropdown selections
    _selectedCategory = _categoryOptions.contains(toy?.category)
        ? toy!.category
        : (toy?.category.isNotEmpty == true
              ? toy!.category
              : _categoryOptions.first);
    _selectedPetType = _petTypeOptions.contains(toy?.petType)
        ? toy!.petType
        : (toy?.petType.isNotEmpty == true
              ? toy!.petType
              : _petTypeOptions.first);
    _selectedAgeSuitability =
        _ageSuitabilityOptions.contains(toy?.ageSuitability)
        ? toy!.ageSuitability
        : (toy?.ageSuitability.isNotEmpty == true
              ? toy!.ageSuitability
              : _ageSuitabilityOptions.first);
    _selectedSize = _sizeOptions.contains(toy?.size)
        ? toy!.size
        : (toy?.size.isNotEmpty == true ? toy!.size : _sizeOptions.first);
    _selectedMaterial = _materialOptions.contains(toy?.material)
        ? toy!.material
        : (toy?.material.isNotEmpty == true
              ? toy!.material
              : _materialOptions.first);
    _selectedWarranty = _warrantyOptions.contains(toy?.warranty)
        ? toy!.warranty
        : (toy?.warranty.isNotEmpty == true
              ? toy!.warranty
              : _warrantyOptions.first);
    _selectedManufacturer = _manufacturerOptions.contains(toy?.manufacturer)
        ? toy!.manufacturer
        : (toy?.manufacturer.isNotEmpty == true
              ? toy!.manufacturer
              : _manufacturerOptions.first);

    _features = toy?.features ?? [];
    _isInteractive = toy?.isInteractive ?? false;
    _isChewResistant = toy?.isChewResistant ?? false;

    _featuresController.text = _features.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
        id: widget.toy?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        petType: _selectedPetType,
        size: _selectedSize,
        material: _selectedMaterial,
        safetyFeatures: _safetyFeaturesController.text,
        features: features,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        brand: _brandController.text,
        manufacturer: _selectedManufacturer == 'Other'
            ? _manufacturerController.text
            : _selectedManufacturer,
        imageUrl: _imageUrlController.text,
        cleaningInstructions: _cleaningInstructionsController.text,
        warranty: _selectedWarranty,
        isInteractive: _isInteractive,
        isChewResistant: _isChewResistant,
        ageSuitability: _selectedAgeSuitability,
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
    bool showOtherField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : null,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
        if (showOtherField && value == 'Other')
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: _buildTextField(
              controller: _manufacturerController,
              label: 'Specify Manufacturer',
              hint: 'Enter manufacturer name',
              validator: (val) {
                if (value == 'Other' && (val == null || val.isEmpty)) {
                  return 'Please specify manufacturer';
                }
                return null;
              },
            ),
          ),
      ],
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
                        child: _buildDropdownField(
                          label: 'Category *',
                          value: _selectedCategory,
                          items: _categoryOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select category';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Pet Type *',
                          value: _selectedPetType,
                          items: _petTypeOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedPetType = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select pet type';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownField(
                    label: 'Age Suitability *',
                    value: _selectedAgeSuitability,
                    items: _ageSuitabilityOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedAgeSuitability = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select age suitability';
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
                        child: _buildDropdownField(
                          label: 'Size *',
                          value: _selectedSize,
                          items: _sizeOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedSize = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select size';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                          label: 'Material *',
                          value: _selectedMaterial,
                          items: _materialOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedMaterial = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select material';
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
                  _buildDropdownField(
                    label: 'Warranty',
                    value: _selectedWarranty,
                    items: _warrantyOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedWarranty = value!;
                      });
                    },
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
                        child: _buildDropdownField(
                          label: 'Manufacturer *',
                          value: _selectedManufacturer,
                          items: _manufacturerOptions,
                          onChanged: (value) {
                            setState(() {
                              _selectedManufacturer = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select manufacturer';
                            }
                            return null;
                          },
                          showOtherField: true,
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
