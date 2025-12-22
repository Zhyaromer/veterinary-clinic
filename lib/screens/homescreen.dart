import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/appointments_screen.dart';
import 'package:vet_clinic/screens/contact_us.dart';
import 'package:vet_clinic/screens/medicine_management_page.dart';
import 'package:vet_clinic/screens/medicines_page.dart';
import 'package:vet_clinic/screens/Putting_pets_for_adoption.dart';
import 'package:vet_clinic/screens/pet_guide_page.dart';
import 'package:vet_clinic/screens/pet_management_page.dart';
import 'package:vet_clinic/screens/pet_resources_page.dart';
import 'package:vet_clinic/screens/resources_management_page.dart';
import 'package:vet_clinic/screens/animal_types_page.dart';
import 'package:vet_clinic/screens/sales_report_screen.dart';
import 'package:vet_clinic/screens/shelter_pets_screen.dart';
import 'package:vet_clinic/models/cart.dart';
import 'package:vet_clinic/screens/shopping_cart_page.dart';
import 'package:vet_clinic/screens/settings_page.dart';

// Global cart instance
final globalCart = Cart();

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

  final List<QuickAction> _quickActions = [
    QuickAction(
      'Medicines',
      Icons.medication_liquid_rounded,
      const Color(0xFF6366F1),
      'Shop Medicines',
    ),
    QuickAction(
      'Adoption',
      Icons.favorite_rounded,
      const Color(0xFFEC4899),
      'Find Pets',
    ),
    QuickAction(
      'Pet Resources',
      Icons.shopping_bag_rounded,
      const Color(0xFF10B981),
      'Pet Essentials',
    ),
    QuickAction(
      'Raising a Pet',
      Icons.menu_book_rounded,
      const Color(0xFFF59E0B),
      'Learn about Pets',
    ),
  ];

  final List<FeatureCard> _features = [
    FeatureCard(
      'Animal Breeds',
      'Discover different breeds and their characteristics',
      Icons.pets_rounded,
      const Color(0xFF6366F1),
      '25+ Breeds',
      'https://static.vecteezy.com/system/resources/previews/013/589/599/non_2x/a-set-of-round-icons-with-dogs-a-set-of-different-dog-breeds-dog-avatar-icon-collection-isolated-illustration-vector.jpg',
    ),
    FeatureCard(
      'Rehome a Pet',
      'List your pet for adoption and find loving homes',
      Icons.add_circle_rounded,
      const Color(0xFFEC4899),
      'Easy Process',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQebc7hR0lb9pMVaRptTqU0oGdRcV6Q1KO8UA&s',
    ),
    FeatureCard(
      'Sales Report',
      'Track sales and business analytics',
      Icons.trending_up_rounded,
      const Color(0xFF10B981),
      'Live Data',
      'https://cdn3d.iconscout.com/3d/premium/thumb/sales-report-3d-icon-png-download-5283629.png',
    ),
    FeatureCard(
      'My Pets',
      'Manage all your pet profiles in one place',
      Icons.dashboard_rounded,
      const Color(0xFFF59E0B),
      'Organized',
      'https://cdn-icons-png.flaticon.com/512/3460/3460335.png',
    ),
    FeatureCard(
      'Manage Medicines',
      'Update and control medicines inventory',
      Icons.inventory_rounded,
      const Color(0xFF8B5CF6),
      'Stock Control',
      'https://static.vecteezy.com/system/resources/previews/002/062/463/non_2x/medication-management-rgb-color-icon-vector.jpg',
    ),
    FeatureCard(
      'Manage Pet Essentials',
      'Handle all pet care resources efficiently',
      Icons.inventory_2_rounded,
      const Color(0xFF06B6D4),
      'Efficient',
      'https://static.vecteezy.com/system/resources/thumbnails/000/156/189/small/dog-supplies-icon-set-vector.jpg',
    ),
    FeatureCard(
      'Contact Us',
      'Get in touch with our support team anytime',
      Icons.headset_mic_rounded,
      const Color(0xFFF43F5E),
      '24/7 Support',
      'https://cdn-icons-png.flaticon.com/512/7269/7269950.png',
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
        elevation: 10,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShoppingCartPage(),
                  ),
                );
              },
              child: Center(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 28,
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: globalCart.itemCountNotifier,
                      builder: (context, itemCount, child) {
                        return itemCount > 0
                            ? Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$itemCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildHomeContent()
          : _selectedIndex == 1
          ? const AppointmentsScreen()
          : const SettingsPage(),
      bottomNavigationBar: ClipRRect(
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
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
        ),
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Quick Actions Card
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 40,
                  bottom: 16,
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 24,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5B6CED), Color(0xFF9D5EE9)],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Quick Access',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _quickActions.map((action) {
                          return _buildQuickAction(action);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Features Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B6CED), Color(0xFF9D5EE9)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'All Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: _features.length,
                    itemBuilder: (context, index) {
                      return _buildFeatureCard(_features[index]);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(QuickAction action) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _getPage(action.title)),
        );
      },
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [action.color, action.color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: action.color.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(action.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 10),
          Text(
            action.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(FeatureCard feature) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _getPage(feature.title)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: feature.color.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              /// Top gradient background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        feature.color.withOpacity(0.12),
                        feature.color.withOpacity(0.04),
                      ],
                    ),
                  ),
                ),
              ),

              /// Content
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Icon
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              feature.color,
                              feature.color.withOpacity(0.85),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: feature.color.withOpacity(0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          feature.icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        width: double.infinity,
                        height: 230,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(feature.image, fit: BoxFit.fill),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    feature.color.withOpacity(0.25),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            feature.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            feature.subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B),
                              height: 1.4,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: feature.color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: feature.color,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      feature.badge,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: feature.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: feature.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: feature.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getPage(String title) {
    switch (title) {
      case 'Medicines':
        return MedicinesPage();
      case 'Adoption':
        return ShelterPetsScreen();
      case 'Pet Resources':
        return PetResourcesPage();
      case 'Raising a Pet':
        return PetGuidePage();
      case 'Animal Breeds':
        return AnimalTypesPage();
      case 'Rehome a Pet':
        return PutForAdoptionPage();
      case 'Sales Report':
        return SalesReportScreen();
      case 'My Pets':
        return PetManagementPage();
      case 'Manage Medicines':
        return MedicineManagementPage();
      case 'Manage Pet Essentials':
        return ResourcesManagementPage();
      case 'Contact Us':
        return ContactUsPage();
      default:
        return MedicinesPage();
    }
  }
}

class QuickAction {
  final String title;
  final IconData icon;
  final Color color;
  final String label;

  QuickAction(this.title, this.icon, this.color, this.label);
}

class FeatureCard {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String badge;
  final String image;

  FeatureCard(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.badge,
    this.image,
  );
}
