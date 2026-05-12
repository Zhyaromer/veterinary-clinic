import 'package:flutter/material.dart';

import '../../models/my_pet.dart';

class AddEditMyPetPage extends StatefulWidget {
  const AddEditMyPetPage({super.key, this.pet});

  final MyPet? pet;

  @override
  State<AddEditMyPetPage> createState() => _AddEditMyPetPageState();
}

class _AddEditMyPetPageState extends State<AddEditMyPetPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  String _selectedType = 'Dog';

  final List<String> _typeOptions = const [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Fish',
    'Other',
  ];

  bool get _isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _ageController = TextEditingController(
      text: widget.pet != null ? widget.pet!.age.toString() : '',
    );

    final initialType = widget.pet?.type;
    if (initialType != null && _typeOptions.contains(initialType)) {
      _selectedType = initialType;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final ageText = _ageController.text.trim();

    if (name.isEmpty || ageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter pet name and age'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final age = int.tryParse(ageText);
    if (age == null || age < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Age must be a valid number'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final pet = MyPet(
      id: widget.pet?.id ?? '',
      name: name,
      age: age,
      type: _selectedType,
    );

    Navigator.pop(context, pet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Pet' : 'Add Pet',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Pet Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _typeOptions
                  .map(
                    (t) => DropdownMenuItem<String>(value: t, child: Text(t)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(
                  _isEditing ? 'Update' : 'Save',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A6FA5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
