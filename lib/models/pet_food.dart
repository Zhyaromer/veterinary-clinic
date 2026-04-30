import 'package:flutter/material.dart';

class PetFood {
  final int id;
  final String name;
  final String description;
  final String category;
  final String petType;
  final String lifeStage;
  final String flavor;
  final String primaryProtein;
  final List<String> ingredients;
  final List<String> keyNutrients;
  final String size;
  final double weight;
  final double price;
  final int stock;
  final String brand;
  final String manufacturer;
  final String imageUrl;
  final String feedingGuidelines;
  final String storageInstructions;
  final String expiryDate;
  final bool isGrainFree;
  final bool isOrganic;
  final bool isPrescriptionRequired;
  final String nutritionalGuarantee;

  PetFood({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.petType,
    required this.lifeStage,
    required this.flavor,
    required this.primaryProtein,
    required this.ingredients,
    required this.keyNutrients,
    required this.size,
    required this.weight,
    required this.price,
    required this.stock,
    required this.brand,
    required this.manufacturer,
    required this.imageUrl,
    required this.feedingGuidelines,
    required this.storageInstructions,
    required this.expiryDate,
    required this.isGrainFree,
    required this.isOrganic,
    required this.isPrescriptionRequired,
    required this.nutritionalGuarantee,
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
      case 'reptile':
        return const Color(0xFF009688);
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
      case 'reptile':
        return Icons.eco;
      default:
        return Icons.restaurant;
    }
  }

  // Calculate price per weight unit
  String getPricePerUnit() {
    if (weight > 0) {
      final pricePerKg = (price / weight) * 1000;
      return '\$${pricePerKg.toStringAsFixed(2)}/kg';
    }
    return '\$${price.toStringAsFixed(2)}';
  }
}

// Sample pet foods data
List<PetFood> petFoods = [
  PetFood(
    id: 1,
    name: "Premium Salmon & Sweet Potato",
    description:
        "High-protein grain-free dog food made with real salmon as the first ingredient. Supports healthy skin, coat, and digestion.",
    category: "Dry Food",
    petType: "Dog",
    lifeStage: "Adult",
    flavor: "Salmon & Sweet Potato",
    primaryProtein: "Salmon",
    ingredients: [
      "Deboned Salmon",
      "Sweet Potatoes",
      "Peas",
      "Chicken Fat",
      "Flaxseed",
      "Salmon Oil",
      "Vitamins & Minerals",
    ],
    keyNutrients: [
      "32% Protein",
      "16% Fat",
      "4% Fiber",
      "Omega-3 & Omega-6 Fatty Acids",
      "Glucosamine & Chondroitin",
    ],
    size: "12 kg",
    weight: 12.0,
    price: 69.99,
    stock: 45,
    brand: "Wellness Core",
    manufacturer: "Wellness Pet Food",
    imageUrl:
        "https://m.media-amazon.com/images/I/911Gu7iqMdL.jpg",
    feedingGuidelines:
        "Adult dogs: 2-3 cups per day based on weight. Adjust for activity level.",
    storageInstructions:
        "Store in a cool, dry place. Use within 6 weeks of opening.",
    expiryDate: "2025-12-31",
    isGrainFree: true,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "AAFCO certified complete nutrition",
  ),
  PetFood(
    id: 2,
    name: "Indoor Cat Chicken Formula",
    description:
        "Specially formulated for indoor cats with controlled calories and hairball control. Supports urinary tract health.",
    category: "Dry Food",
    petType: "Cat",
    lifeStage: "Adult",
    flavor: "Chicken & Rice",
    primaryProtein: "Chicken",
    ingredients: [
      "Chicken Meal",
      "Brown Rice",
      "Corn Gluten Meal",
      "Animal Fat",
      "Natural Flavors",
      "Fish Oil",
      "Fiber",
    ],
    keyNutrients: [
      "30% Protein",
      "12% Fat",
      "8% Fiber",
      "Taurine",
      "Essential Vitamins",
    ],
    size: "7 kg",
    weight: 7.0,
    price: 42.50,
    stock: 75,
    brand: "Royal Canin",
    manufacturer: "Royal Canin",
    imageUrl:
        "https://www.petsense.com/cdn/shop/products/1153000_3000x.jpg?v=1744211585",
    feedingGuidelines:
        "Adult cats: 1/2 to 3/4 cup per day. Provide fresh water at all times.",
    storageInstructions: "Store in original bag in cool, dry location.",
    expiryDate: "2025-10-15",
    isGrainFree: false,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "Complete & balanced nutrition",
  ),
  PetFood(
    id: 3,
    name: "Grain-Free Chicken Wet Food",
    description:
        "High-moisture wet food with real chicken. Perfect for picky eaters or cats needing extra hydration.",
    category: "Wet Food",
    petType: "Cat",
    lifeStage: "All Life Stages",
    flavor: "Chicken Pate",
    primaryProtein: "Chicken",
    ingredients: [
      "Chicken",
      "Chicken Broth",
      "Liver",
      "Fish Oil",
      "Vitamins",
      "Minerals",
    ],
    keyNutrients: [
      "10% Protein",
      "5% Fat",
      "78% Moisture",
      "Taurine",
      "Essential Amino Acids",
    ],
    size: "85g cans (24 pack)",
    weight: 2.04,
    price: 34.99,
    stock: 120,
    brand: "Purina Fancy Feast",
    manufacturer: "Nestlé Purina",
    imageUrl:
        "https://cdn11.bigcommerce.com/s-ucjiusw7rc/images/stencil/1280x1280/products/1144/9443/BHC101_Grain_Free_Wet_Adult_Chicken_FINAL_20200528_02_Mobile_Optimised_Pack_Hero_100g__61821.1731283541.jpg?c=2",
    feedingGuidelines:
        "Feed 2-3 cans per day for average adult cat. Adjust based on weight.",
    storageInstructions: "Refrigerate after opening. Use within 3 days.",
    expiryDate: "2025-08-30",
    isGrainFree: true,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "100% complete nutrition",
  ),
  PetFood(
    id: 4,
    name: "Freeze-Dried Chicken Treats",
    description:
        "Single-ingredient freeze-dried chicken treats. High in protein with no additives or preservatives.",
    category: "Treats",
    petType: "Dog",
    lifeStage: "All Life Stages",
    flavor: "Chicken",
    primaryProtein: "Chicken",
    ingredients: ["Chicken Breast"],
    keyNutrients: ["80% Protein", "8% Fat", "2% Moisture"],
    size: "200g",
    weight: 0.2,
    price: 24.99,
    stock: 90,
    brand: "Stella & Chewy's",
    manufacturer: "Stella & Chewy's",
    imageUrl:
        "https://www.stellaandchewys.com/cdn/shop/files/B07G36J42R.Main.jpg?v=1741902739",
    feedingGuidelines:
        "Use as training reward or meal topper. 1-3 pieces per 5kg body weight.",
    storageInstructions: "Store in cool, dry place. Reseal bag after use.",
    expiryDate: "2026-05-20",
    isGrainFree: true,
    isOrganic: true,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "Natural & minimally processed",
  ),
  PetFood(
    id: 5,
    name: "Senior Joint Care Formula",
    description:
        "Specially formulated for senior dogs with glucosamine and chondroitin for joint support. Easy to digest.",
    category: "Dry Food",
    petType: "Dog",
    lifeStage: "Senior",
    flavor: "Lamb & Brown Rice",
    primaryProtein: "Lamb",
    ingredients: [
      "Lamb Meal",
      "Brown Rice",
      "Oatmeal",
      "Chicken Fat",
      "Flaxseed",
      "Glucosamine",
      "Chondroitin Sulfate",
    ],
    keyNutrients: [
      "26% Protein",
      "12% Fat",
      "6% Fiber",
      "Glucosamine 500mg/kg",
      "Chondroitin 300mg/kg",
    ],
    size: "15 kg",
    weight: 15.0,
    price: 79.99,
    stock: 35,
    brand: "Hill's Science Diet",
    manufacturer: "Hill's Pet Nutrition",
    imageUrl:
        "https://m.media-amazon.com/images/I/71ec081R0eL._AC_UF1000,1000_QL80_.jpg",
    feedingGuidelines:
        "Senior dogs: 2-4 cups daily based on weight and activity level.",
    storageInstructions:
        "Keep in original packaging. Use airtight container after opening.",
    expiryDate: "2025-11-30",
    isGrainFree: false,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "Veterinarian recommended",
  ),
  PetFood(
    id: 6,
    name: "Bird Seed Mix with Fruits",
    description:
        "Premium blend of seeds, nuts, and dried fruits for small to medium birds. Fortified with vitamins.",
    category: "Bird Food",
    petType: "Bird",
    lifeStage: "Adult",
    flavor: "Mixed Fruit & Nut",
    primaryProtein: "Mixed Seeds",
    ingredients: [
      "Sunflower Seeds",
      "Millet",
      "Safflower Seeds",
      "Dried Apple",
      "Dried Papaya",
      "Almonds",
      "Vitamins",
    ],
    keyNutrients: [
      "14% Protein",
      "20% Fat",
      "8% Fiber",
      "Vitamin A",
      "Calcium",
    ],
    size: "2 kg",
    weight: 2.0,
    price: 18.75,
    stock: 60,
    brand: "Kaytee",
    manufacturer: "Kaytee Products",
    imageUrl:
        "https://www.flytesofancy.co.uk/cdn/shop/files/Berry-feast-wild-bird-mix-ingredients.webp?v=1707917308&width=1000",
    feedingGuidelines:
        "Provide 1-2 tablespoons daily. Remove empty shells regularly.",
    storageInstructions: "Store in airtight container. Protect from moisture.",
    expiryDate: "2025-09-15",
    isGrainFree: true,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "Balanced avian nutrition",
  ),
  PetFood(
    id: 7,
    name: "Dental Care Chew Sticks",
    description:
        "Veterinary dental chews that reduce tartar and plaque by up to 80%. Helps maintain fresh breath.",
    category: "Dental Treats",
    petType: "Dog",
    lifeStage: "Adult",
    flavor: "Original",
    primaryProtein: "Wheat & Chicken",
    ingredients: [
      "Wheat Flour",
      "Chicken Meal",
      "Glycerin",
      "Vegetable Oil",
      "Natural Flavor",
      "Sodium Tripolyphosphate",
    ],
    keyNutrients: ["28% Protein", "8% Fat", "4% Fiber", "Dental Enzymes"],
    size: "27 sticks",
    weight: 0.567,
    price: 29.99,
    stock: 110,
    brand: "Greenies",
    manufacturer: "Mars Petcare",
    imageUrl:
        "https://diergigant.nl/cdn/shop/files/knash-dental-chew-stick-kip-tandverzorgende-kauwsnack-6st-2400832.png?v=1765357575",
    feedingGuidelines:
        "One treat per day for dogs over 25 lbs. Not for puppies.",
    storageInstructions: "Store in original package at room temperature.",
    expiryDate: "2026-03-15",
    isGrainFree: false,
    isOrganic: false,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "VOHC accepted for tartar control",
  ),
  PetFood(
    id: 8,
    name: "Rabbit Hay & Herb Mix",
    description:
        "Premium timothy hay with added herbs for small herbivores. Supports dental health and digestion.",
    category: "Small Animal Food",
    petType: "Small Animal",
    lifeStage: "All Life Stages",
    flavor: "Timothy & Herbs",
    primaryProtein: "Hay",
    ingredients: [
      "Timothy Hay",
      "Dandelion Leaves",
      "Chamomile",
      "Peppermint",
      "Calendula",
    ],
    keyNutrients: ["8% Protein", "2% Fat", "32% Fiber", "Calcium", "Vitamin D"],
    size: "900g",
    weight: 0.9,
    price: 12.99,
    stock: 85,
    brand: "Oxbow",
    manufacturer: "Oxbow Animal Health",
    imageUrl:
        "https://cdn.shopify.com/s/files/1/0530/3762/9610/files/Rabbit_eating_a_pile_of_hay_1_1024x1024.png?v=1698831496",
    feedingGuidelines:
        "Unlimited access to hay. Supplement with pellets and fresh vegetables.",
    storageInstructions:
        "Store in dry, ventilated area. Avoid direct sunlight.",
    expiryDate: "2025-07-31",
    isGrainFree: true,
    isOrganic: true,
    isPrescriptionRequired: false,
    nutritionalGuarantee: "Essential hay for small pets",
  ),
];
