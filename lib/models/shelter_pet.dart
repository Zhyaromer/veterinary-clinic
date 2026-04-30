import 'package:flutter/material.dart';

class ShelterPet {
  final int id;
  final String name;
  final String type; // Dog, Cat, Bird, Rabbit, etc.
  final String breed;
  final String age;
  final String gender;
  final String size;
  final String color;
  final String location;
  final DateTime arrivalDate;
  final String healthStatus;
  final bool isVaccinated;
  final bool isNeutered;
  final String personality;
  final List<String> specialNeeds;
  final String description;
  final String imageUrl;
  final bool isAdopted;
  final double adoptionFee;
  final int careLevel; // 1-5 stars
  final int activityLevel; // 1-5 stars
  final bool isGoodWithKids;
  final bool isGoodWithPets;
  final List<String> requirements;

  ShelterPet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.gender,
    required this.size,
    required this.color,
    required this.location,
    required this.arrivalDate,
    required this.healthStatus,
    required this.isVaccinated,
    required this.isNeutered,
    required this.personality,
    required this.specialNeeds,
    required this.description,
    required this.imageUrl,
    required this.isAdopted,
    required this.adoptionFee,
    required this.careLevel,
    required this.activityLevel,
    required this.isGoodWithKids,
    required this.isGoodWithPets,
    required this.requirements,
  });

  // Get pet type color
  Color getPetTypeColor() {
    switch (type.toLowerCase()) {
      case 'dog':
        return const Color(0xFF2196F3);
      case 'cat':
        return const Color(0xFFFF9800);
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

  // Get pet type icon
  IconData getPetTypeIcon() {
    switch (type.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.catching_pokemon;
      case 'bird':
        return Icons.air;
      case 'rabbit':
        return Icons.eco;
      case 'small animal':
        return Icons.mouse;
      default:
        return Icons.pets;
    }
  }

  // Calculate days in shelter
  int get daysInShelter {
    final now = DateTime.now();
    return now.difference(arrivalDate).inDays;
  }

  // Get adoption status text
  String get adoptionStatus => isAdopted ? 'Adopted' : 'Available';
  Color get adoptionStatusColor =>
      isAdopted ? Colors.green : const Color(0xFF4A6FA5);

  // Get formatted arrival date
  String get formattedArrivalDate {
    return '${arrivalDate.day}/${arrivalDate.month}/${arrivalDate.year}';
  }

  // Get formatted adoption fee
  String get formattedFee => '\$${adoptionFee.toStringAsFixed(2)}';

  // Get health status color
  Color get healthStatusColor {
    switch (healthStatus.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.blue;
      case 'fair':
        return Colors.orange;
      case 'needs attention':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

// Sample shelter pets data
List<ShelterPet> shelterPets = [
  ShelterPet(
    id: 1,
    name: 'Max',
    type: 'Dog',
    breed: 'Golden Retriever Mix',
    age: '2 years',
    gender: 'Male',
    size: 'Large',
    color: 'Golden',
    location: 'Main Shelter',
    arrivalDate: DateTime.now().subtract(const Duration(days: 45)),
    healthStatus: 'Excellent',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Friendly, Playful, Loyal',
    specialNeeds: ['None'],
    description:
        'Max is a gentle giant who loves everyone he meets. He was found as a stray and has been waiting for his forever home. Great with kids and other dogs.',
    imageUrl:
        'https://images.unsplash.com/photo-1552053831-71594a27632d?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
    isAdopted: false,
    adoptionFee: 250.00,
    careLevel: 3,
    activityLevel: 4,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Fenced yard', 'Active family', 'Regular exercise'],
  ),
  ShelterPet(
    id: 2,
    name: 'Luna',
    type: 'Cat',
    breed: 'Domestic Shorthair',
    age: '3 years',
    gender: 'Female',
    size: 'Medium',
    color: 'Calico',
    location: 'Foster Home',
    arrivalDate: DateTime.now().subtract(const Duration(days: 30)),
    healthStatus: 'Good',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Independent, Affectionate, Curious',
    specialNeeds: ['Special diet'],
    description:
        'Luna is a beautiful calico cat who was surrendered by her previous owners. She enjoys quiet spaces and gentle petting.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSE9aL1hZ0BWzO7QHa6VG5bIdOOVYWfdd3g5Ilm5B04r3ZIHfnaO1ZxnLkdlPXi8HKL1THlmomVc3EjItbagqkITeVU6b50m6mkWSSOA78&s=10',
    isAdopted: false,
    adoptionFee: 150.00,
    careLevel: 2,
    activityLevel: 2,
    isGoodWithKids: false,
    isGoodWithPets: false,
    requirements: ['Indoor only', 'Quiet home', 'Regular vet checkups'],
  ),
  ShelterPet(
    id: 3,
    name: 'Charlie',
    type: 'Dog',
    breed: 'Beagle Mix',
    age: '4 years',
    gender: 'Male',
    size: 'Medium',
    color: 'Tri-color',
    location: 'Main Shelter',
    arrivalDate: DateTime.now().subtract(const Duration(days: 60)),
    healthStatus: 'Fair',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Energetic, Funny, Food-motivated',
    specialNeeds: ['Allergy medication'],
    description:
        'Charlie is a lovable beagle mix with a great sense of humor. He loves long walks and cuddling on the couch.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQd5igTGvxOItB6VXBXW2ToC1TQivYR544sHA&s',
    isAdopted: false,
    adoptionFee: 200.00,
    careLevel: 4,
    activityLevel: 5,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Active lifestyle', 'Secure fencing', 'Training patience'],
  ),
  ShelterPet(
    id: 4,
    name: 'Bella',
    type: 'Cat',
    breed: 'Siamese Mix',
    age: '1 year',
    gender: 'Female',
    size: 'Small',
    color: 'Seal Point',
    location: 'Main Shelter',
    arrivalDate: DateTime.now().subtract(const Duration(days: 15)),
    healthStatus: 'Excellent',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Playful, Vocal, Intelligent',
    specialNeeds: ['None'],
    description:
        'Bella is a stunning young Siamese mix who loves to chat. She\'s very intelligent and enjoys puzzle toys.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqN6OzCzFdjdttXpUXGO-PgOTeg9grX_NRv2o0NOjC9NH1Upj9uETRLRl8WoW-ynpEvp8bd2LYjkx14IwCfgYRHesNpiawER5zAOBZ5Fo&s=10',
    isAdopted: false,
    adoptionFee: 175.00,
    careLevel: 3,
    activityLevel: 4,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Interactive toys', 'Vertical space', 'Attention'],
  ),
  ShelterPet(
    id: 5,
    name: 'Coco',
    type: 'Bird',
    breed: 'African Grey Parrot',
    age: '5 years',
    gender: 'Unknown',
    size: 'Medium',
    color: 'Grey',
    location: 'Special Care Unit',
    arrivalDate: DateTime.now().subtract(const Duration(days: 90)),
    healthStatus: 'Good',
    isVaccinated: true,
    isNeutered: false,
    personality: 'Intelligent, Talkative, Social',
    specialNeeds: ['Special diet', 'Mental stimulation'],
    description:
        'Coco is an incredibly intelligent African Grey who was surrendered due to owner relocation. He knows several words and phrases.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRcVErJetjCWvnmV_yNEDEibX9A9fXDwKHu4B3hmxVdldBQKlnUIAoHtlzFH7ZXc2hETYjHx2pBjOQXD9xezzrKS4_pVquQJIGMH1cHJQ&s=10',
    isAdopted: false,
    adoptionFee: 300.00,
    careLevel: 5,
    activityLevel: 3,
    isGoodWithKids: false,
    isGoodWithPets: false,
    requirements: ['Experience with birds', 'Large cage', 'Daily interaction'],
  ),
  ShelterPet(
    id: 6,
    name: 'Rocky',
    type: 'Rabbit',
    breed: 'Lionhead',
    age: '2 years',
    gender: 'Male',
    size: 'Small',
    color: 'White',
    location: 'Small Animal Room',
    arrivalDate: DateTime.now().subtract(const Duration(days: 25)),
    healthStatus: 'Excellent',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Gentle, Shy, Curious',
    specialNeeds: ['Hay-based diet'],
    description:
        'Rocky is a beautiful Lionhead rabbit with a fluffy mane. He\'s a bit shy but warms up quickly with gentle handling.',
    imageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Lionhead_Rabbit_with_black_nose.jpg/250px-Lionhead_Rabbit_with_black_nose.jpg',
    isAdopted: false,
    adoptionFee: 100.00,
    careLevel: 3,
    activityLevel: 2,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Indoor housing', 'Daily vegetables', 'Regular grooming'],
  ),
  ShelterPet(
    id: 7,
    name: 'Daisy',
    type: 'Dog',
    breed: 'Labrador Retriever',
    age: '6 months',
    gender: 'Female',
    size: 'Large',
    color: 'Yellow',
    location: 'Puppy Room',
    arrivalDate: DateTime.now().subtract(const Duration(days: 10)),
    healthStatus: 'Excellent',
    isVaccinated: true,
    isNeutered: false,
    personality: 'Playful, Smart, Eager to please',
    specialNeeds: ['Puppy training'],
    description:
        'Daisy is a sweet Labrador puppy who was found abandoned. She\'s full of energy and ready for training and adventures.',
    imageUrl:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4SqXnZ0DYnFQJxFuDPDFixVLsjfnKzR2yM8jBJl7OdXRJpk65lxT_vRjRQHuJkljeigQUG3efqxTK7Mx5ZY2I6r1THc2cvkA2Y4jdhOA&s=10',
    isAdopted: false,
    adoptionFee: 350.00,
    careLevel: 4,
    activityLevel: 5,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Puppy classes', 'Time for training', 'Active family'],
  ),
  ShelterPet(
    id: 8,
    name: 'Mittens',
    type: 'Cat',
    breed: 'Maine Coon Mix',
    age: '5 years',
    gender: 'Male',
    size: 'Large',
    color: 'Orange Tabby',
    location: 'Main Shelter',
    arrivalDate: DateTime.now().subtract(const Duration(days: 120)),
    healthStatus: 'Good',
    isVaccinated: true,
    isNeutered: true,
    personality: 'Gentle, Patient, Loving',
    specialNeeds: ['Joint supplements'],
    description:
        'Mittens is a senior gentleman looking for a quiet retirement home. He loves naps in sunny spots and gentle brushing.',
    imageUrl:
        'https://ziggyfamily.com/cdn/shop/articles/maine-coon_2_0f8fe44a-55c2-4f6b-8359-e168a83ce2f8.jpg?v=1748331822&width=1000',
    isAdopted: false,
    adoptionFee: 75.00,
    careLevel: 2,
    activityLevel: 1,
    isGoodWithKids: true,
    isGoodWithPets: true,
    requirements: ['Quiet home', 'Senior cat care', 'Regular vet visits'],
  ),
];
