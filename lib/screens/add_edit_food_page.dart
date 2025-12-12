import 'package:flutter/material.dart';
import '../models/pet_food.dart';

class AddEditFoodPage extends StatefulWidget {
  final PetFood? food;

  const AddEditFoodPage({super.key, this.food});

  @override
  State<AddEditFoodPage> createState() => _AddEditFoodPageState();
}

class _AddEditFoodPageState extends State<AddEditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _ingredientsController = TextEditingController();
  final _keyNutrientsController = TextEditingController();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _petTypeController;
  late TextEditingController _lifeStageController;
  late TextEditingController _flavorController;
  late TextEditingController _primaryProteinController;
  late TextEditingController _sizeController;
  late TextEditingController _weightController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _brandController;
  late TextEditingController _manufacturerController;
  late TextEditingController _imageUrlController;
  late TextEditingController _feedingGuidelinesController;
  late TextEditingController _storageInstructionsController;
  late TextEditingController _expiryDateController;
  late TextEditingController _nutritionalGuaranteeController;

  late List<String> _ingredients;
  late List<String> _keyNutrients;
  late bool _isGrainFree;
  late bool _isOrganic;
  late bool _isPrescriptionRequired;

  @override
  void initState() {
    super.initState();

    final food = widget.food;

    _nameController = TextEditingController(text: food?.name ?? '');
    _descriptionController = TextEditingController(
      text: food?.description ?? '',
    );
    _categoryController = TextEditingController(text: food?.category ?? '');
    _petTypeController = TextEditingController(text: food?.petType ?? '');
    _lifeStageController = TextEditingController(text: food?.lifeStage ?? '');
    _flavorController = TextEditingController(text: food?.flavor ?? '');
    _primaryProteinController = TextEditingController(
      text: food?.primaryProtein ?? '',
    );
    _sizeController = TextEditingController(text: food?.size ?? '');
    _weightController = TextEditingController(
      text: food?.weight.toString() ?? '',
    );
    _priceController = TextEditingController(
      text: food?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: food?.stock.toString() ?? '',
    );
    _brandController = TextEditingController(text: food?.brand ?? '');
    _manufacturerController = TextEditingController(
      text: food?.manufacturer ?? '',
    );
    _imageUrlController = TextEditingController(text: food?.imageUrl ?? '');
    _feedingGuidelinesController = TextEditingController(
      text: food?.feedingGuidelines ?? '',
    );
    _storageInstructionsController = TextEditingController(
      text: food?.storageInstructions ?? '',
    );
    _expiryDateController = TextEditingController(text: food?.expiryDate ?? '');
    _nutritionalGuaranteeController = TextEditingController(
      text: food?.nutritionalGuarantee ?? '',
    );

    _ingredients = food?.ingredients ?? [];
    _keyNutrients = food?.keyNutrients ?? [];
    _isGrainFree = food?.isGrainFree ?? false;
    _isOrganic = food?.isOrganic ?? false;
    _isPrescriptionRequired = food?.isPrescriptionRequired ?? false;

    _ingredientsController.text = _ingredients.join(', ');
    _keyNutrientsController.text = _keyNutrients.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _petTypeController.dispose();
    _lifeStageController.dispose();
    _flavorController.dispose();
    _primaryProteinController.dispose();
    _sizeController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _brandController.dispose();
    _manufacturerController.dispose();
    _imageUrlController.dispose();
    _feedingGuidelinesController.dispose();
    _storageInstructionsController.dispose();
    _expiryDateController.dispose();
    _nutritionalGuaranteeController.dispose();
    _ingredientsController.dispose();
    _keyNutrientsController.dispose();
    super.dispose();
  }

  void _saveFood() {
    if (_formKey.currentState!.validate()) {
      final ingredients = _ingredientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final keyNutrients = _keyNutrientsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final food = PetFood(
        id: widget.food?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        petType: _petTypeController.text,
        lifeStage: _lifeStageController.text,
        flavor: _flavorController.text,
        primaryProtein: _primaryProteinController.text,
        ingredients: ingredients,
        keyNutrients: keyNutrients,
        size: _sizeController.text,
        weight: double.parse(_weightController.text),
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        brand: _brandController.text,
        manufacturer: _manufacturerController.text,
        imageUrl: _imageUrlController.text,
        feedingGuidelines: _feedingGuidelinesController.text,
        storageInstructions: _storageInstructionsController.text,
        expiryDate: _expiryDateController.text,
        isGrainFree: _isGrainFree,
        isOrganic: _isOrganic,
        isPrescriptionRequired: _isPrescriptionRequired,
        nutritionalGuarantee: _nutritionalGuaranteeController.text,
      );

      Navigator.pop(context, food);
    }
  }

  void _showListDialog({
    required String title,
    required TextEditingController controller,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter items separated by commas',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
    final isEditing = widget.food != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Food' : 'Add New Food',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveFood,
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
                icon: Icons.restaurant,
                color: Colors.orange,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Food Name *',
                    hint: 'Enter food name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter food name';
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
                          hint: 'e.g., Dry Food, Wet Food',
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _flavorController,
                          label: 'Flavor *',
                          hint: 'e.g., Salmon & Sweet Potato',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter flavor';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _lifeStageController,
                          label: 'Life Stage *',
                          hint: 'e.g., Puppy, Adult, Senior',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter life stage';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Nutrition Information
              _buildFormSection(
                title: 'Nutrition Information',
                icon: Icons.food_bank,
                color: Colors.green,
                children: [
                  _buildTextField(
                    controller: _primaryProteinController,
                    label: 'Primary Protein *',
                    hint: 'e.g., Chicken, Salmon, Lamb',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter primary protein';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _showListDialog(
                      title: 'Edit Ingredients',
                      controller: _ingredientsController,
                    ),
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
                                  'Ingredients (comma separated)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _ingredientsController.text.isEmpty
                                      ? 'Tap to edit ingredients'
                                      : _ingredientsController.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _ingredientsController.text.isEmpty
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
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () => _showListDialog(
                      title: 'Edit Key Nutrients',
                      controller: _keyNutrientsController,
                    ),
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
                                  'Key Nutrients (comma separated)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _keyNutrientsController.text.isEmpty
                                      ? 'Tap to edit key nutrients'
                                      : _keyNutrientsController.text,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _keyNutrientsController.text.isEmpty
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
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nutritionalGuaranteeController,
                    label: 'Nutritional Guarantee',
                    hint: 'e.g., AAFCO certified complete nutrition',
                    maxLines: 2,
                  ),
                ],
              ),

              // Special Features
              _buildFormSection(
                title: 'Special Features',
                icon: Icons.star,
                color: Colors.purple,
                children: [
                  CheckboxListTile(
                    title: const Text('Grain-Free'),
                    value: _isGrainFree,
                    onChanged: (value) {
                      setState(() {
                        _isGrainFree = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Organic'),
                    value: _isOrganic,
                    onChanged: (value) {
                      setState(() {
                        _isOrganic = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  CheckboxListTile(
                    title: const Text('Prescription Required'),
                    value: _isPrescriptionRequired,
                    onChanged: (value) {
                      setState(() {
                        _isPrescriptionRequired = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),

              // Size & Weight
              _buildFormSection(
                title: 'Size & Weight',
                icon: Icons.aspect_ratio,
                color: Colors.blue,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _sizeController,
                          label: 'Size *',
                          hint: 'e.g., 12 kg, 85g cans (24 pack)',
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
                          controller: _weightController,
                          label: 'Weight (kg) *',
                          hint: '0.00',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            if (double.tryParse(value) == null) {
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

              // Price & Stock
              _buildFormSection(
                title: 'Price & Stock',
                icon: Icons.attach_money,
                color: Colors.teal,
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
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _expiryDateController,
                          label: 'Expiry Date *',
                          hint: 'YYYY-MM-DD',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            final regExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!regExp.hasMatch(value)) {
                              return 'Please use YYYY-MM-DD format';
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

              // Usage & Storage
              _buildFormSection(
                title: 'Usage & Storage',
                icon: Icons.storage,
                color: Colors.brown,
                children: [
                  _buildTextField(
                    controller: _feedingGuidelinesController,
                    label: 'Feeding Guidelines *',
                    hint: 'Enter feeding guidelines',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter feeding guidelines';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _storageInstructionsController,
                    label: 'Storage Instructions *',
                    hint: 'Enter storage instructions',
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter storage instructions';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Manufacturer Information
              _buildFormSection(
                title: 'Manufacturer Information',
                icon: Icons.business,
                color: Colors.indigo,
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
                ],
              ),

              // Action Buttons
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FA5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update Food' : 'Add Food',
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
