// models/pet_guide.dart
import 'package:flutter/material.dart';

class PetGuide {
  final int id;
  final String name;
  final String scientificName;
  final String category;
  final String lifespan;
  final String adultSize;
  final String imageUrl;
  final String description;
  final List<String> keyPoints;
  final Map<String, String> basicCare;
  final Map<String, List<String>> feeding;
  final Map<String, List<String>> housing;
  final Map<String, List<String>> health;
  final Map<String, List<String>> behavior;
  final List<String> commonMistakes;
  final List<String> additionalTips;

  PetGuide({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.lifespan,
    required this.adultSize,
    required this.imageUrl,
    required this.description,
    required this.keyPoints,
    required this.basicCare,
    required this.feeding,
    required this.housing,
    required this.health,
    required this.behavior,
    required this.commonMistakes,
    required this.additionalTips,
  });

  // Get color based on category
  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'dog':
        return const Color(0xFF2196F3);
      case 'cat':
        return const Color(0xFFFF9800);
      case 'bird':
        return const Color(0xFF4CAF50);
      case 'small mammal':
        return const Color(0xFF9C27B0);
      case 'reptile':
        return const Color(0xFF795548);
      case 'fish':
        return const Color(0xFF00BCD4);
      default:
        return const Color(0xFF607D8B);
    }
  }

  // Get icon based on category
  IconData getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'dog':
        return Icons.pets;
      case 'cat':
        return Icons.catching_pokemon;
      case 'bird':
        return Icons.air;
      case 'small mammal':
        return Icons.mouse;
      case 'reptile':
        return Icons.developer_board;
      case 'fish':
        return Icons.water;
      default:
        return Icons.pets;
    }
  }
}

// Sample pet guides with detailed information
List<PetGuide> petGuides = [
  PetGuide(
    id: 1,
    name: "Golden Retriever",
    scientificName: "Canis lupus familiaris",
    category: "Dog",
    lifespan: "10-12 years",
    adultSize: "25-34 kg",
    imageUrl:
        "https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Golden Retrievers are friendly, intelligent, and devoted family dogs known for their gentle temperament and beautiful golden coats. They are one of the most popular dog breeds worldwide.",
    keyPoints: [
      "Excellent family dogs, great with children",
      "Highly intelligent and easy to train",
      "Require regular exercise (1-2 hours daily)",
      "Prone to certain health conditions (hip dysplasia, cancer)",
      "Moderate to heavy shedding year-round",
    ],
    basicCare: {
      "Exercise": "60-120 minutes daily (walks, play, swimming)",
      "Grooming": "Brush 2-3 times weekly, more during shedding seasons",
      "Training": "Highly trainable, responds well to positive reinforcement",
      "Socialization":
          "Excellent with people and other pets when properly socialized",
      "Space Needs":
          "Best with a yard, but can adapt to apartment living with sufficient exercise",
    },
    feeding: {
      "Diet Type": [
        "High-quality commercial dog food",
        "Raw diet options available",
      ],
      "Daily Amount": [
        "2.5-3.5 cups of dry food (split into 2 meals)",
        "Adjust based on age, weight, and activity level",
      ],
      "Recommended Foods": [
        "Chicken, turkey, fish",
        "Brown rice, sweet potatoes",
        "Carrots, green beans, apples (no seeds)",
      ],
      "Foods to Avoid": [
        "Chocolate, grapes, raisins",
        "Onions, garlic",
        "Xylitol (artificial sweetener)",
        "Cooked bones",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Family home with access to yard",
        "Climate-controlled indoors",
      ],
      "Bedding": [
        "Orthopedic bed recommended for joint health",
        "Regular washing of bedding weekly",
      ],
      "Temperature": [
        "Comfortable in most climates",
        "Provide shade and water in hot weather",
        "Limit outdoor time in extreme cold",
      ],
      "Safety": [
        "Secure fencing (minimum 6 feet)",
        "Remove small objects that could be swallowed",
      ],
    },
    health: {
      "Common Issues": [
        "Hip and elbow dysplasia",
        "Certain cancers (hemangiosarcoma, lymphoma)",
        "Heart conditions (subvalvular aortic stenosis)",
        "Skin allergies and hot spots",
      ],
      "Vaccinations": [
        "Core: Rabies, DHPP (distemper, hepatitis, parvo, parainfluenza)",
        "Optional: Leptospirosis, Bordetella, Lyme disease",
      ],
      "Preventative Care": [
        "Monthly heartworm prevention",
        "Flea and tick prevention",
        "Regular dental care",
        "Annual wellness exams",
      ],
      "Senior Care": [
        "More frequent vet visits (every 6 months)",
        "Joint supplements (glucosamine, chondroitin)",
        "Softer bedding and ramps for stairs",
      ],
    },
    behavior: {
      "Temperament": [
        "Friendly, intelligent, devoted",
        "Eager to please, rarely aggressive",
      ],
      "Training Tips": [
        "Start training early (8-12 weeks)",
        "Use positive reinforcement",
        "Socialize with various people, animals, and environments",
      ],
      "Common Behaviors": [
        "Retrieving instincts (love fetching)",
        "Mouthing/gentle chewing (provide appropriate toys)",
        "Swimming (natural swimmers)",
      ],
      "Mental Stimulation": [
        "Puzzle toys, obedience training",
        "Scent work, agility courses",
        "Regular interaction with family",
      ],
    },
    commonMistakes: [
      "Not providing enough exercise leading to destructive behavior",
      "Neglecting regular grooming leading to matting",
      "Overfeeding causing obesity (common in this breed)",
      "Not socializing properly during puppyhood",
      "Using punishment-based training methods",
    ],
    additionalTips: [
      "Consider pet insurance due to breed-specific health issues",
      "Goldens are prone to eating non-food items (pica) - supervise closely",
      "Excellent therapy and service dogs due to temperament",
      "May develop separation anxiety if left alone too much",
      "Regular ear cleaning needed due to floppy ears",
    ],
  ),
  PetGuide(
    id: 2,
    name: "Domestic Shorthair Cat",
    scientificName: "Felis catus",
    category: "Cat",
    lifespan: "12-20 years",
    adultSize: "3.6-4.5 kg",
    imageUrl:
        "https://images.unsplash.com/photo-1514888286974-6d03bde4ba14?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Domestic Shorthairs are the most common type of cat, known for their diverse appearances and adaptable personalities. They make excellent companions for various households.",
    keyPoints: [
      "Low-maintenance grooming needs",
      "Independent yet affectionate",
      "Adaptable to various living situations",
      "Excellent hunters and climbers",
      "Can live 15+ years with proper care",
    ],
    basicCare: {
      "Exercise": "30-60 minutes of interactive play daily",
      "Grooming": "Brush weekly, more during shedding seasons",
      "Litter Training": "Natural instinct, provide clean litter box",
      "Socialization": "Can be solitary or social depending on personality",
      "Space Needs": "Adapts well to apartments, needs vertical space",
    },
    feeding: {
      "Diet Type": [
        "High-protein cat food (wet and dry)",
        "Cats are obligate carnivores",
      ],
      "Daily Amount": [
        "1/4 - 1/2 cup dry food + 3-6 oz wet food",
        "Adjust based on age and activity",
      ],
      "Recommended Foods": [
        "High-quality protein sources",
        "Taurine-rich foods (essential for cats)",
      ],
      "Foods to Avoid": [
        "Onions, garlic, chives",
        "Chocolate, caffeine",
        "Alcohol, grapes",
        "Raw dough",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Multiple vertical spaces",
        "Quiet resting areas",
        "Scratching posts in key locations",
      ],
      "Bedding": ["Cozy beds in warm spots", "Cardboard boxes often preferred"],
      "Temperature": [
        "Comfortable at 65-75°F (18-24°C)",
        "Provide warm sleeping spots",
      ],
      "Safety": [
        "Secure windows and balconies",
        "Remove toxic plants",
        "Keep small objects away",
      ],
    },
    health: {
      "Common Issues": [
        "Dental disease",
        "Obesity",
        "Kidney disease in seniors",
        "Hyperthyroidism",
      ],
      "Vaccinations": [
        "Core: FVRCP, Rabies",
        "Optional: FeLV for outdoor cats",
      ],
      "Preventative Care": [
        "Annual vet exams",
        "Dental care (brushing, dental treats)",
        "Flea prevention",
      ],
      "Senior Care": [
        "More frequent vet visits",
        "Softer food options",
        "Joint supplements",
      ],
    },
    behavior: {
      "Temperament": [
        "Independent, curious, affectionate",
        "Varies widely by individual",
      ],
      "Training Tips": [
        "Use positive reinforcement",
        "Clicker training works well",
        "Respect their independence",
      ],
      "Common Behaviors": [
        "Kneading (making biscuits)",
        "Purring when content",
        "Scratching to mark territory",
      ],
      "Mental Stimulation": [
        "Puzzle feeders",
        "Interactive toys",
        "Window perches for bird watching",
      ],
    },
    commonMistakes: [
      "Free-feeding leading to obesity",
      "Not providing enough scratching surfaces",
      "Using punishment instead of redirection",
      "Ignoring dental care",
      "Not spaying/neutering",
    ],
    additionalTips: [
      "Provide multiple litter boxes (one per cat plus one extra)",
      "Regular nail trimming prevents furniture damage",
      "Microchip your cat for identification",
      "Consider cat trees for vertical territory",
      "Regular play prevents boredom and behavior issues",
    ],
  ),
  PetGuide(
    id: 3,
    name: "Budgerigar (Budgie)",
    scientificName: "Melopsittacus undulatus",
    category: "Bird",
    lifespan: "5-10 years",
    adultSize: "15-20 cm",
    imageUrl:
        "https://images.unsplash.com/photo-1552728089-57bdde30beb3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Budgerigars are small, colorful parrots native to Australia. They are intelligent, social birds that can learn to mimic speech and perform tricks.",
    keyPoints: [
      "Highly social, best kept in pairs",
      "Can learn to mimic speech and sounds",
      "Require large cage and daily out-of-cage time",
      "Sensitive to air quality and temperature changes",
      "Intelligent and need mental stimulation",
    ],
    basicCare: {
      "Exercise": "Minimum 2-3 hours out of cage daily",
      "Grooming": "Regular nail trims, occasional wing clipping",
      "Training": "Respond well to positive reinforcement",
      "Socialization": "Need daily interaction with humans or other budgies",
      "Space Needs": "Large horizontal cage (minimum 18x18x24 inches)",
    },
    feeding: {
      "Diet Type": [
        "High-quality pellet base (70%)",
        "Fresh vegetables and fruits (30%)",
      ],
      "Daily Amount": [
        "1-2 tablespoons of pellets",
        "Variety of fresh produce daily",
      ],
      "Recommended Foods": [
        "Leafy greens (kale, spinach)",
        "Carrots, bell peppers",
        "Apples, berries (no seeds)",
      ],
      "Foods to Avoid": [
        "Avocado (toxic)",
        "Chocolate, caffeine",
        "Alcohol",
        "Onions, garlic",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Large cage with horizontal space",
        "Multiple perches of varying sizes",
        "Safe room for flying exercise",
      ],
      "Bedding": [
        "Paper-based bedding changed daily",
        "Avoid corn cob or wood shavings",
      ],
      "Temperature": [
        "65-80°F (18-27°C)",
        "Avoid drafts and direct sunlight",
        "Humidity 40-70%",
      ],
      "Safety": [
        "No Teflon/non-stick cookware in home",
        "Cover windows and mirrors",
        "Remove toxic plants",
      ],
    },
    health: {
      "Common Issues": [
        "Respiratory infections",
        "Nutritional deficiencies",
        "Egg binding in females",
        "Mites and parasites",
      ],
      "Vet Care": [
        "Avian veterinarian required",
        "Annual check-ups recommended",
      ],
      "Preventative Care": [
        "Regular cage cleaning",
        "Quarantine new birds",
        "Monitor droppings daily",
      ],
      "Warning Signs": [
        "Fluffed feathers",
        "Sitting on cage floor",
        "Labored breathing",
        "Changes in droppings",
      ],
    },
    behavior: {
      "Temperament": [
        "Social, curious, active",
        "Can be noisy during dawn and dusk",
      ],
      "Training Tips": [
        "Start with step-up command",
        "Use millet as training treat",
        "Short, frequent training sessions",
      ],
      "Common Behaviors": [
        "Chattering and singing",
        "Head bobbing when excited",
        "Preening self and others",
      ],
      "Mental Stimulation": [
        "Foraging toys",
        "Mirrors (use cautiously)",
        "Rotating toys weekly",
      ],
    },
    commonMistakes: [
      "Keeping single bird without enough human interaction",
      "Seed-only diet causing malnutrition",
      "Cage too small or wrong shape",
      "Ignoring signs of illness",
      "Using sandpaper perch covers",
    ],
    additionalTips: [
      "Consider DNA sexing for accurate gender identification",
      "Provide cuttlebone for calcium",
      "Regular wing and nail trims by professional",
      "Budgies are flock animals - consider getting a pair",
      "Monitor weight monthly",
    ],
  ),
  PetGuide(
    id: 4,
    name: "Syrian Hamster",
    scientificName: "Mesocricetus auratus",
    category: "Small Mammal",
    lifespan: "2-3 years",
    adultSize: "13-18 cm",
    imageUrl:
        "https://images.unsplash.com/photo-1590664327927-2ab5e3c50d10?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Syrian Hamsters are solitary, nocturnal rodents that make popular first pets. They are known for their cheek pouches used for food storage and distinctive personalities.",
    keyPoints: [
      "Solitary animals - must live alone",
      "Nocturnal (active at night)",
      "Excellent escape artists",
      "Require large enclosures with deep bedding",
      "Short lifespan compared to other pets",
    ],
    basicCare: {
      "Exercise":
          "Exercise wheel (minimum 8 inches) - Out-of-cage play in secure area",
      "Grooming":
          "Sand baths for cleaning (no water baths) - Occasional nail trims if needed",
      "Handling":
          "Gentle, regular handling for taming - Approach from front at eye level",
      "Socialization":
          "Not social with other hamsters - Can bond with human caregivers",
      "Space Needs": "Minimum 450 square inches of floor space",
    },
    feeding: {
      "Diet Type": ["Commercial hamster mix", "Supplement with fresh foods"],
      "Daily Amount": [
        "1-2 tablespoons of commercial mix",
        "Small amounts of fresh foods",
      ],
      "Recommended Foods": [
        "Commercial hamster pellets",
        "Small amounts of fruits/vegetables",
        "Mealworms for protein",
      ],
      "Foods to Avoid": [
        "Citrus fruits",
        "Onions, garlic",
        "Raw potatoes",
        "Sugary or salty foods",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Large bin cage or aquarium",
        "Deep bedding for burrowing",
        "Multiple hideouts",
      ],
      "Bedding": [
        "Paper-based bedding 6+ inches deep",
        "Avoid pine or cedar shavings",
      ],
      "Temperature": ["65-75°F (18-24°C)", "Avoid drafts and direct heat"],
      "Safety": [
        "Secure lid to prevent escapes",
        "Remove sharp objects",
        "Check for escape routes weekly",
      ],
    },
    health: {
      "Common Issues": [
        "Wet tail (diarrhea)",
        "Diabetes (in certain color varieties)",
        "Dental problems (overgrown teeth)",
        "Respiratory infections",
      ],
      "Vet Care": [
        "Exotic animal veterinarian",
        "Annual check-ups recommended",
      ],
      "Preventative Care": [
        "Clean cage weekly",
        "Monitor weight monthly",
        "Check teeth regularly",
      ],
      "Warning Signs": [
        "Wet tail area",
        "Lethargy during active hours",
        "Weight loss",
        "Labored breathing",
      ],
    },
    behavior: {
      "Temperament": [
        "Solitary, territorial",
        "Can be tamed with patience",
        "Most active at night",
      ],
      "Training Tips": [
        "Use treats for positive reinforcement",
        "Handle gently and consistently",
        "Respect their sleep schedule",
      ],
      "Common Behaviors": [
        "Hoarding food in cheek pouches",
        "Burrowing in bedding",
        "Running on wheel for hours",
      ],
      "Mental Stimulation": [
        "Foraging toys",
        "Tunnels and mazes",
        "Paper towel tubes for chewing",
      ],
    },
    commonMistakes: [
      "Keeping multiple hamsters together",
      "Cage too small (under 450 sq inches)",
      "Incorrect wheel size or type",
      "Poor diet (seed-only mixes)",
      "Insufficient bedding depth",
    ],
    additionalTips: [
      "Provide chew toys for dental health",
      "Spot clean daily, full clean weekly",
      "Syrians are escape artists - secure enclosure well",
      "Record weight monthly to monitor health",
      "Prepare for short lifespan (2-3 years)",
    ],
  ),
  PetGuide(
    id: 5,
    name: "Bearded Dragon",
    scientificName: "Pogona vitticeps",
    category: "Reptile",
    lifespan: "8-12 years",
    adultSize: "40-60 cm",
    imageUrl:
        "https://images.unsplash.com/photo-1497206365907-f5e630693df0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Bearded Dragons are docile, diurnal lizards native to Australia. They are popular reptile pets due to their calm temperament and relatively easy care requirements.",
    keyPoints: [
      "Diurnal (active during the day)",
      "Require specific temperature gradients",
      "Need UVB lighting for calcium metabolism",
      "Omnivorous diet (insects and vegetables)",
      "Can live 10+ years with proper care",
    ],
    basicCare: {
      "Exercise":
          "Daily supervised out-of-enclosure time - Climbing opportunities in habitat",
      "Handling":
          "Generally docile and tolerant of handling - Support entire body when holding",
      "Temperature":
          "Basking spot: 95-110°F (35-43°C) - cool side: 75-85°F (24-29°C)",
      "Lighting":
          "UVB light essential for 10-12 hours daily - Replace UVB bulbs every 6 months",
      "Hygiene": "Spot clean daily, deep clean weekly",
    },
    feeding: {
      "Diet Type": [
        "Omnivorous: insects and vegetables",
        "Juveniles: 80% insects, 20% veggies",
        "Adults: 20% insects, 80% veggies",
      ],
      "Daily Amount": [
        "Juveniles: 2-3 feedings daily",
        "Adults: 1 feeding daily",
      ],
      "Recommended Foods": [
        "Crickets, dubia roaches, mealworms",
        "Collard greens, mustard greens, squash",
        "Limited fruits as treats",
      ],
      "Foods to Avoid": [
        "Fireflies (toxic)",
        "Avocado",
        "Rhubarb",
        "Iceberg lettuce (low nutrition)",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Minimum 40-gallon tank for adults",
        "Temperature gradient essential",
        "Multiple hiding spots",
      ],
      "Substrate": [
        "Reptile carpet, tile, or paper towels",
        "Avoid loose substrates for juveniles",
      ],
      "Decor": [
        "Basking platforms",
        "Hides on both warm and cool sides",
        "Climbing branches",
      ],
      "Safety": [
        "Secure screen top",
        "No heat rocks",
        "Thermostat on heat sources",
      ],
    },
    health: {
      "Common Issues": [
        "Metabolic bone disease (from lack of UVB)",
        "Impaction (from substrate or oversized food)",
        "Respiratory infections",
        "Parasites",
      ],
      "Vet Care": [
        "Reptile/exotic animal veterinarian",
        "Annual check-ups recommended",
        "Fecal exams for parasites",
      ],
      "Preventative Care": [
        "Proper UVB lighting",
        "Calcium and vitamin supplements",
        "Proper temperature gradients",
      ],
      "Warning Signs": [
        "Lethargy, loss of appetite",
        "Swollen joints or limbs",
        "Difficulty shedding",
        "Runny stool",
      ],
    },
    behavior: {
      "Temperament": [
        "Generally docile and calm",
        "Can show territorial behavior",
        "Communicate through body language",
      ],
      "Body Language": [
        "Beard puffing (stress or dominance)",
        "Head bobbing (males displaying)",
        "Arm waving (submission)",
        "Color changes (mood or temperature)",
      ],
      "Handling Tips": [
        "Approach from side, not above",
        "Support entire body",
        "Limit handling during shedding",
      ],
      "Mental Stimulation": [
        "Food puzzles",
        "Environmental changes",
        "Supervised exploration",
      ],
    },
    commonMistakes: [
      "Insufficient UVB lighting",
      "Incorrect temperatures",
      "Feeding oversized prey items",
      "Using sand substrate for juveniles",
      "Not providing proper supplements",
    ],
    additionalTips: [
      "Gut-load insects before feeding",
      "Dust food with calcium + D3 supplement",
      "Provide shallow water dish for soaking",
      "Monitor humidity (30-40% ideal)",
      "Record growth and feeding habits",
    ],
  ),
  PetGuide(
    id: 6,
    name: "Betta Fish",
    scientificName: "Betta splendens",
    category: "Fish",
    lifespan: "3-5 years",
    adultSize: "6-7.5 cm",
    imageUrl:
        "https://images.unsplash.com/photo-1511300636408-a63a89df3482?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Betta fish, also known as Siamese fighting fish, are colorful freshwater fish known for their elaborate fins and territorial behavior. They are popular aquarium pets but have specific care requirements.",
    keyPoints: [
      "Solitary - must be kept alone (except females in sororities)",
      "Require heated and filtered water",
      "Labyrinth organ allows breathing atmospheric air",
      "Sensitive to water quality changes",
      "Can recognize their owners",
    ],
    basicCare: {
      "Tank Size": "Minimum 5 gallons (19 liters) - Larger is always better",
      "Water Temperature": "78-80°F (25-27°C) - Heater required",
      "Filtration":
          "Gentle filter with adjustable flow - Sponge filters work well",
      "Water Changes": "25% weekly water changes - Use water conditioner",
      "Lighting": "8-12 hours daily - Provide hiding spots from light",
    },
    feeding: {
      "Diet Type": [
        "Carnivorous - high protein required",
        "Variety of foods recommended",
      ],
      "Daily Amount": [
        "2-3 pellets twice daily",
        "Feed amount they can consume in 2 minutes",
      ],
      "Recommended Foods": [
        "Betta-specific pellets",
        "Frozen or live brine shrimp",
        "Bloodworms, daphnia",
      ],
      "Foods to Avoid": [
        "Flakes (often lack nutrition)",
        "Overfeeding",
        "Human food",
        "Goldfish food",
      ],
    },
    housing: {
      "Tank Setup": [
        "Minimum 5-gallon tank",
        "Lid required (they jump)",
        "Gentle filtration",
        "Heater with thermometer",
      ],
      "Decor": [
        "Live or silk plants (avoid plastic)",
        "Caves and hiding spots",
        "Floating plants for security",
      ],
      "Substrate": [
        "Fine gravel or sand",
        "Dark substrate shows colors better",
      ],
      "Safety": [
        "No sharp decor that can tear fins",
        "Avoid strong currents",
        "Keep away from drafts",
      ],
    },
    health: {
      "Common Issues": [
        "Fin rot (bacterial infection)",
        "Ich (white spot disease)",
        "Swim bladder disorder",
        "Velvet disease (parasite)",
      ],
      "Preventative Care": [
        "Regular water testing",
        "Proper cycling of tank",
        "Quarantine new plants/decor",
      ],
      "Water Parameters": [
        "pH: 6.5-7.5",
        "Ammonia: 0 ppm",
        "Nitrite: 0 ppm",
        "Nitrate: <20 ppm",
      ],
      "Warning Signs": [
        "Clamped fins",
        "Loss of color",
        "Lethargy",
        "Loss of appetite",
      ],
    },
    behavior: {
      "Temperament": [
        "Territorial with other bettas",
        "Can be aggressive to similar-looking fish",
        "Generally curious and interactive",
      ],
      "Social Behavior": [
        "Must be kept alone (males)",
        "Females can sometimes live in groups",
        "Not community tank fish",
      ],
      "Enrichment": [
        "Mirror training (short periods)",
        "Floating log for resting",
        "Varied diet for mental stimulation",
      ],
      "Communication": [
        "Flaring gills (aggression or display)",
        "Color changes",
        "Bubble nest building (breeding behavior)",
      ],
    },
    commonMistakes: [
      "Keeping in bowls or small containers",
      "No heater or filter",
      "Overcrowding or keeping with incompatible tank mates",
      "Overfeeding",
      "Not cycling tank before adding fish",
    ],
    additionalTips: [
      "Cycle tank completely before adding fish",
      "Test water parameters weekly",
      "Use aquarium salt for minor ailments",
      "Keep tank out of direct sunlight",
      "Record feeding and behavior patterns",
    ],
  ),
  PetGuide(
    id: 7,
    name: "Rabbit",
    scientificName: "Oryctolagus cuniculus",
    category: "Small Mammal",
    lifespan: "8-12 years",
    adultSize: "1-9 kg",
    imageUrl:
        "https://images.unsplash.com/photo-1556838803-cc94986cb631?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80",
    description:
        "Rabbits are intelligent, social lagomorphs that make wonderful indoor companions. They require specific care, including proper diet, housing, and socialization.",
    keyPoints: [
      "Social animals - best kept in pairs",
      "Require large living space with exercise area",
      "Need unlimited hay for dental and digestive health",
      "Can be litter trained",
      "Live 8-12 years with proper care",
    ],
    basicCare: {
      "Exercise":
          "Minimum 4 hours of supervised free-roam time daily in a secure, bunny-proofed area",
      "Grooming":
          "Regular brushing (daily during shedding), Nail trims every 4-6 weeks",
      "Socialization":
          "Best kept in bonded pairs, Need daily human interaction",
      "Litter Training":
          "Use paper-based litter in large box, Place hay rack above litter box",
      "Space Needs": "Minimum 12 square feet of enclosure space",
    },
    feeding: {
      "Diet Type": [
        "Unlimited grass hay (80-90% of diet)",
        "Limited pellets",
        "Fresh vegetables",
        "Limited fruits as treats",
      ],
      "Daily Amount": [
        "Unlimited timothy or orchard grass hay",
        "1/4 cup pellets per 5 lbs body weight",
        "2 cups fresh vegetables per 6 lbs body weight",
      ],
      "Recommended Foods": [
        "Timothy hay (adults), alfalfa (babies)",
        "Leafy greens (romaine, kale, cilantro)",
        "Carrot tops, bell peppers",
      ],
      "Foods to Avoid": [
        "Iceberg lettuce",
        "Avocado",
        "Chocolate, sweets",
        "Grains, beans, nuts",
      ],
    },
    housing: {
      "Ideal Environment": [
        "Large exercise pen or free-roam",
        "Multiple levels for exploration",
        "Quiet area for resting",
      ],
      "Bedding": [
        "Paper-based litter in litter box",
        "Fleece blankets or towels",
        "Avoid cedar or pine shavings",
      ],
      "Temperature": [
        "60-70°F (15-21°C) ideal",
        "Avoid temperatures above 80°F (27°C)",
      ],
      "Safety": [
        "Bunny-proof electrical cords",
        "Remove toxic plants",
        "Secure heavy items that could fall",
      ],
    },
    health: {
      "Common Issues": [
        "GI stasis (digestive slowdown)",
        "Dental problems (overgrown teeth)",
        "Respiratory infections",
        "Sore hocks",
      ],
      "Vet Care": [
        "Exotic animal veterinarian required",
        "Annual check-ups",
        "Spay/neuter essential for health",
      ],
      "Preventative Care": [
        "Unlimited hay for dental health",
        "Regular grooming",
        "Monitor eating and bathroom habits",
      ],
      "Emergency Signs": [
        "Not eating for 12+ hours",
        "No fecal output",
        "Lethargy",
        "Difficulty breathing",
      ],
    },
    behavior: {
      "Temperament": [
        "Social, curious, intelligent",
        "Can be territorial",
        "Most active at dawn and dusk",
      ],
      "Communication": [
        "Tooth purring (contentment)",
        "Thumping (alarm)",
        "Nudging (attention seeking)",
        "Circling (courtship)",
      ],
      "Training Tips": [
        "Use positive reinforcement",
        "Clicker training works well",
        "Respect their space and boundaries",
      ],
      "Enrichment": [
        "Tunnels and hiding spots",
        "Chew toys (apple wood, willow)",
        "Digging boxes",
        "Food puzzles",
      ],
    },
    commonMistakes: [
      "Keeping in small cages",
      "Poor diet (lack of hay, too many pellets)",
      "Not spaying/neutering",
      "Improper handling (scruffing)",
      "Isolation (single rabbit without companion)",
    ],
    additionalTips: [
      "Spay/neuter reduces cancer risk and improves behavior",
      "Provide hiding spots for security",
      "Regular weight monitoring",
      "Keep nails trimmed to prevent injury",
      "Introduce new foods gradually",
    ],
  ),
];
