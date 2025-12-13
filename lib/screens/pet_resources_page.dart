// screens/pet_resources_page.dart
import 'package:flutter/material.dart';
import 'package:vet_clinic/models/pet_cage.dart';
import 'package:vet_clinic/models/pet_food.dart';
import 'package:vet_clinic/models/pet_toy.dart';
import 'package:vet_clinic/screens/cages_page.dart';
import 'package:vet_clinic/screens/pet_food_page.dart';
import 'pet_toys_page.dart';

class PetResourcesPage extends StatelessWidget {
  const PetResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final resourceCategories = [
      {
        'title': 'Toys & Play',
        'subtitle': 'Interactive and fun toys for all pets',
        'icon': Icons.toys_outlined,
        'color': const Color(0xFFFF9800),
        'count': petToys.length,
        'image':
            'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'page': const PetToysPage(),
      },
      {
        'title': 'Cages & Habitats',
        'subtitle': 'Comfortable homes and enclosures',
        'icon': Icons.home_outlined,
        'color': const Color(0xFF2196F3),
        'count': petCages.length,
        'image':
            'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'page': const CagesPage(),
      },
      {
        'title': 'Food & Treats',
        'subtitle': 'Nutrition and healthy snacks',
        'icon': Icons.restaurant_outlined,
        'color': const Color(0xFF4CAF50),
        'count': petFoods.length,
        'image':
            'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'page': const PetFoodPage(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pet Resources',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4A6FA5),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF5F9FF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Browse Categories',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a category to explore products',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Category Cards Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: resourceCategories.length,
                  itemBuilder: (context, index) {
                    final category = resourceCategories[index];
                    return _buildResourceCard(
                      context: context,
                      title: category['title'] as String,
                      subtitle: category['subtitle'] as String,
                      icon: category['icon'] as IconData,
                      color: category['color'] as Color,
                      count: category['count'] as int,
                      imageUrl: category['image'] as String,
                      page: category['page'] as Widget,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int count,
    required String imageUrl,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        if (page is Container) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title section coming soon!'),
              backgroundColor: color,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      color.withOpacity(0.9),
                      color.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row with Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: color, size: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count items',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Title and Subtitle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),

                    // Browse Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Browse',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward, color: color, size: 12),
                          ],
                        ),
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
}
