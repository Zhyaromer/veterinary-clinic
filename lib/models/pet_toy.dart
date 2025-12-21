// models/pet_toy.dart
import 'package:flutter/material.dart';

class PetToy {
  final int id;
  final String name;
  final String description;
  final String category;
  final String petType;
  final String size;
  final String material;
  final String safetyFeatures;
  final List<String> features;
  final double price;
  final int stock;
  final String brand;
  final String manufacturer;
  final String imageUrl;
  final String cleaningInstructions;
  final String warranty;
  final bool isInteractive;
  final bool isChewResistant;
  final String ageSuitability;

  PetToy({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.petType,
    required this.size,
    required this.material,
    required this.safetyFeatures,
    required this.features,
    required this.price,
    required this.stock,
    required this.brand,
    required this.manufacturer,
    required this.imageUrl,
    required this.cleaningInstructions,
    required this.warranty,
    required this.isInteractive,
    required this.isChewResistant,
    required this.ageSuitability,
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

// Sample pet toys data
List<PetToy> petToys = [
  PetToy(
    id: 1,
    name: "Interactive Puzzle Feeder",
    description:
        "Stimulating puzzle toy that challenges dogs to find hidden treats. Helps prevent boredom and promotes mental stimulation.",
    category: "Puzzle Toy",
    petType: "Dog",
    size: "Medium (15x15 cm)",
    material: "BPA-free plastic, rubber",
    safetyFeatures: "Non-toxic materials, no small parts, rounded edges",
    features: [
      "Adjustable difficulty levels",
      "Removable treat compartments",
      "Dishwasher safe",
      "Slip-resistant base",
      "Suitable for all dog sizes",
    ],
    price: 24.99,
    stock: 45,
    brand: "Pawfect Play",
    manufacturer: "Pet Innovations Inc.",
    imageUrl:
        "https://m.media-amazon.com/images/I/71fKw2h0bZL._AC_UF1000,1000_QL80_.jpg",
    cleaningInstructions:
        "Hand wash with mild soap and water. Air dry completely before use.",
    warranty: "1-year manufacturer warranty",
    isInteractive: true,
    isChewResistant: true,
    ageSuitability: "Puppy to Senior",
  ),
  PetToy(
    id: 2,
    name: "Catnip Kickeroo",
    description:
        "Premium catnip-filled toy that encourages kicking and bunny-like movements. Made with organic catnip for maximum attraction.",
    category: "Kicker Toy",
    petType: "Cat",
    size: "Large (30 cm)",
    material: "Organic cotton, organic catnip",
    safetyFeatures: "No small parts, securely stitched, non-toxic dyes",
    features: [
      "Refillable catnip compartment",
      "Extra-long for better kicking",
      "Machine washable",
      "Multiple textures",
      "Calming effect",
    ],
    price: 18.50,
    stock: 75,
    brand: "Meow Magic",
    manufacturer: "Feline Fun Co.",
    imageUrl:
        "https://cdn.shoplightspeed.com/shops/618184/files/31723518/image.jpg",
    cleaningInstructions: "Machine wash gentle cycle. Tumble dry low.",
    warranty: "6-month warranty",
    isInteractive: true,
    isChewResistant: false,
    ageSuitability: "Kitten to Senior",
  ),
  PetToy(
    id: 3,
    name: "Durable Chew Bone",
    description:
        "Extremely durable chew bone made from natural rubber. Designed for aggressive chewers and lasts 5x longer than regular toys.",
    category: "Chew Toy",
    petType: "Dog",
    size: "Large (25 cm)",
    material: "Natural rubber, nylon",
    safetyFeatures: "Non-toxic, no harmful chemicals, dental cleaning ridges",
    features: [
      "Massages gums and cleans teeth",
      "Floats in water",
      "Treat dispensing option",
      "Multiple texture zones",
      "Scented options available",
    ],
    price: 32.99,
    stock: 30,
    brand: "ChewMaster",
    manufacturer: "Durable Dog Toys Ltd.",
    imageUrl:
        "https://thebetterbone.com/cdn/shop/files/SOFT_CLASSIC_SMALL_b8fa2b0b-a0b5-48de-830d-fd4f10fb6553.jpg?v=1717876117",
    cleaningInstructions:
        "Dishwasher safe top rack only. Can be boiled for sterilization.",
    warranty: "Lifetime guarantee for aggressive chewers",
    isInteractive: false,
    isChewResistant: true,
    ageSuitability: "Adult dogs only",
  ),
  PetToy(
    id: 4,
    name: "Feather Teaser Wand",
    description:
        "Interactive wand toy with replaceable feathers that mimics bird movements. Perfect for indoor exercise and bonding with your cat.",
    category: "Interactive Wand",
    petType: "Cat",
    size: "Adjustable (60-120 cm)",
    material: "Carbon fiber rod, natural feathers",
    safetyFeatures: "Retractable string, breakaway feathers, padded handle",
    features: [
      "Adjustable length",
      "Replaceable feather attachments",
      "Storage hook included",
      "Lightweight design",
      "Engages natural hunting instincts",
    ],
    price: 15.99,
    stock: 90,
    brand: "Whisker Wonder",
    manufacturer: "CatPlay Innovations",
    imageUrl:
        "https://mademoggie.com.au/cdn/shop/files/Cat-Toy-Teaser-Wand-XXL-Fishing-Rod-5.jpg?v=1745313496&width=2000",
    cleaningInstructions:
        "Wipe rod with damp cloth. Feathers not washable - replace when damaged.",
    warranty: "1-year warranty on rod",
    isInteractive: true,
    isChewResistant: false,
    ageSuitability: "All ages",
  ),
  PetToy(
    id: 5,
    name: "Squeaky Plush Squirrel",
    description:
        "Adorable plush squirrel with multiple squeakers and crinkle material. Provides auditory stimulation and satisfies chasing instincts.",
    category: "Plush Toy",
    petType: "Dog",
    size: "Medium (20 cm)",
    material: "Plush exterior, polyester filling",
    safetyFeatures: "Double-stitched seams, no button eyes, hidden squeakers",
    features: [
      "3 squeakers (head, body, tail)",
      "Crinkle material in ears",
      "Rope toy in middle",
      "Machine washable",
      "Floats in water",
    ],
    price: 12.99,
    stock: 120,
    brand: "Playful Paws",
    manufacturer: "Toy Masters Inc.",
    imageUrl:
        "https://images.unsplash.com/photo-1591946614720-90a587da4a36?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    cleaningInstructions: "Machine wash cold, gentle cycle. Air dry.",
    warranty: "No warranty (consumable item)",
    isInteractive: true,
    isChewResistant: false,
    ageSuitability: "Gentle chewers only",
  ),
  PetToy(
    id: 6,
    name: "Bird Foraging Tower",
    description:
        "Multi-level foraging toy that encourages natural foraging behavior. Keeps birds mentally stimulated for hours.",
    category: "Foraging Toy",
    petType: "Bird",
    size: "25x25x40 cm",
    material: "Untreated wood, stainless steel",
    safetyFeatures: "No lead or zinc, smooth edges, secure fastenings",
    features: [
      "4 different foraging compartments",
      "Removable parts for easy cleaning",
      "Adjustable difficulty",
      "Can be mounted or free-standing",
      "Suitable for most bird sizes",
    ],
    price: 39.99,
    stock: 25,
    brand: "Avian Adventures",
    manufacturer: "Bird Enrichment Co.",
    imageUrl:
        "https://cdn11.bigcommerce.com/s-bbbdf/images/stencil/original/products/773/4229/tug_n_slide__03002.1423677502.jpg?c=2",
    cleaningInstructions:
        "Wipe clean with bird-safe disinfectant. Do not submerge in water.",
    warranty: "2-year warranty",
    isInteractive: true,
    isChewResistant: true,
    ageSuitability: "Adult birds",
  ),
  PetToy(
    id: 7,
    name: "Automatic Laser Toy",
    description:
        "Programmable laser toy that moves in random patterns to entertain cats when you're away. Multiple pattern settings for variety.",
    category: "Electronic Toy",
    petType: "Cat",
    size: "Compact (10x10 cm)",
    material: "ABS plastic, laser module",
    safetyFeatures:
        "Auto-shutoff after 15 minutes, Class II laser, tip-over protection",
    features: [
      "5 different movement patterns",
      "Timer settings (15, 30, 60 minutes)",
      "Random interval mode",
      "Wall-mountable",
      "Battery operated (4 AA, not included)",
    ],
    price: 29.99,
    stock: 40,
    brand: "TechCat",
    manufacturer: "Smart Pet Tech",
    imageUrl:
        "https://i5.walmartimages.com/seo/Prociv-Automatic-Cat-Laser-Toys-Interactive-Laser-Cat-Toys-for-Indoor-Cats-Kitty-Dogs-Cat-Laser-Toy-Automatic-White_17fda043-0896-42ed-8460-82368d5d6448.9b70ed3475af42d234b003209bc02873.jpeg?odnHeight=768&odnWidth=768&odnBg=FFFFFF",
    cleaningInstructions: "Wipe with dry cloth only. Do not use liquids.",
    warranty: "1-year warranty",
    isInteractive: true,
    isChewResistant: false,
    ageSuitability: "All ages (supervision recommended)",
  ),
  PetToy(
    id: 8,
    name: "Tug-of-War Rope",
    description:
        "Heavy-duty cotton rope toy perfect for interactive play. Promotes dental health and satisfies chewing needs.",
    category: "Rope Toy",
    petType: "Dog",
    size: "Large (50 cm)",
    material: "100% cotton rope, natural dyes",
    safetyFeatures:
        "No chemical treatments, thick strands to prevent swallowing",
    features: [
      "Multiple knots for different grip points",
      "Floats in water",
      "Can be frozen for teething relief",
      "Hand-woven construction",
      "Biodegradable",
    ],
    price: 14.75,
    stock: 85,
    brand: "Natural Pup",
    manufacturer: "Eco Pet Products",
    imageUrl:
        "https://images.wagwalkingweb.com/media/daily_wag/behavior_guides/why-dogs-like-tug-of-war/hero/Why-Dogs-Like-Tug-Of-War.jpg",
    cleaningInstructions: "Machine washable. Use mild detergent.",
    warranty: "No warranty (consumable item)",
    isInteractive: true,
    isChewResistant: true,
    ageSuitability: "All ages",
  ),
];