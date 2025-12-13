import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/appointments_screen.dart';
import 'package:vet_clinic/screens/contact_us.dart';
import 'package:vet_clinic/screens/medicine_management_page.dart';
import 'package:vet_clinic/screens/medicines_page.dart';
import 'package:vet_clinic/screens/Putting_pets_for_adoption.dart';
import 'package:vet_clinic/screens/pet_guide_page.dart';
import 'package:vet_clinic/screens/pet_resources_page.dart';
import 'package:vet_clinic/screens/resources_management_page.dart';
import 'package:vet_clinic/screens/animal_types_page.dart';
import 'package:vet_clinic/screens/sales_report_screen.dart';

void main() {
  runApp(const VeterinaryClinicApp());
}

class VeterinaryClinicApp extends StatelessWidget {
  const VeterinaryClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetCare Center',
      theme: ThemeData(
        primaryColor: const Color(0xFF4A6FA5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6FA5),
          primary: const Color(0xFF4A6FA5),
          secondary: const Color(0xFF6B9F8C),
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<ServiceItem> _services = [
    ServiceItem(
      Icons.medication_liquid,
      'Medicines',
      const Color(0xFFE3F2FD),
      const Color(0xFF1976D2),
      const Color(0xFF2196F3),
    ),
    ServiceItem(
      Icons.pets,
      'Adoption',
      const Color(0xFFE8F5E9),
      const Color(0xFF388E3C),
      const Color(0xFF4CAF50),
    ),
    ServiceItem(
      Icons.library_books,
      'Pet Resources',
      const Color(0xFFFFF3E0),
      const Color(0xFFF57C00),
      const Color(0xFFFF9800),
    ),
    ServiceItem(
      Icons.family_restroom,
      'Raising a Pet',
      const Color(0xFFF3E5F5),
      const Color(0xFF7B1FA2),
      const Color(0xFF9C27B0),
    ),
    ServiceItem(
      Icons.category,
      'Animal Breeds',
      const Color(0xFFFFEBEE),
      const Color(0xFFD32F2F),
      const Color(0xFFF44336),
    ),
    ServiceItem(
      Icons.favorite_border,
      'Put for Adoption',
      const Color(0xFFFCE4EC),
      const Color(0xFFC2185B),
      const Color(0xFFE91E63),
    ),
    ServiceItem(
      Icons.analytics,
      'Sales Report',
      const Color(0xFFE0F2F1),
      const Color(0xFF00796B),
      const Color(0xFF009688),
    ),
    ServiceItem(
      Icons.medication,
      'Manage Medicines',
      const Color(0xFFEDE7F6),
      const Color(0xFF512DA8),
      const Color(0xFF673AB7),
    ),
    ServiceItem(
      Icons.pets,
      'Manage Animals',
      const Color(0xFFEFEBE9),
      const Color(0xFF5D4037),
      const Color(0xFF795548),
    ),
    ServiceItem(
      Icons.inventory,
      'Manage Resources',
      const Color(0xFFE0F7FA),
      const Color(0xFF0097A7),
      const Color(0xFF00BCD4),
    ),
    ServiceItem(
      Icons.contact_support,
      'Contact Us',
      const Color(0xFFFBE9E7),
      const Color(0xFFBF360C),
      const Color(0xFFFF5722),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '🐾 VetCare Center',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : AppointmentsScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF4A6FA5),
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            showUnselectedLabels: true,
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 0
                        ? const Color(0xFF4A6FA5).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                    size: 24,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? const Color(0xFF4A6FA5).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _selectedIndex == 1
                        ? Icons.app_registration_outlined
                        : Icons.app_registration_outlined,
                    size: 24,
                  ),
                ),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 1
                        ? const Color(0xFF4A6FA5).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _selectedIndex == 1
                        ? Icons.shopping_cart
                        : Icons.shopping_cart,
                    size: 24,
                  ),
                ),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _selectedIndex == 2
                        ? const Color(0xFF4A6FA5).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _selectedIndex == 2
                        ? Icons.settings
                        : Icons.settings_outlined,
                    size: 24,
                  ),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.grid_view, color: Color(0xFF4A6FA5), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Our Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap on any service to explore',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 25),

                // Services Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: _services.length,
                    itemBuilder: (context, index) {
                      return _buildServiceCard(_services[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(ServiceItem service) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _getPage(service.title)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: service.bgColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0.5,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: service.bgColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [service.bgColor, service.bgColor.withOpacity(0.8)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: service.iconColor.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(service.icon, color: service.iconColor, size: 75),
            ),
            const SizedBox(height: 25),

            // Service Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                service.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: service.titleColor,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPage(String title) {
    switch (title) {
      case 'Medicines':
        return MedicinesPage();
      case 'Adoption':
        return MedicinesPage();
      case 'Pet Resources':
        return PetResourcesPage();
      case 'Raising a Pet':
        return PetGuidePage();
      case 'Animal Breeds':
        return AnimalTypesPage();
      case 'Put for Adoption':
        return PutForAdoptionPage();
      case 'Sales Report':
        return SalesReportScreen();
      case 'Manage Medicines':
        return MedicineManagementPage();
      case 'Manage Animals':
        return MedicinesPage();
      case 'Manage Resources':
        return ResourcesManagementPage();
      case 'Contact Us':
        return ContactUsPage();
      default:
        return MedicinesPage();
    }
  }
}

class ServiceItem {
  final IconData icon;
  final String title;
  final Color bgColor;
  final Color iconColor;
  final Color titleColor;

  ServiceItem(
    this.icon,
    this.title,
    this.bgColor,
    this.iconColor,
    this.titleColor,
  );
}
