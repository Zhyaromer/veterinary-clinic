import 'package:flutter/material.dart';

class PutForAdoptionPage extends StatefulWidget {
  const PutForAdoptionPage({super.key});

  @override
  State<PutForAdoptionPage> createState() => _PutForAdoptionPageState();
}

class _PutForAdoptionPageState extends State<PutForAdoptionPage> {
  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _petAgeController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _specialNeedsController = TextEditingController();

  // Form state
  String? _selectedPetType;
  String? _selectedGender;
  bool _isVaccinated = false;
  bool _isNeuteredSpayed = false;
  bool _hasMedicalIssues = false;
  bool _isHouseTrained = false;
  bool _acceptTerms = false;

  // Error states
  bool _firstNameError = false;
  bool _lastNameError = false;
  bool _emailError = false;
  bool _phoneError = false;
  bool _addressError = false;
  bool _petTypeError = false;
  bool _petAgeError = false;
  bool _reasonError = false;
  bool _termsError = false;

  // Pet type options
  final List<String> _petTypes = [
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Hamster',
    'Guinea Pig',
    'Fish',
    'Turtle',
    'Other',
  ];

  // Gender options
  final List<String> _genders = ['Male', 'Female'];

  // Clear all form fields
  void _clearForm() {
    setState(() {
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
      _petNameController.clear();
      _breedController.clear();
      _petAgeController.clear();
      _reasonController.clear();
      _specialNeedsController.clear();
      _selectedPetType = null;
      _selectedGender = null;
      _isVaccinated = false;
      _isNeuteredSpayed = false;
      _hasMedicalIssues = false;
      _isHouseTrained = false;
      _acceptTerms = false;

      // Clear errors
      _firstNameError = false;
      _lastNameError = false;
      _emailError = false;
      _phoneError = false;
      _addressError = false;
      _petTypeError = false;
      _petAgeError = false;
      _reasonError = false;
      _termsError = false;
    });
  }

  // Validate form
  bool _validateForm() {
    setState(() {
      // Reset errors
      _firstNameError = _firstNameController.text.isEmpty;
      _lastNameError = _lastNameController.text.isEmpty;
      _emailError =
          _emailController.text.isEmpty || !_emailController.text.contains('@');
      _phoneError = _phoneController.text.isEmpty;
      _addressError = _addressController.text.isEmpty;
      _petTypeError = _selectedPetType == null;
      _petAgeError = _petAgeController.text.isEmpty;
      _reasonError = _reasonController.text.isEmpty;
      _termsError = !_acceptTerms;
    });

    return !_firstNameError &&
        !_lastNameError &&
        !_emailError &&
        !_phoneError &&
        !_addressError &&
        !_petTypeError &&
        !_petAgeError &&
        !_reasonError &&
        !_termsError;
  }

  // Submit form
  void _submitForm() {
    if (_validateForm()) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Text('Submission Successful'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Thank you for submitting your pet for adoption.'),
                SizedBox(height: 8),
                Text('Our team will contact you within 24-48 hours.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearForm();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Scroll to first error
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _petAgeController.dispose();
    _reasonController.dispose();
    _petNameController.dispose();
    _breedController.dispose();
    _specialNeedsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rehome your Pet',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4A6FA5),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4A6FA5).withOpacity(0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.pets, color: Color(0xFF4A6FA5), size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find a Loving Home for Your Pet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Help us find the perfect forever home for your pet. All fields are required unless marked optional.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section: Owner Information
            _buildSectionTitle('Owner Information'),
            const SizedBox(height: 12),

            // First & Last Name Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name *',
                    hint: 'Enter first name',
                    error: _firstNameError,
                    errorText: 'First name is required',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name *',
                    hint: 'Enter last name',
                    error: _lastNameError,
                    errorText: 'Last name is required',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Email & Phone Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _emailController,
                    label: 'Email Address *',
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    error: _emailError,
                    errorText: 'Valid email is required',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number *',
                    hint: '(123) 456-7890',
                    keyboardType: TextInputType.phone,
                    error: _phoneError,
                    errorText: 'Phone number is required',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              label: 'Address *',
              hint: 'Enter your full address',
              maxLines: 2,
              error: _addressError,
              errorText: 'Address is required',
            ),

            const SizedBox(height: 32),

            // Section: Pet Information
            _buildSectionTitle('Pet Information'),
            const SizedBox(height: 12),

            // Pet Name & Breed Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _petNameController,
                    label: 'Pet Name (Optional)',
                    hint: 'Enter pet name',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    controller: _breedController,
                    label: 'Breed (Optional)',
                    hint: 'Enter breed',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Pet Type Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet Type *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _petTypeError ? Colors.red : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _petTypeError ? Colors.red : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPetType,
                      hint: const Text('Select pet type'),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down),
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPetType = newValue;
                          _petTypeError = false;
                        });
                      },
                      items: _petTypes.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_petTypeError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Please select a pet type',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Age & Gender Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _petAgeController,
                    label: 'Pet Age *',
                    hint: 'e.g., 2 years, 6 months',
                    keyboardType: TextInputType.text,
                    error: _petAgeError,
                    errorText: 'Age is required',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender (Optional)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            hint: const Text('Select gender'),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue;
                              });
                            },
                            items: _genders.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Health & Behavior Section
            _buildSectionTitle('Health & Behavior'),
            const SizedBox(height: 12),

            // Health Checkboxes
            Column(
              children: [
                _buildCheckbox(
                  value: _isVaccinated,
                  label: 'Pet is vaccinated',
                  onChanged: (value) {
                    setState(() {
                      _isVaccinated = value!;
                    });
                  },
                ),
                _buildCheckbox(
                  value: _isNeuteredSpayed,
                  label: 'Pet is neutered/spayed',
                  onChanged: (value) {
                    setState(() {
                      _isNeuteredSpayed = value!;
                    });
                  },
                ),
                _buildCheckbox(
                  value: _hasMedicalIssues,
                  label: 'Has medical issues',
                  onChanged: (value) {
                    setState(() {
                      _hasMedicalIssues = value!;
                    });
                  },
                ),
                _buildCheckbox(
                  value: _isHouseTrained,
                  label: 'House trained',
                  onChanged: (value) {
                    setState(() {
                      _isHouseTrained = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Special Needs
            _buildTextField(
              controller: _specialNeedsController,
              label: 'Special Needs/Medical Conditions (Optional)',
              hint: 'Describe any special needs or medical conditions',
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            // Section: Reason for Adoption
            _buildSectionTitle('Reason for Adoption'),
            const SizedBox(height: 12),

            // Reason Text Field
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why are you putting your pet up for adoption? *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _reasonError ? Colors.red : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _reasonError ? Colors.red : Colors.grey[300]!,
                      width: 1.5,
                    ),
                  ),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Please explain your situation...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _reasonError = false;
                      });
                    },
                  ),
                ),
                if (_reasonError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Reason is required',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 32),

            // Terms and Conditions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _termsError ? Colors.red : Colors.grey[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'By submitting this form, you agree to the following:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTermBullet(
                          'All information provided is accurate and truthful',
                        ),
                        _buildTermBullet('You are the legal owner of this pet'),
                        _buildTermBullet(
                          'You agree to a home visit by our adoption team',
                        ),
                        _buildTermBullet(
                          'There will be an adoption fee for the new owner',
                        ),
                        _buildTermBullet(
                          'You understand we cannot guarantee adoption',
                        ),
                        _buildTermBullet(
                          'You will cooperate during the adoption process',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value!;
                            _termsError = false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _acceptTerms = !_acceptTerms;
                              _termsError = false;
                            });
                          },
                          child: Text(
                            'I have read and agree to the terms and conditions *',
                            style: TextStyle(
                              fontSize: 14,
                              color: _termsError
                                  ? Colors.red
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_termsError)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'You must accept the terms and conditions',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearForm,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF4A6FA5)),
                    ),
                    child: const Text(
                      'Clear Form',
                      style: TextStyle(
                        color: Color(0xFF4A6FA5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A6FA5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Submit for Adoption',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Footer Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your privacy is important. All information will be kept confidential and used only for adoption purposes.',
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF4A6FA5),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool error = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: error ? Colors.red : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error ? Colors.red : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error ? Colors.red : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: error ? Colors.red : const Color(0xFF4A6FA5),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: maxLines > 1 ? 12 : 0,
            ),
          ),
          onChanged: (value) {
            if (error) {
              setState(() {
                switch (label) {
                  case 'First Name *':
                    _firstNameError = false;
                    break;
                  case 'Last Name *':
                    _lastNameError = false;
                    break;
                  case 'Email Address *':
                    _emailError = false;
                    break;
                  case 'Phone Number *':
                    _phoneError = false;
                    break;
                  case 'Address *':
                    _addressError = false;
                    break;
                  case 'Pet Age *':
                    _petAgeError = false;
                    break;
                }
              });
            }
          },
        ),
        if (error && errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required String label,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildTermBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, color: Colors.grey)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
