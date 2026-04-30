// models/pet_cage.dart
import 'package:flutter/material.dart';

class PetCage {
  final int id;
  final String name;
  final String description;
  final String category;
  final String petType;
  final String dimensions;
  final String material;
  final String weight;
  final String assemblyRequired;
  final List<String> features;
  final double price;
  final int stock;
  final String brand;
  final String manufacturer;
  final String imageUrl;
  final String cleaningInstructions;
  final String warranty;
  final bool isPortable;
  final bool hasWheels;
  final String includedAccessories;

  PetCage({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.petType,
    required this.dimensions,
    required this.material,
    required this.weight,
    required this.assemblyRequired,
    required this.features,
    required this.price,
    required this.stock,
    required this.brand,
    required this.manufacturer,
    required this.imageUrl,
    required this.cleaningInstructions,
    required this.warranty,
    required this.isPortable,
    required this.hasWheels,
    required this.includedAccessories,
  });

  // Get color based on pet type
  Color getPetTypeColor() {
    switch (petType.toLowerCase()) {
      case 'dog':
        return const Color(0xFF2196F3);
      case 'cat':
        return const Color(0xFFFF9800);
      case 'bird':
        return const Color(0xFF4CAF50);
      case 'small animal':
        return const Color(0xFF9C27B0);
      case 'all pets':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF607D8B);
    }
  }

  // Get icon based on pet type
  IconData getPetTypeIcon() {
    switch (petType.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.catching_pokemon;
      case 'bird':
        return Icons.air;
      case 'small animal':
        return Icons.mouse;
      default:
        return Icons.pets;
    }
  }
}

// Sample pet cages data
List<PetCage> petCages = [
  PetCage(
    id: 1,
    name: "Deluxe Metal Dog Crate",
    description:
        "Heavy-duty metal crate with double doors and divider panel. Perfect for crate training and safe transportation.",
    category: "Dog Crate",
    petType: "Dog",
    dimensions: "36\"L x 24\"W x 27\"H",
    material: "Powder-coated steel, plastic tray",
    weight: "28 lbs",
    assemblyRequired: "Minimal assembly required",
    features: [
      "Double door design",
      "Removable divider panel",
      "Foldable for storage",
      "Slide-out plastic tray",
      "Secure latch system",
    ],
    price: 89.99,
    stock: 25,
    brand: "PetSafe",
    manufacturer: "Pet Habitat Solutions",
    imageUrl:
        "https://cdn.shopify.com/s/files/1/0025/8467/4417/files/LL-DCB-S24-lords-and-labradors-black-crate-only-front-open-lifestyle.jpg",
    cleaningInstructions: "Wipe with damp cloth. Tray is dishwasher safe.",
    warranty: "1-year manufacturer warranty",
    isPortable: true,
    hasWheels: false,
    includedAccessories: "Divider panel, plastic tray, assembly tools",
  ),
  PetCage(
    id: 2,
    name: "Multi-Level Cat Condo",
    description:
        "Spacious multi-level cat condo with scratching posts, perches, and cozy hideaways. Perfect for indoor cats.",
    category: "Cat Condo",
    petType: "Cat",
    dimensions: "24\"L x 24\"W x 60\"H",
    material: "Carpet, sisal rope, particle board",
    weight: "35 lbs",
    assemblyRequired: "Full assembly required",
    features: [
      "3 levels with platforms",
      "2 sisal scratching posts",
      "Cozy hammock",
      "Multiple hideaway spots",
      "Dangling toy included",
    ],
    price: 129.99,
    stock: 18,
    brand: "Whisker City",
    manufacturer: "Feline Furniture Co.",
    imageUrl:
        "https://i.ebayimg.com/images/g/GGQAAOSwkMZk5wBr/s-l1200.jpg",
    cleaningInstructions: "Vacuum regularly. Spot clean with pet-safe cleaner.",
    warranty: "6-month warranty",
    isPortable: false,
    hasWheels: false,
    includedAccessories: "Assembly tools, dangling toy",
  ),
  PetCage(
    id: 3,
    name: "Flight Bird Cage",
    description:
        "Large flight cage for parrots and medium birds. Features multiple perches and feeding stations.",
    category: "Bird Cage",
    petType: "Bird",
    dimensions: "32\"L x 21\"W x 35\"H",
    material: "Powder-coated iron, stainless steel",
    weight: "42 lbs",
    assemblyRequired: "Some assembly required",
    features: [
      "Removable grate and tray",
      "4 feeding doors",
      "Multiple perch positions",
      "Large front door",
      "Play top with ladder",
    ],
    price: 159.99,
    stock: 12,
    brand: "Prevue Hendryx",
    manufacturer: "Avian Habitats Inc.",
    imageUrl:
        "https://assets.petco.com/petco/image/upload/c_pad,dpr_1.0,f_auto,q_auto,h_636,w_636/c_pad,h_636,w_636/2290929-right-1",
    cleaningInstructions: "Wipe with bird-safe disinfectant. Rinse thoroughly.",
    warranty: "2-year warranty",
    isPortable: true,
    hasWheels: true,
    includedAccessories: "4 perches, 3 food cups, ladder",
  ),
  PetCage(
    id: 4,
    name: "Small Animal Habitat",
    description:
        "Modular habitat for hamsters, gerbils, and other small pets. Expandable with tunnel connections.",
    category: "Small Animal Habitat",
    petType: "Small Animal",
    dimensions: "30\"L x 18\"W x 16\"H",
    material: "Plastic, metal wire",
    weight: "8 lbs",
    assemblyRequired: "Modular assembly",
    features: [
      "Modular design",
      "Tunnel connection points",
      "Deep base for bedding",
      "Multiple access doors",
      "Ventilation panels",
    ],
    price: 49.99,
    stock: 35,
    brand: "Kaytee",
    manufacturer: "Small Pet Solutions",
    imageUrl:
        "https://m.media-amazon.com/images/I/81RVQsAOkBL._AC_UF1000,1000_QL80_.jpg",
    cleaningInstructions:
        "Disassemble and wash with mild soap. Air dry completely.",
    warranty: "1-year warranty",
    isPortable: true,
    hasWheels: false,
    includedAccessories: "Water bottle, food dish, tunnel connector",
  ),
  PetCage(
    id: 5,
    name: "Soft-Sided Travel Carrier",
    description:
        "Lightweight, airline-approved carrier with ventilation panels and storage pockets.",
    category: "Travel Carrier",
    petType: "Cat, Small Dog",
    dimensions: "17\"L x 11\"W x 11\"H",
    material: "Polyester, mesh",
    weight: "3 lbs",
    assemblyRequired: "No assembly required",
    features: [
      "Airline approved",
      "Multiple mesh panels",
      "Storage pockets",
      "Shoulder strap",
      "Removable fleece pad",
    ],
    price: 39.99,
    stock: 50,
    brand: "Sherpa",
    manufacturer: "Travel Pet Products",
    imageUrl:
        "https://petsfit.com/cdn/shop/files/petsfit-expandable-cat-carrier-dog-carrier-airline-approved-soft-sided-portable-pet-travel-gray-blue_1.jpg?v=1747454092&width=640",
    cleaningInstructions: "Machine wash gentle cycle. Air dry.",
    warranty: "Lifetime guarantee",
    isPortable: true,
    hasWheels: false,
    includedAccessories: "Shoulder strap, removable pad",
  ),
  PetCage(
    id: 6,
    name: "Outdoor Dog Kennel",
    description:
        "Weather-resistant outdoor kennel with covered roof and secure latches. Perfect for backyard.",
    category: "Outdoor Kennel",
    petType: "Dog",
    dimensions: "48\"L x 30\"W x 33\"H",
    material: "Galvanized steel, asphalt roof",
    weight: "85 lbs",
    assemblyRequired: "Full assembly required",
    features: [
      "Weather-resistant roof",
      "Raised floor",
      "Secure double latches",
      "Removable waste tray",
      "Side door access",
    ],
    price: 249.99,
    stock: 8,
    brand: "Frisco",
    manufacturer: "Outdoor Pet Housing",
    imageUrl:
        "https://www.flytesofancy.co.uk/cdn/shop/products/Outdoor-dog-kennel-open-22-3.jpg?v=1668628193",
    cleaningInstructions: "Hose down and disinfect. Dry thoroughly.",
    warranty: "3-year warranty",
    isPortable: false,
    hasWheels: false,
    includedAccessories: "Assembly tools, waste tray",
  ),
  PetCage(
    id: 7,
    name: "Multi-Cat Playpen",
    description:
        "Expandable playpen system for multiple cats. Connects to create custom play areas.",
    category: "Playpen",
    petType: "Cat",
    dimensions: "Configurable panels",
    material: "Powder-coated steel, canvas",
    weight: "22 lbs",
    assemblyRequired: "Panel assembly",
    features: [
      "8 configurable panels",
      "Zip-up door",
      "Mesh windows",
      "Sturdy floor mat",
      "Storage bag included",
    ],
    price: 79.99,
    stock: 22,
    brand: "IRIS",
    manufacturer: "Pet Play Systems",
    imageUrl:
        "https://i5.walmartimages.com/seo/Dextrus-4-Tier-Indoor-Cat-Cage-Cat-Enclosure-with-Hammock-Large-Metal-Wire-Cat-Kennel-DIY-Cat-Playpen-Perfect-for-Multi-Cat-Homes_397848a9-34d0-4964-bbdf-d56d7dbfe4af.50f6a35792ce82ad8befb6045930f962.jpeg",
    cleaningInstructions:
        "Wipe panels with damp cloth. Mat is machine washable.",
    warranty: "1-year warranty",
    isPortable: true,
    hasWheels: false,
    includedAccessories: "8 panels, floor mat, storage bag",
  ),
  PetCage(
    id: 8,
    name: "Guinea Pig Manor",
    description:
        "Multi-level habitat specifically designed for guinea pigs with ramps and hideouts.",
    category: "Small Animal Habitat",
    petType: "Small Animal",
    dimensions: "47\"L x 24\"W x 14\"H",
    material: "Coroplast, canvas",
    weight: "12 lbs",
    assemblyRequired: "Some assembly required",
    features: [
      "Two levels connected by ramp",
      "Removable fleece liners",
      "Multiple hideouts",
      "Hay rack included",
      "Easy access doors",
    ],
    price: 69.99,
    stock: 30,
    brand: "Midwest",
    manufacturer: "Small Animal Habitats",
    imageUrl:
        "https://m.media-amazon.com/images/I/61giNVguzOL.jpg",
    cleaningInstructions:
        "Replace fleece liners weekly. Wipe surfaces with pet-safe cleaner.",
    warranty: "1-year warranty",
    isPortable: false,
    hasWheels: false,
    includedAccessories: "Fleece liners, hay rack, ramp",
  ),
];
