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
          'Pet Essentials',
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
    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.18),
      child: InkWell(
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
        splashColor: color.withOpacity(0.14),
        highlightColor: Colors.transparent,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.22),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),

            // dual gradient overlay for depth
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.65),
                      Colors.black.withOpacity(0.25),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black54],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconBadge(icon, color),
                      _countBadge('$count items'),
                    ],
                  ),
                  const Spacer(),
                  _titleBlock(title, subtitle),
                  const SizedBox(height: 12),
                  _bottomBar(color),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _countBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.black87,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _titleBlock(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(Icons.arrow_outward_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Open category',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black54,
            size: 14,
          ),
        ],
      ),
    );
  }
}
