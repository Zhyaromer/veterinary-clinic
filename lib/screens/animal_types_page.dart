import 'package:flutter/material.dart';
import 'package:vet_clinic/screens/bird_breeds_page.dart';
import 'package:vet_clinic/screens/dog_breeds_page.dart';
import '../models/animal_breed.dart';
import '../widgets/animal_type_card.dart';
import 'cat_breeds_page.dart';

class AnimalTypesPage extends StatelessWidget {
  const AnimalTypesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final animalTypes = [
      {
        'type': 'cat',
        'name': 'Cats',
        'description':
            'Discover various cat breeds, their characteristics, and care requirements.',
        'icon': Icons.catching_pokemon,
        'color': const Color(0xFFFF9800),
        'count': catBreeds.length,
        'image':
            'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'type': 'dog',
        'name': 'Dogs',
        'description':
            'Explore different dog breeds, sizes, and their ideal living conditions.',
        'icon': Icons.pets,
        'color': const Color(0xFF2196F3),
        'count': dogBreeds.length,
        'image':
            'https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
      {
        'type': 'bird',
        'name': 'Birds',
        'description':
            'Learn about various bird species, their habitats, and care needs.',
        'icon': Icons.air,
        'color': const Color(0xFF4CAF50),
        'count': birdBreeds.length,
        'image':
            'https://images.unsplash.com/photo-1552728089-57bdde30beb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animal Breeds',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4A6FA5),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Select Animal Type',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Browse breeds by animal type',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: animalTypes.length,
                itemBuilder: (context, index) {
                  final type = animalTypes[index];
                  return AnimalTypeCard(
                    name: type['name'] as String,
                    description: type['description'] as String,
                    icon: type['icon'] as IconData,
                    color: type['color'] as Color,
                    count: type['count'] as int,
                    imageUrl: type['image'] as String,
                    onTap: () {
                      if (type['type'] == 'cat') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CatBreedsPage(),
                          ),
                        );
                      } else if (type['type'] == 'dog') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DogBreedsPage(),
                          ),
                        );
                      } else if (type['type'] == 'bird') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BirdBreedsPage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${type['name']} breeds coming soon!',
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
