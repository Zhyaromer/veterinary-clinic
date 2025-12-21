import 'package:flutter/material.dart';
import '../models/appointment.dart';
import 'package:intl/intl.dart';

class _PredefinedPet {
  const _PredefinedPet({
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
  });

  final String name;
  final String type;
  final String breed;
  final String age;
}

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({Key? key}) : super(key: key);

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Focus nodes
  final FocusNode _ownerNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();

  // Form fields
  String _petName = '';
  String _ownerName = '';
  String _phoneNumber = '';
  String _email = '';
  String _petType = 'Dog';
  String _petBreed = 'Golden Retriever';
  String _petAge = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _reason = 'Annual Checkup';
  String _symptoms = '';
  bool _emergency = false;
  String _vetPreference = 'Any Available Veterinarian';
  bool _termsAccepted = false;

  late _PredefinedPet _selectedPet;
  final List<_PredefinedPet> _predefinedPets = const [
    _PredefinedPet(
      name: 'Buddy',
      type: 'Dog',
      breed: 'Golden Retriever',
      age: '3 years',
    ),
    _PredefinedPet(name: 'Luna', type: 'Cat', breed: 'Siamese', age: '2 years'),
    _PredefinedPet(
      name: 'Kiwi',
      type: 'Bird',
      breed: 'Parrot',
      age: '11 months',
    ),
  ];

  final List<String> _reasons = [
    'Annual Checkup',
    'Vaccination',
    'Dental Care',
    'Surgery',
    'Emergency',
    'Skin Issues',
    'Digestive Problems',
    'Behavioral Consultation',
    'Other',
  ];

  final List<String> _vetPreferences = [
    'Any Available Veterinarian',
    'Dr. Sarah Johnson',
    'Dr. Michael Chen',
    'Dr. Emily Parker',
    'Dr. Robert Williams',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPet = _predefinedPets.first;
    _applyPetProfile(_selectedPet, updateState: false);

    _ownerNameController.text = 'Jordan Smith';
    _phoneController.text = '+1 555 123 4567';
    _emailController.text = 'jordan.smith@example.com';
    _ownerName = _ownerNameController.text;
    _phoneNumber = _phoneController.text;
    _email = _emailController.text;
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ownerNameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _applyPetProfile(_PredefinedPet pet, {bool updateState = true}) {
    void assignValues() {
      _selectedPet = pet;
      _petName = pet.name;
      _petType = pet.type;
      _petBreed = pet.breed;
      _petAge = pet.age;
    }

    if (updateState) {
      setState(assignValues);
    } else {
      assignValues();
    }
  }

  Future<void> _selectDateTime() async {
    final now = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 7)),
    );

    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A6FA5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime == null) return;

    setState(() {
      _selectedDate = pickedDate;
      _selectedTime = pickedTime;
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formattedDateTimeLabel({DateTime? date, TimeOfDay? time}) {
    if (date == null || time == null) return 'Tap to select date & time';
    final dateLabel = DateFormat('EEEE, MMMM d, yyyy').format(date);
    return '$dateLabel • ${_formatTime(time)}';
  }

  bool get _isFormValid {
    return _petName.isNotEmpty &&
        _ownerName.isNotEmpty &&
        _phoneNumber.isNotEmpty &&
        _email.isNotEmpty &&
        _petAge.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null &&
        _termsAccepted;
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select date and time'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red[400],
        ),
      );
      return;
    }

    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petName: _petName,
      ownerName: _ownerName,
      phoneNumber: _phoneNumber,
      email: _email,
      petType: _petType,
      petBreed: _petBreed,
      petAge: _petAge,
      appointmentDate: _selectedDate!,
      appointmentTime: _selectedTime!,
      reason: _reason,
      symptoms: _symptoms,
      emergency: _emergency,
      vetPreference: _vetPreference,
      createdAt: DateTime.now(),
    );
    final result = await showDialog<Appointment>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top gradient header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A6FA5), Color(0xFF6B8ED6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Appointment Confirmed',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        _petName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your appointment has been successfully scheduled.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Info card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F7FF),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF4A6FA5).withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            _dialogDetailRow(
                              Icons.calendar_today_outlined,
                              DateFormat(
                                'EEEE, MMM d, yyyy',
                              ).format(_selectedDate!),
                            ),
                            const SizedBox(height: 10),
                            _dialogDetailRow(
                              Icons.access_time_outlined,
                              _formatTime(_selectedTime!),
                            ),
                            const SizedBox(height: 10),
                            _dialogDetailRow(
                              Icons.person_outline,
                              _vetPreference,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Primary action
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(appointment);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A6FA5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'View Appointments',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Secondary hint
                      Text(
                        'A confirmation email has been sent.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
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

    if (result != null && mounted) {
      Navigator.pop(context, result);
    }
  }

  Widget _dialogDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4A6FA5)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Book Appointment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF0F4FF)],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF4A6FA5),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Appointments can be booked up to 7 days in advance. Monday - Friday only.',
                            style: TextStyle(
                              fontSize: 13,
                              color: const Color(0xFF4A6FA5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Pet Information Section
                  _buildSectionHeader('Pet Information'),
                  _buildDropdown(
                    label: 'Select Saved Pet',
                    value: _selectedPet.name,
                    items: _predefinedPets.map((pet) => pet.name).toList(),
                    icon: Icons.pets_outlined,
                    onChanged: (value) {
                      if (value == null) return;
                      final pet = _predefinedPets.firstWhere(
                        (p) => p.name == value,
                      );
                      _applyPetProfile(pet);
                    },
                  ),

                  const SizedBox(height: 24),

                  // Owner Information Section
                  _buildSectionHeader('Owner Information'),
                  _buildTextField(
                    focusNode: _ownerNameFocus,
                    label: 'Owner Name *',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    controller: _ownerNameController,
                    onChanged: (value) {
                      setState(() {
                        _ownerName = value;
                      });
                    },
                    validator: (value) =>
                        value!.trim().isEmpty ? 'Please enter your name' : null,
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    focusNode: _phoneFocus,
                    label: 'Phone Number *',
                    hint: 'Enter your phone number',
                    icon: Icons.phone,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^[0-9+\-\s]{10,}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  _buildTextField(
                    focusNode: _emailFocus,
                    label: 'Email Address *',
                    hint: 'Enter your email address',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Appointment Details Section
                  _buildSectionHeader('Appointment Details'),

                  // Combined Date & Time Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appointment Date & Time *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDateTime,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  _selectedDate == null || _selectedTime == null
                                  ? Colors.grey.shade300
                                  : const Color(0xFF4A6FA5),
                              width:
                                  _selectedDate == null || _selectedTime == null
                                  ? 1
                                  : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade100,
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.event_available,
                                color:
                                    _selectedDate == null ||
                                        _selectedTime == null
                                    ? Colors.grey.shade500
                                    : const Color(0xFF4A6FA5),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _formattedDateTimeLabel(
                                    date: _selectedDate,
                                    time: _selectedTime,
                                  ),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _selectedDate == null ||
                                            _selectedTime == null
                                        ? Colors.grey.shade500
                                        : Colors.black87,
                                    fontWeight:
                                        _selectedDate == null ||
                                            _selectedTime == null
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color:
                                    _selectedDate == null ||
                                        _selectedTime == null
                                    ? Colors.grey.shade500
                                    : const Color(0xFF4A6FA5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Available: Next 7 days (Monday - Friday only). Clinic hours: 8:00 AM - 8:00 PM.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildDropdown(
                    label: 'Reason for Visit *',
                    value: _reason,
                    items: _reasons,
                    icon: Icons.medical_services_outlined,
                    onChanged: (value) => setState(() => _reason = value!),
                  ),

                  const SizedBox(height: 16),

                  // Symptoms
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symptoms / Notes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Describe any symptoms or notes (optional)',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF4A6FA5),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) => _symptoms = value,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Preferred Veterinarian',
                    value: _vetPreference,
                    items: _vetPreferences,
                    icon: Icons.badge_outlined,
                    onChanged: (value) =>
                        setState(() => _vetPreference = value!),
                  ),

                  const SizedBox(height: 16),

                  // Emergency Switch
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _emergency
                                ? Colors.red.shade50
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.warning_amber_outlined,
                            color: _emergency
                                ? Colors.red.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Emergency Appointment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _emergency
                                      ? Colors.red.shade600
                                      : Colors.black87,
                                ),
                              ),
                              Text(
                                'Check if this requires immediate attention',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _emergency,
                          activeColor: Colors.red,
                          activeTrackColor: Colors.red.shade200,
                          onChanged: (value) =>
                              setState(() => _emergency = value),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms and Conditions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _termsAccepted
                            ? const Color(0xFF4A6FA5)
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (value) =>
                              setState(() => _termsAccepted = value ?? false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: const Color(0xFF4A6FA5),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Terms & Conditions *',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'I agree to the appointment terms, cancellation policy (24 hours notice required), and understand that a fee may apply for no-shows.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Terms & Conditions'),
                                      content: SingleChildScrollView(
                                        child: Text(
                                          '1. Appointment Cancellation: Please cancel at least 24 hours in advance.\n\n'
                                          '2. No-show Policy: Missed appointments may incur a fee.\n\n'
                                          '3. Emergency Cases: Will be prioritized as needed.\n\n'
                                          '4. Payment: Payment is due at time of service.\n\n'
                                          '5. Pet Safety: Please ensure your pet is properly restrained.',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'View full terms and conditions',
                                  style: TextStyle(
                                    color: const Color(0xFF4A6FA5),
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button (greyed out until terms accepted)
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isFormValid ? _submitForm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? const Color(0xFF4A6FA5)
                            : Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: _isFormValid ? 2 : 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month_outlined, size: 22),
                          SizedBox(width: 10),
                          Text(
                            'Book Appointment',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Please fill all required fields (*) and accept terms',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF4A6FA5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required ValueChanged<String> onChanged,
    TextEditingController? controller,
    String? initialValue,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextFormField(
            focusNode: focusNode,
            controller: controller,
            initialValue: controller == null ? initialValue : null,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4A6FA5),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade400, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red.shade400, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF4A6FA5)),
              errorStyle: TextStyle(color: Colors.red.shade400, fontSize: 12),
            ),
            keyboardType: keyboardType,
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4A6FA5),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              prefixIcon: Icon(icon, color: const Color(0xFF4A6FA5)),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A6FA5)),
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(color: Colors.black87),
            dropdownColor: Colors.white,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
