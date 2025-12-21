import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/cage_management_page.dart';
import 'package:vet_clinic/screens/food_management_page.dart';
import 'package:vet_clinic/screens/toy_management_page.dart';

class ResourcesManagementPage extends StatefulWidget {
  const ResourcesManagementPage({super.key});

  @override
  State<ResourcesManagementPage> createState() =>
      _ResourcesManagementPageState();
}

class _ResourcesManagementPageState extends State<ResourcesManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Pet Resources',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          tabs: const [
            Tab(icon: Icon(Icons.pets, size: 20), text: 'Cages & Habitats'),
            Tab(icon: Icon(Icons.restaurant, size: 20), text: 'Food & Treats'),
            Tab(icon: Icon(Icons.toys, size: 20), text: 'Toys & Accessories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CageManagementPage(),
          const FoodManagementPage(),
          const ToyManagementPage(),
        ],
      ),
    );
  }
}
