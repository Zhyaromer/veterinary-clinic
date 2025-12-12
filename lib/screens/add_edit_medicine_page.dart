import 'package:flutter/material.dart';
import '../models/medicine.dart';

class AddEditMedicinePage extends StatefulWidget {
  final Medicine? medicine;

  const AddEditMedicinePage({super.key, this.medicine});

  @override
  State<AddEditMedicinePage> createState() => _AddEditMedicinePageState();
}

class _AddEditMedicinePageState extends State<AddEditMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _indicationsController = TextEditingController();
  final _sideEffectsController = TextEditingController();
  final _interactionsController = TextEditingController();
  final _contraindicationsController = TextEditingController();

  late TextEditingController _nameController;
  late TextEditingController _barcodeController;
  late TextEditingController _batchNumberController;
  late TextEditingController _compositionController;
  late TextEditingController _formController;
  late TextEditingController _routeController;
  late TextEditingController _animalTypeController;
  late TextEditingController _categoryController;
  late TextEditingController _dosageController;
  late TextEditingController _adminInstructionsController;
  late TextEditingController _usageController;
  late TextEditingController _overdoseController;
  late TextEditingController _handlingPrecautionsController;
  late TextEditingController _tempController;
  late TextEditingController _lightProtectionController;
  late TextEditingController _afterOpeningController;
  late TextEditingController _withdrawalPeriodController;
  late TextEditingController _packagingController;
  late TextEditingController _manufacturerNameController;
  late TextEditingController _manufacturerAddressController;
  late TextEditingController _manufacturerPhoneController;
  late TextEditingController _regulatoryNumberController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _expiryDateController;
  late TextEditingController _imageUrlController;

  late List<String> _indications;
  late List<String> _sideEffects;
  late List<String> _interactions;
  late List<String> _contraindications;

  late String _category;
  final List<String> _categories = [
    'Antibiotic',
    'Anti-parasitic',
    'Flea & Tick',
    'Pain Relief',
    'Anti-inflammatory',
    'Heartworm Prevention',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing medicine data or empty
    final medicine = widget.medicine;

    _nameController = TextEditingController(text: medicine?.name ?? '');
    _barcodeController = TextEditingController(text: medicine?.barcode ?? '');
    _batchNumberController = TextEditingController(
      text: medicine?.batchNumber ?? '',
    );
    _compositionController = TextEditingController(
      text: medicine?.composition ?? '',
    );
    _formController = TextEditingController(text: medicine?.form ?? '');
    _routeController = TextEditingController(text: medicine?.route ?? '');
    _animalTypeController = TextEditingController(
      text: medicine?.animalType ?? '',
    );
    _category = medicine?.category ?? _categories.first;
    _dosageController = TextEditingController(text: medicine?.dosage ?? '');
    _adminInstructionsController = TextEditingController(
      text: medicine?.administrationInstructions ?? '',
    );
    _usageController = TextEditingController(text: medicine?.usage ?? '');
    _overdoseController = TextEditingController(text: medicine?.overdose ?? '');
    _handlingPrecautionsController = TextEditingController(
      text: medicine?.handlingPrecautions ?? '',
    );
    _tempController = TextEditingController(
      text: medicine?.storage.temperature ?? '',
    );
    _lightProtectionController = TextEditingController(
      text: medicine?.storage.lightProtection ?? '',
    );
    _afterOpeningController = TextEditingController(
      text: medicine?.storage.afterOpening ?? '',
    );
    _withdrawalPeriodController = TextEditingController(
      text: medicine?.withdrawalPeriod ?? '',
    );
    _packagingController = TextEditingController(
      text: medicine?.packaging ?? '',
    );
    _manufacturerNameController = TextEditingController(
      text: medicine?.manufacturer.name ?? '',
    );
    _manufacturerAddressController = TextEditingController(
      text: medicine?.manufacturer.address ?? '',
    );
    _manufacturerPhoneController = TextEditingController(
      text: medicine?.manufacturer.phone ?? '',
    );
    _regulatoryNumberController = TextEditingController(
      text: medicine?.regulatoryApprovalNumber ?? '',
    );
    _priceController = TextEditingController(
      text: medicine?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: medicine?.stock.toString() ?? '',
    );
    _expiryDateController = TextEditingController(
      text: medicine?.expiryDate ?? '',
    );
    _imageUrlController = TextEditingController(text: medicine?.imageUrl ?? '');

    // Initialize lists
    _indications = medicine?.indications ?? [];
    _sideEffects = medicine?.sideEffects ?? [];
    _interactions = medicine?.interactions ?? [];
    _contraindications = medicine?.contraindications ?? [];

    // Set list text controllers
    _indicationsController.text = _indications.join(', ');
    _sideEffectsController.text = _sideEffects.join(', ');
    _interactionsController.text = _interactions.join(', ');
    _contraindicationsController.text = _contraindications.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _batchNumberController.dispose();
    _compositionController.dispose();
    _formController.dispose();
    _routeController.dispose();
    _animalTypeController.dispose();
    _dosageController.dispose();
    _adminInstructionsController.dispose();
    _usageController.dispose();
    _overdoseController.dispose();
    _handlingPrecautionsController.dispose();
    _tempController.dispose();
    _lightProtectionController.dispose();
    _afterOpeningController.dispose();
    _withdrawalPeriodController.dispose();
    _packagingController.dispose();
    _manufacturerNameController.dispose();
    _manufacturerAddressController.dispose();
    _manufacturerPhoneController.dispose();
    _regulatoryNumberController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _expiryDateController.dispose();
    _imageUrlController.dispose();
    _indicationsController.dispose();
    _sideEffectsController.dispose();
    _interactionsController.dispose();
    _contraindicationsController.dispose();
    super.dispose();
  }

  void _saveMedicine() {
    if (_formKey.currentState!.validate()) {
      // Process lists
      final indications = _indicationsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final sideEffects = _sideEffectsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final interactions = _interactionsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final contraindications = _contraindicationsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // Create or update medicine
      final medicine = Medicine(
        id: widget.medicine?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: _nameController.text,
        barcode: _barcodeController.text,
        batchNumber: _batchNumberController.text,
        composition: _compositionController.text,
        form: _formController.text,
        route: _routeController.text,
        animalType: _animalTypeController.text,
        category: _category,
        indications: indications,
        dosage: _dosageController.text,
        administrationInstructions: _adminInstructionsController.text,
        usage: _usageController.text,
        sideEffects: sideEffects,
        interactions: interactions,
        contraindications: contraindications,
        overdose: _overdoseController.text,
        handlingPrecautions: _handlingPrecautionsController.text,
        storage: MedicineStorage(
          temperature: _tempController.text,
          lightProtection: _lightProtectionController.text,
          afterOpening: _afterOpeningController.text,
        ),
        withdrawalPeriod: _withdrawalPeriodController.text,
        packaging: _packagingController.text,
        manufacturer: Manufacturer(
          name: _manufacturerNameController.text,
          address: _manufacturerAddressController.text,
          phone: _manufacturerPhoneController.text,
        ),
        regulatoryApprovalNumber: _regulatoryNumberController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        expiryDate: _expiryDateController.text,
        imageUrl: _imageUrlController.text,
      );

      Navigator.pop(context, medicine);
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
    final isEditing = widget.medicine != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Medicine' : 'Add New Medicine'),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveMedicine,
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
                icon: Icons.medication_liquid,
                color: Colors.blue,
                children: [
                  _buildTextField(
                    controller: _nameController,
                    label: 'Medicine Name *',
                    hint: 'Enter medicine name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _barcodeController,
                          label: 'Barcode *',
                          hint: 'Enter barcode',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter barcode';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _batchNumberController,
                          label: 'Batch Number *',
                          hint: 'Enter batch number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter batch number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _compositionController,
                    label: 'Composition *',
                    hint: 'Enter composition',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter composition';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Category and Type
              _buildFormSection(
                title: 'Category & Type',
                icon: Icons.category,
                color: Colors.green,
                children: [
                  DropdownButtonFormField<String>(
                    value: _category,
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _formController,
                          label: 'Form *',
                          hint: 'e.g., Tablet, Injection',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter form';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _routeController,
                          label: 'Route *',
                          hint: 'e.g., Oral, SC',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter route';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _animalTypeController,
                    label: 'Animal Type *',
                    hint: 'e.g., Dogs, Cats, All',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter animal type';
                      }
                      return null;
                    },
                  ),
                ],
              ),

              // Lists Section
              _buildFormSection(
                title: 'Lists (Comma Separated)',
                icon: Icons.list,
                color: Colors.purple,
                children: [
                  _buildListField(
                    controller: _indicationsController,
                    label: 'Indications',
                    onTap: () => _showListDialog(
                      title: 'Edit Indications',
                      controller: _indicationsController,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildListField(
                    controller: _sideEffectsController,
                    label: 'Side Effects',
                    onTap: () => _showListDialog(
                      title: 'Edit Side Effects',
                      controller: _sideEffectsController,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildListField(
                    controller: _interactionsController,
                    label: 'Interactions',
                    onTap: () => _showListDialog(
                      title: 'Edit Interactions',
                      controller: _interactionsController,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildListField(
                    controller: _contraindicationsController,
                    label: 'Contraindications',
                    onTap: () => _showListDialog(
                      title: 'Edit Contraindications',
                      controller: _contraindicationsController,
                    ),
                  ),
                ],
              ),

              // Usage Information
              _buildFormSection(
                title: 'Usage Information',
                icon: Icons.info,
                color: Colors.orange,
                children: [
                  _buildTextField(
                    controller: _dosageController,
                    label: 'Dosage *',
                    hint: 'Enter dosage instructions',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter dosage';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _adminInstructionsController,
                    label: 'Administration Instructions *',
                    hint: 'Enter administration instructions',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter administration instructions';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _usageController,
                    label: 'Usage *',
                    hint: 'Enter usage information',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter usage information';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _overdoseController,
                    label: 'Overdose Information',
                    hint: 'Enter overdose information',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _handlingPrecautionsController,
                    label: 'Handling Precautions',
                    hint: 'Enter handling precautions',
                    maxLines: 2,
                  ),
                ],
              ),

              // Storage Information
              _buildFormSection(
                title: 'Storage Information',
                icon: Icons.storage,
                color: Colors.brown,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _tempController,
                          label: 'Temperature',
                          hint: 'e.g., Store below 30°C',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _lightProtectionController,
                          label: 'Light Protection',
                          hint: 'e.g., Protect from light',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _afterOpeningController,
                          label: 'After Opening',
                          hint: 'e.g., Use within 28 days',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _withdrawalPeriodController,
                          label: 'Withdrawal Period',
                          hint: 'e.g., 7 days for meat',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _packagingController,
                    label: 'Packaging',
                    hint: 'e.g., 100 tablets per bottle',
                  ),
                ],
              ),

              // Manufacturer Information
              _buildFormSection(
                title: 'Manufacturer Information',
                icon: Icons.business,
                color: Colors.indigo,
                children: [
                  _buildTextField(
                    controller: _manufacturerNameController,
                    label: 'Manufacturer Name *',
                    hint: 'Enter manufacturer name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter manufacturer name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _manufacturerAddressController,
                    label: 'Address *',
                    hint: 'Enter manufacturer address',
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter manufacturer address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _manufacturerPhoneController,
                          label: 'Phone *',
                          hint: 'Enter manufacturer phone',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter manufacturer phone';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _regulatoryNumberController,
                          label: 'Regulatory Approval Number',
                          hint: 'Enter approval number',
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Pricing and Stock
              _buildFormSection(
                title: 'Pricing & Stock',
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
                            // Simple date validation
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

              // Action Buttons
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveMedicine,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6FA5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEditing ? 'Update Medicine' : 'Add Medicine',
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

  Widget _buildListField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty ? 'Tap to edit' : controller.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
