import 'package:flutter/material.dart';

class WeightRange {
  final double min;
  final double max;

  const WeightRange({required this.min, required this.max});

  String get formatted => '${min}-${max} kg';
}

class LifespanRange {
  final int min;
  final int max;

  const LifespanRange({required this.min, required this.max});

  String get formatted => '${min}-${max} years';
}

class Origin {
  final String country;
  final String region;

  const Origin({required this.country, required this.region});

  String get formatted => '$region, $country';
}

class AnimalBreed {
  final int id;
  final String animalType;
  final String name;
  final String description;
  final WeightRange weight;
  final LifespanRange lifespan;
  final List<String> colors;
  final Origin origin;
  final String idealHome;
  final String temperament;
  final List<String> characteristics;
  final String imageUrl;

  AnimalBreed({
    required this.id,
    required this.animalType,
    required this.name,
    required this.description,
    required this.weight,
    required this.lifespan,
    required this.colors,
    required this.origin,
    required this.idealHome,
    required this.temperament,
    required this.characteristics,
    required this.imageUrl,
  });

  Color getTypeColor() {
    switch (animalType.toLowerCase()) {
      case 'cat':
        return const Color(0xFFFF9800);
      case 'dog':
        return const Color(0xFF2196F3);
      case 'bird':
        return const Color(0xFF4CAF50);
      case 'rabbit':
        return const Color(0xFF9C27B0);
      case 'small animal':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF607D8B);
    }
  }

  IconData getTypeIcon() {
    switch (animalType.toLowerCase()) {
      case 'cat':
        return Icons.catching_pokemon;
      case 'dog':
        return Icons.pets;
      case 'bird':
        return Icons.air;
      case 'rabbit':
        return Icons.mouse;
      default:
        return Icons.pets;
    }
  }

  String getFormattedWeight() {
    if (weight.min < 0.1) {
      // Convert to grams for small birds
      final minGrams = (weight.min * 1000).toInt();
      final maxGrams = (weight.max * 1000).toInt();
      return '$minGrams-${maxGrams}g';
    } else {
      return weight.formatted;
    }
  }
}

// Sample cat breeds data
List<AnimalBreed> catBreeds = [
  AnimalBreed(
    id: 1,
    animalType: 'cat',
    name: 'Persian',
    description:
        'A long-haired breed of cat characterized by its round face and short muzzle.',
    weight: const WeightRange(min: 3.5, max: 5.5),
    lifespan: const LifespanRange(min: 12, max: 17),
    colors: ['White', 'Black', 'Blue', 'Cream', 'Red', 'Silver', 'Golden'],
    origin: const Origin(country: 'Iran', region: 'Persia'),
    idealHome: 'Indoor living, calm environment, regular grooming needed',
    temperament: 'Calm, gentle, quiet, affectionate',
    characteristics: [
      'Long, thick coat',
      'Round face with short nose',
      'Large, expressive eyes',
      'Stocky body with short legs',
      'Requires daily grooming',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR73vrKgTAIPDvewfxJENo3XptLGFATb5bqkqKxBsCl4Fw6ut5IIeTc0FCn034X9dEKpDvAi0kesFaTzguV7PSnuaXGoOf_SYD2lr92aBg&s=10',
  ),
  AnimalBreed(
    id: 2,
    animalType: 'cat',
    name: 'Siamese',
    description:
        'A short-haired breed known for its striking blue eyes and distinctive color points.',
    weight: const WeightRange(min: 3.0, max: 4.5),
    lifespan: const LifespanRange(min: 15, max: 20),
    colors: ['Seal Point', 'Blue Point', 'Chocolate Point', 'Lilac Point'],
    origin: const Origin(country: 'Thailand', region: 'Siam'),
    idealHome:
        'Interactive environment, social family, indoor with play opportunities',
    temperament: 'Vocal, intelligent, social, affectionate',
    characteristics: [
      'Color points on ears, face, paws, tail',
      'Striking blue almond-shaped eyes',
      'Short, fine coat',
      'Sleek, muscular body',
      'Very vocal and communicative',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqN6OzCzFdjdttXpUXGO-PgOTeg9grX_NRv2o0NOjC9NH1Upj9uETRLRl8WoW-ynpEvp8bd2LYjkx14IwCfgYRHesNpiawER5zAOBZ5Fo&s=10',
  ),
  AnimalBreed(
    id: 3,
    animalType: 'cat',
    name: 'Maine Coon',
    description:
        'One of the largest domesticated cat breeds, known for its intelligence and gentle personality.',
    weight: const WeightRange(min: 5.0, max: 8.0),
    lifespan: const LifespanRange(min: 12, max: 15),
    colors: ['Brown Tabby', 'Black', 'White', 'Blue', 'Red', 'Cream'],
    origin: const Origin(country: 'United States', region: 'Maine'),
    idealHome: 'Spacious home, active family, regular grooming needed',
    temperament: 'Gentle, friendly, intelligent, playful',
    characteristics: [
      'Large size with muscular build',
      'Long, shaggy coat with ruff',
      'Tufted ears and paws',
      'Long, bushy tail',
      'Water-resistant coat',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9HGsgu-cCqVzjgql9_8zmfCFiOwg3jYTXQEBAH31Uc3jz-tKkRhL-JrigOrTo_pU_1qFulMi8n5hjgKyY1BNHtqQ5tbme4YoInWgVhw&s=10',
  ),
  AnimalBreed(
    id: 4,
    animalType: 'cat',
    name: 'Bengal',
    description:
        'A domestic cat breed developed to look like exotic jungle cats with distinctive spotted coat.',
    weight: const WeightRange(min: 4.0, max: 6.0),
    lifespan: const LifespanRange(min: 12, max: 16),
    colors: ['Brown Spotted', 'Snow', 'Silver', 'Charcoal'],
    origin: const Origin(country: 'United States', region: 'California'),
    idealHome:
        'Active environment, cat trees, water features, interactive toys',
    temperament: 'Active, playful, intelligent, water-loving',
    characteristics: [
      'Distinctive spotted or marbled coat',
      'Muscular, athletic build',
      'Glitter effect on coat',
      'Large, expressive eyes',
      'Loves water and climbing',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpt2-MMbTrFWvCJIxi2gPABC65sURDUh-D4IFn5GLAmmhH485jFlAqMKiyagus-Ry_-kdNqtuSC7HqtB1Kiy2MY5WnXebKEtV_aEvw4A&s=10',
  ),
  AnimalBreed(
    id: 5,
    animalType: 'cat',
    name: 'Sphynx',
    description:
        'A breed of cat known for its lack of fur, large ears, and wrinkled skin.',
    weight: const WeightRange(min: 3.5, max: 5.0),
    lifespan: const LifespanRange(min: 8, max: 14),
    colors: ['All colors and patterns'],
    origin: const Origin(country: 'Canada', region: 'Toronto'),
    idealHome:
        'Warm indoor environment, regular bathing needed, sun protection',
    temperament: 'Affectionate, energetic, intelligent, attention-seeking',
    characteristics: [
      'Hairless body with peach-fuzz texture',
      'Large ears and lemon-shaped eyes',
      'Wrinkled skin, especially on face',
      'Warm to the touch',
      'Requires regular bathing',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTJRDEfJesrCQ1sy8-aOGyikRx2I6aGUF25L-lFyBEkTUoCNqljUxgy8NxnkKI3zCn2lfaeh94WogZAUVyZGtoBiY7kX0y339lS63l_EVE&s=10',
  ),
  AnimalBreed(
    id: 6,
    animalType: 'cat',
    name: 'Ragdoll',
    description:
        'A large and muscular semi-longhair cat breed with a docile and placid temperament.',
    weight: const WeightRange(min: 4.5, max: 7.0),
    lifespan: const LifespanRange(min: 12, max: 17),
    colors: ['Seal Point', 'Blue Point', 'Chocolate Point', 'Lilac Point'],
    origin: const Origin(country: 'United States', region: 'California'),
    idealHome: 'Indoor living, calm environment, gentle handling',
    temperament: 'Gentle, calm, affectionate, relaxed',
    characteristics: [
      'Large, muscular body',
      'Semi-long, silky coat',
      'Blue eyes',
      'Color-point pattern',
      'Goes limp when held (Ragdoll trait)',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTkkovaAx62EFdc2bfTVADLCjPy-QdETOtbKXjogRmT-CEHMqWcwh-7u0xVcsCfh3CL6q8rMHU7LPijkpju8WtxrOJ14RrC0mEj86bSYw&s=10',
  ),
  AnimalBreed(
    id: 7,
    animalType: 'cat',
    name: 'British Shorthair',
    description:
        'A sturdy, compact cat with a dense coat, known as the teddy bear of cats.',
    weight: const WeightRange(min: 4.0, max: 8.0),
    lifespan: const LifespanRange(min: 14, max: 20),
    colors: ['Blue', 'White', 'Black', 'Cream', 'Chocolate', 'Lilac'],
    origin: const Origin(country: 'United Kingdom', region: 'Great Britain'),
    idealHome: 'Indoor living, moderate activity, regular brushing',
    temperament: 'Calm, affectionate, dignified, independent',
    characteristics: [
      'Dense, plush coat',
      'Round face with full cheeks',
      'Large, round eyes',
      'Stocky, muscular build',
      'Teddy bear appearance',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx6bPNidnjGEpqmL4-p8F8Te69O9dEDSzlUP3DTWn5ouVrIF6awtjpzig_xlSQs2sU1TQo18azB_vryE2uYVaIFsjtEJJAGMKGVWWtt-k&s=10',
  ),
  AnimalBreed(
    id: 8,
    animalType: 'cat',
    name: 'Scottish Fold',
    description:
        'A breed with distinctive folded ears, giving it an owl-like appearance.',
    weight: const WeightRange(min: 3.0, max: 5.0),
    lifespan: const LifespanRange(min: 11, max: 15),
    colors: ['All colors and patterns'],
    origin: const Origin(country: 'Scotland', region: 'Perthshire'),
    idealHome: 'Indoor living, gentle environment, regular ear cleaning',
    temperament: 'Sweet, calm, affectionate, adaptable',
    characteristics: [
      'Unique folded ears',
      'Round face and eyes',
      'Medium-length coat',
      'Compact body',
      'Owl-like appearance',
    ],
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVXqBJ_PnlVuvtHku_vkcAPUWmMNOSKz3d17U8lcXELtJyW4QLKppB4Fp2O4Jz1GnJpuzyj8WrNhRlvJWggzw72affNgqARc3hIi1EvLI&s=10',
  ),
];

List<AnimalBreed> dogBreeds = [
  AnimalBreed(
    id: 101,
    animalType: 'dog',
    name: 'Golden Retriever',
    description:
        'A friendly, intelligent, and devoted breed known for its golden coat and gentle temperament.',
    weight: const WeightRange(min: 25, max: 34),
    lifespan: const LifespanRange(min: 10, max: 12),
    colors: ['Golden', 'Cream', 'Light Golden', 'Dark Golden'],
    origin: const Origin(country: 'United Kingdom', region: 'Scotland'),
    idealHome:
        'Family home with yard, active lifestyle, regular exercise needed',
    temperament: 'Friendly, intelligent, devoted, gentle, confident',
    characteristics: [
      'Dense, water-repellent coat',
      'Friendly and tolerant attitude',
      'Intelligent and eager to please',
      'Excellent with children',
      'Good for service work',
    ],
    imageUrl:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
  ),
  AnimalBreed(
    id: 102,
    animalType: 'dog',
    name: 'German Shepherd',
    description:
        'A highly intelligent and versatile working dog, often used in police and military roles.',
    weight: const WeightRange(min: 30, max: 40),
    lifespan: const LifespanRange(min: 9, max: 13),
    colors: ['Black and Tan', 'Sable', 'Black', 'White'],
    origin: const Origin(country: 'Germany', region: 'Germany'),
    idealHome:
        'Active family, job-oriented environment, space to work and exercise',
    temperament: 'Courageous, confident, smart, alert, loyal',
    characteristics: [
      'Strong, muscular build',
      'Double coat with undercoat',
      'Highly trainable and intelligent',
      'Protective and loyal',
      'Excellent working dog',
    ],
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/d/d0/German_Shepherd_-_DSC_0346_%2810096362833%29.jpg',
  ),
  AnimalBreed(
    id: 103,
    animalType: 'dog',
    name: 'Labrador Retriever',
    description:
        'A popular family dog known for its friendly nature, intelligence, and versatility.',
    weight: const WeightRange(min: 25, max: 36),
    lifespan: const LifespanRange(min: 10, max: 12),
    colors: ['Yellow', 'Black', 'Chocolate'],
    origin: const Origin(country: 'Canada', region: 'Newfoundland'),
    idealHome: 'Active family, water access, regular exercise and training',
    temperament: 'Friendly, active, outgoing, gentle, intelligent',
    characteristics: [
      'Short, dense, water-resistant coat',
      'Otter-like tail',
      'Strong retrieving instinct',
      'Excellent with families',
      'Eager to please',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4SqXnZ0DYnFQJxFuDPDFixVLsjfnKzR2yM8jBJl7OdXRJpk65lxT_vRjRQHuJkljeigQUG3efqxTK7Mx5ZY2I6r1THc2cvkA2Y4jdhOA&s=10',
  ),
  AnimalBreed(
    id: 104,
    animalType: 'dog',
    name: 'French Bulldog',
    description:
        'A small companion breed known for its bat-like ears and affectionate personality.',
    weight: const WeightRange(min: 9, max: 13),
    lifespan: const LifespanRange(min: 10, max: 12),
    colors: ['Brindle', 'Fawn', 'White', 'Cream', 'Black'],
    origin: const Origin(country: 'France', region: 'France'),
    idealHome:
        'Apartment living, moderate exercise, climate-controlled environment',
    temperament: 'Adaptable, playful, smart, affectionate',
    characteristics: [
      'Bat-like ears',
      'Smooth, short coat',
      'Compact, muscular body',
      'Snorting and snoring common',
      'Low exercise needs',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT37-mA4Iy8s9R1xNq3TsdJrS2ovJji5D48X9MmulS_8KWQMIVetI4BjA37K-GjhRaUCpRyuX8t-VpJ1ugx--cKlZoG9a-D3C96-ZL4rQ&s=10',
  ),
  AnimalBreed(
    id: 105,
    animalType: 'dog',
    name: 'Siberian Husky',
    description:
        'A medium-sized working dog breed known for its thick coat and striking blue or multi-colored eyes.',
    weight: const WeightRange(min: 16, max: 27),
    lifespan: const LifespanRange(min: 12, max: 14),
    colors: [
      'Black and White',
      'Gray and White',
      'Red and White',
      'Pure White',
    ],
    origin: const Origin(country: 'Russia', region: 'Siberia'),
    idealHome:
        'Cold climate, active family, secure yard, regular intense exercise',
    temperament: 'Outgoing, mischievous, alert, friendly, gentle',
    characteristics: [
      'Thick double coat',
      'Blue or multi-colored eyes',
      'Wolf-like appearance',
      'High energy and endurance',
      'Strong prey drive',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhVmmK2HBewyCGsTeIyqPzfi4ZxaXYtGCPiwQ2BCUt8wbBPSNDdy8GN2W3wbR7inGbAboFv7UEf-3R5fTrpiudYbZegilR2bYocUUGmg&s=10',
  ),
  AnimalBreed(
    id: 106,
    animalType: 'dog',
    name: 'Poodle',
    description:
        'An elegant and intelligent breed known for its curly coat and versatility in various sizes.',
    weight: const WeightRange(min: 4, max: 32), // Varies by size
    lifespan: const LifespanRange(min: 12, max: 15),
    colors: ['Black', 'White', 'Apricot', 'Silver', 'Brown'],
    origin: const Origin(country: 'Germany', region: 'Germany'),
    idealHome:
        'Various living situations, regular grooming, mental stimulation needed',
    temperament: 'Active, proud, very smart, trainable',
    characteristics: [
      'Curly, hypoallergenic coat',
      'Available in three sizes',
      'Highly intelligent and trainable',
      'Elegant appearance',
      'Excellent show and working dog',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQer3QJKKQH5yoNV4CLLfZGwGCcMzuGgMsSO6atau2J7f6Tt-eSCleRkmU5oKDO1pQQF646qzD6KvIdLYG3chSQvW3dUBTjWyStYzdPnw&s=10',
  ),
  AnimalBreed(
    id: 107,
    animalType: 'dog',
    name: 'Beagle',
    description:
        'A small hound dog with a great sense of smell and a friendly, curious personality.',
    weight: const WeightRange(min: 9, max: 11),
    lifespan: const LifespanRange(min: 12, max: 15),
    colors: ['Tri-color', 'Lemon and White', 'Red and White'],
    origin: const Origin(country: 'United Kingdom', region: 'England'),
    idealHome: 'Family home, secure yard, regular exercise, scent activities',
    temperament: 'Friendly, curious, merry, determined',
    characteristics: [
      'Excellent sense of smell',
      'Short, easy-care coat',
      'Floppy ears',
      'Vocal (baying howl)',
      'Food motivated',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0XEViJNzXHFaCuk5jR3E8nqkgodo_hkfIDIin8f5LY70WyYFcvJL3nb85xqKW6OBu9rNX65YpYb5nhwEtUi5-saKUMp8YNVxzvpX4aw&s=10',
  ),
  AnimalBreed(
    id: 108,
    animalType: 'dog',
    name: 'Bulldog',
    description:
        'A muscular, heavy-set breed with a distinctive wrinkled face and gentle disposition.',
    weight: const WeightRange(min: 18, max: 23),
    lifespan: const LifespanRange(min: 8, max: 10),
    colors: ['Brindle', 'White', 'Fawn', 'Red', 'Piebald'],
    origin: const Origin(country: 'United Kingdom', region: 'England'),
    idealHome: 'Indoor living, moderate exercise, cool environment',
    temperament: 'Friendly, courageous, calm, dignified',
    characteristics: [
      'Wrinkled face and pushed-in nose',
      'Stocky, muscular build',
      'Short, smooth coat',
      'Snoring and drooling common',
      'Low exercise needs',
    ],
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/1/18/2008-07-28_Dog_at_Frolick_Field.jpg',
  ),
  AnimalBreed(
    id: 109,
    animalType: 'dog',
    name: 'Dachshund',
    description:
        'A small hunting dog with a long body and short legs, known for its courageous nature.',
    weight: const WeightRange(min: 4.5, max: 11),
    lifespan: const LifespanRange(min: 12, max: 16),
    colors: ['Red', 'Black and Tan', 'Chocolate', 'Wild Boar'],
    origin: const Origin(country: 'Germany', region: 'Germany'),
    idealHome:
        'Various living situations, moderate exercise, watch for back issues',
    temperament: 'Clever, lively, courageous, devoted',
    characteristics: [
      'Long body, short legs',
      'Three coat varieties',
      'Strong hunting instinct',
      'Can be stubborn',
      'Prone to back problems',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsOYZAfj_s5uC2nTB6w0DLbFt597MxRnOROLcxJfrTTglIfRFcInEm-4uL1Sqm9kw1Kc68KaSKIEvpSTGQUHqlQzUsT6W5xBQg1y8Z0g&s=10',
  ),
  AnimalBreed(
    id: 110,
    animalType: 'dog',
    name: 'Border Collie',
    description:
        'A highly intelligent, energetic herding dog known for its intense stare and work ethic.',
    weight: const WeightRange(min: 12, max: 20),
    lifespan: const LifespanRange(min: 12, max: 15),
    colors: ['Black and White', 'Red and White', 'Blue Merle', 'Tri-color'],
    origin: const Origin(country: 'United Kingdom', region: 'Scottish Borders'),
    idealHome:
        'Active family, job to do, mental and physical stimulation required',
    temperament: 'Affectionate, energetic, intelligent, alert',
    characteristics: [
      'Intense herding stare',
      'Medium-length double coat',
      'Extremely intelligent',
      'High energy and stamina',
      'Needs mental stimulation',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTao0lDPAkxL143wupWiVGPUcfCNhE1EXeIHHAmcc6zTwKRzMDeHRSB1doBIzoZIbwA7wyYEOcXLqxeRN8WNGzW2T70DAiImhrb4FrcGZw&s=10',
  ),
  AnimalBreed(
    id: 111,
    animalType: 'dog',
    name: 'Shih Tzu',
    description:
        'A small companion breed with a long, flowing coat and affectionate nature.',
    weight: const WeightRange(min: 4, max: 7),
    lifespan: const LifespanRange(min: 10, max: 16),
    colors: ['Gold', 'White', 'Brindle', 'Black', 'Silver'],
    origin: const Origin(country: 'China', region: 'Tibet'),
    idealHome: 'Indoor living, regular grooming, moderate exercise',
    temperament: 'Affectionate, outgoing, alert, friendly',
    characteristics: [
      'Long, flowing double coat',
      'Flat face with large eyes',
      'Alert and confident',
      'Good companion dog',
      'Requires daily grooming',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqWbUmlFAaYK0NtcJjZJO5Wt0hBkkzxbphtdgGyI43Wk_4Ew8YnDAQFmCBXAjsc3qhnTgQeARY-eTeqEfM9n-7IRrdWPBaFnCxZORz-w&s=10',
  ),
  AnimalBreed(
    id: 112,
    animalType: 'dog',
    name: 'Australian Shepherd',
    description:
        'A medium-sized herding dog known for its intelligence, agility, and striking coat patterns.',
    weight: const WeightRange(min: 18, max: 29),
    lifespan: const LifespanRange(min: 13, max: 15),
    colors: ['Blue Merle', 'Red Merle', 'Black', 'Red'],
    origin: const Origin(
      country: 'United States',
      region: 'Western United States',
    ),
    idealHome: 'Active rural or suburban home, job to do, regular exercise',
    temperament: 'Smart, work-oriented, exuberant, good-natured',
    characteristics: [
      'Beautiful merle patterns',
      'Medium-length double coat',
      'Highly intelligent and trainable',
      'Natural herding instinct',
      'High energy and agility',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRnNDoU1BeQDwc3_gylShIMCF-oYRF_KHiNtgPAVbqPKw3XPic3Jkfvfsai01Ndx4KpfbOuhSEK9jd3jyyt45tVgH5jC4szLknnYFYcSA&s=10',
  ),
];

// Add these bird breeds to the existing AnimalBreed model

List<AnimalBreed> birdBreeds = [
  AnimalBreed(
    id: 201,
    animalType: 'bird',
    name: 'Budgerigar (Budgie)',
    description:
        'A small, long-tailed, seed-eating parrot, and the most popular pet bird worldwide.',
    weight: const WeightRange(min: 0.03, max: 0.04),
    lifespan: const LifespanRange(min: 5, max: 8),
    colors: ['Green', 'Blue', 'Yellow', 'White', 'Violet', 'Grey'],
    origin: const Origin(country: 'Australia', region: 'Australia'),
    idealHome:
        'Medium to large cage, toys for stimulation, social environment, daily interaction',
    temperament: 'Playful, social, intelligent, can be trained to talk',
    characteristics: [
      'Small size, about 18cm long',
      'Zebra-like patterns on back and wings',
      'Can learn to mimic words and sounds',
      'Active and playful',
      'Social, do better in pairs',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7f9LyLpME2FmGSbpHgED_o18-uGsthjB-MXIpuyjHRiO9YDSgGtNtLsb60vJyNJ5tbyUQ0nUOB4S6pq4Y58ovgOZdqssYRnDoKJCemxw&s=10',
  ),
  AnimalBreed(
    id: 202,
    animalType: 'bird',
    name: 'Cockatiel',
    description:
        'A small cockatoo endemic to Australia, known for its distinctive crest and cheek patches.',
    weight: const WeightRange(min: 0.08, max: 0.12),
    lifespan: const LifespanRange(min: 15, max: 20),
    colors: ['Grey', 'White', 'Yellow', 'Cinnamon', 'Pearl'],
    origin: const Origin(country: 'Australia', region: 'Australia'),
    idealHome:
        'Large cage, climbing space, toys, social interaction, regular out-of-cage time',
    temperament: 'Gentle, affectionate, curious, intelligent, good whistlers',
    characteristics: [
      'Distinctive crest expresses mood',
      'Orange cheek patches',
      'Can whistle tunes and mimic sounds',
      'Gentle and easy to tame',
      'Enjoy head scratches',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXCl7rdrVbahho31Gbjgg7XcRbqByJG4_vifGgiQwlKhgfZrokwL8ckE2s0Qn07myvvGA-MV4BKtdSj79UtGIgHba0awfhO89xpxhTZwo&s=10',
  ),
  AnimalBreed(
    id: 203,
    animalType: 'bird',
    name: 'African Grey Parrot',
    description:
        'An intelligent parrot species known for its exceptional talking ability and cognitive skills.',
    weight: const WeightRange(min: 0.4, max: 0.65),
    lifespan: const LifespanRange(min: 40, max: 60),
    colors: ['Grey', 'Red Tail'],
    origin: const Origin(country: 'Africa', region: 'Central and West Africa'),
    idealHome:
        'Very large cage, mental stimulation, social interaction, experienced owner',
    temperament: 'Highly intelligent, sensitive, social, excellent mimics',
    characteristics: [
      'Exceptional talking ability',
      'Highly intelligent (like a 5-year-old child)',
      'Requires mental stimulation',
      'Sensitive to environment',
      'Long-lived companion',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcVErJetjCWvnmV_yNEDEibX9A9fXDwKHu4B3hmxVdldBQKlnUIAoHtlzFH7ZXc2hETYjHx2pBjOQXD9xezzrKS4_pVquQJIGMH1cHJQ&s=10',
  ),
  AnimalBreed(
    id: 204,
    animalType: 'bird',
    name: 'Canary',
    description:
        'A small songbird known for its beautiful singing, originally from the Canary Islands.',
    weight: const WeightRange(min: 0.015, max: 0.02),
    lifespan: const LifespanRange(min: 10, max: 15),
    colors: ['Yellow', 'Orange', 'Red', 'White', 'Variegated'],
    origin: const Origin(country: 'Spain', region: 'Canary Islands'),
    idealHome:
        'Medium cage, good ventilation, regular light cycle, peaceful environment',
    temperament: 'Active, good singers, less hands-on than parrots',
    characteristics: [
      'Beautiful singing voice',
      'Brightly colored plumage',
      'Active and lively',
      'Less handling needed',
      'Good for listening enjoyment',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSk54QYDAmCJ8bFmbZVW3dEe9lKPaT-RBUaGN9ryUVV0Sbp93GfMNZzrM9TupMAC2vJaBtpqDcScRUNBGs1SEHdsmDubEKWEz_KbQ5DYA&s=10',
  ),
  AnimalBreed(
    id: 205,
    animalType: 'bird',
    name: 'Lovebird',
    description:
        'A small parrot species known for their affectionate behavior and strong pair bonds.',
    weight: const WeightRange(min: 0.04, max: 0.06),
    lifespan: const LifespanRange(min: 10, max: 15),
    colors: ['Green', 'Blue', 'Peach', 'Yellow', 'White'],
    origin: const Origin(country: 'Africa', region: 'Africa and Madagascar'),
    idealHome: 'Large cage, toys, social interaction, can be kept in pairs',
    temperament: 'Active, playful, affectionate, can be noisy',
    characteristics: [
      'Strong pair bonds',
      'Active and playful',
      'Colorful plumage',
      'Can learn tricks',
      'May bond strongly with one person',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2riYCb3hzUV4OpjufXXR7-126oRIwJbNnp8ZalTDjQT-Fg7fFJFqT-1bXLZX42XsjZ3XBgQ3-Y-TySqOwCJLopM_ARAHeilISiSVyIwo&s=10',
  ),
  AnimalBreed(
    id: 206,
    animalType: 'bird',
    name: 'Parakeet (Indian Ringneck)',
    description:
        'A medium-sized parrot with a long tail and distinctive ring around its neck.',
    weight: const WeightRange(min: 0.11, max: 0.14),
    lifespan: const LifespanRange(min: 25, max: 30),
    colors: ['Green', 'Blue', 'Yellow', 'White', 'Grey'],
    origin: const Origin(country: 'India', region: 'South Asia'),
    idealHome: 'Large flight cage, toys, training, social interaction',
    temperament: 'Intelligent, good talkers, can be independent',
    characteristics: [
      'Distinctive neck ring (males)',
      'Excellent talking ability',
      'Long tail feathers',
      'Intelligent and trainable',
      'Can be loud',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTy32VRmgxSNG8-gc8nx_VTPy12cF_Qq8ozs8j-xo-lDtz9wGY_AEcXbrl2wFeXojBFdja125WmQEXW5MMKGHBvAePoJ5eXVvOkMXUBUA&s=10',
  ),
  AnimalBreed(
    id: 207,
    animalType: 'bird',
    name: 'Finch',
    description:
        'Small passerine birds known for their beautiful songs and social nature.',
    weight: const WeightRange(min: 0.01, max: 0.02),
    lifespan: const LifespanRange(min: 5, max: 10),
    colors: ['Various colors depending on species'],
    origin: const Origin(country: 'Worldwide', region: 'Various'),
    idealHome: 'Flight cage, kept in pairs or groups, minimal handling',
    temperament: 'Active, social with other finches, not hand-tame',
    characteristics: [
      'Beautiful songs',
      'Active and social',
      'Small and delicate',
      'Best kept in aviaries',
      'Minimal handling required',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzqtFx0zBDCXHvaUN8pVaZTwGgUpOnQr6-LBpoCMNkNOwQSd-4ErIakRa5_2RfCoKW4diKhbj35-yo-smbzBE1mxVingu7nxdy_-Jk8w&s=10',
  ),
  AnimalBreed(
    id: 208,
    animalType: 'bird',
    name: 'Macaw',
    description:
        'Large, colorful parrots native to Central and South America, known for their size and intelligence.',
    weight: const WeightRange(min: 0.9, max: 1.7),
    lifespan: const LifespanRange(min: 50, max: 80),
    colors: ['Red', 'Blue', 'Yellow', 'Green', 'Multi-colored'],
    origin: const Origin(country: 'South America', region: 'Amazon Rainforest'),
    idealHome:
        'Very large cage or aviary, experienced owner, lots of attention and stimulation',
    temperament: 'Intelligent, social, loud, requires lots of attention',
    characteristics: [
      'Very large size',
      'Brilliantly colored plumage',
      'Powerful beak',
      'Long lifespan',
      'Requires experienced care',
    ],
    imageUrl:
        'https://images.ctfassets.net/rt5zmd3ipxai/6lklVlmFtuSvxIpVEl5pFo/97335a5a4d146eead10d4d3e1cea384a/NVa-Parrot-Claw.png?fit=fill&fm=webp&h=578&w=1070&q=72,%20https://images.ctfassets.net/rt5zmd3ipxai/6lklVlmFtuSvxIpVEl5pFo/97335a5a4d146eead10d4d3e1cea384a/NVa-Parrot-Claw.png?fit=fill&fm=webp&h=1156&w=2140&q=72',
  ),
  AnimalBreed(
    id: 209,
    animalType: 'bird',
    name: 'Cockatoo',
    description:
        'A parrot with an erectile crest, known for its affectionate nature and need for attention.',
    weight: const WeightRange(min: 0.3, max: 1.2),
    lifespan: const LifespanRange(min: 40, max: 70),
    colors: ['White', 'Black', 'Pink', 'Grey'],
    origin: const Origin(
      country: 'Australia',
      region: 'Australia and Indonesia',
    ),
    idealHome:
        'Very large cage, constant attention, experienced owner, lots of toys',
    temperament: 'Affectionate, demanding, intelligent, can be loud',
    characteristics: [
      'Prominent crest',
      'Very affectionate',
      'Prone to behavioral issues if bored',
      'Can be very loud',
      'Requires dedicated owner',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJurlqduJtyO8EES7Cppyji83FnumIy-M2yUFa4pThJl0Uafi1LRr2iaxYMP35Z5HWnHC72HaMj6Y1Y28YgXtQ1Ew8CzlDW8HPIcVO0yA&s=10',
  ),
  AnimalBreed(
    id: 210,
    animalType: 'bird',
    name: 'Conure',
    description:
        'A diverse group of small to medium-sized parrots known for their playful personalities.',
    weight: const WeightRange(min: 0.06, max: 0.15),
    lifespan: const LifespanRange(min: 20, max: 30),
    colors: ['Green', 'Sun Conure (orange/yellow)', 'Blue', 'Red'],
    origin: const Origin(
      country: 'South America',
      region: 'Central and South America',
    ),
    idealHome: 'Large cage, toys, social interaction, regular out-of-cage time',
    temperament: 'Playful, affectionate, intelligent, can be noisy',
    characteristics: [
      'Playful and clownish',
      'Colorful plumage',
      'Good at learning tricks',
      'Social and affectionate',
      'Moderate noise level',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvgG0M6QLejWlPXspbVzdiPDOgl3MxZ0N8Vw&s',
  ),
  AnimalBreed(
    id: 211,
    animalType: 'bird',
    name: 'Dove',
    description:
        'Gentle, peaceful birds known for their soft cooing sounds and calm demeanor.',
    weight: const WeightRange(min: 0.12, max: 0.25),
    lifespan: const LifespanRange(min: 10, max: 15),
    colors: ['White', 'Grey', 'Brown', 'Speckled'],
    origin: const Origin(country: 'Worldwide', region: 'Various'),
    idealHome:
        'Large cage or aviary, peaceful environment, pairs do well together',
    temperament: 'Gentle, peaceful, quiet, not typically hand-tame',
    characteristics: [
      'Soft cooing sounds',
      'Gentle and peaceful',
      'Ground foragers',
      'Good for aviaries',
      'Symbol of peace',
    ],
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVqvOrXpZWGUcuwGKIvoNJqHjEBfL8jauFdzX-3G5FLBbsyTgp59qXTAis80kagA-aGGEwqbn0RdpUjtQKgH3XN0tVYiyd5eZlpVR-Fo8&s=10',
  ),
  AnimalBreed(
    id: 212,
    animalType: 'bird',
    name: 'Parrotlet',
    description:
        'The smallest parrot species, with big personalities despite their small size.',
    weight: const WeightRange(min: 0.025, max: 0.035),
    lifespan: const LifespanRange(min: 15, max: 20),
    colors: ['Green', 'Blue', 'Yellow', 'White'],
    origin: const Origin(country: 'South America', region: 'South America'),
    idealHome:
        'Medium cage, toys, social interaction, can be kept singly or in pairs',
    temperament: 'Feisty, intelligent, playful, can be territorial',
    characteristics: [
      'Smallest parrot species',
      'Big personality in small package',
      'Can learn to talk',
      'Active and playful',
      'May bond strongly with owner',
    ],
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/a/a8/Forpus_coelestis_-_male_pet.jpg',
  ),
];
