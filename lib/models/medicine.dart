// models/medicine.dart
import 'package:flutter/material.dart';

class Manufacturer {
  final String name;
  final String address;
  final String phone;

  Manufacturer({
    required this.name,
    required this.address,
    required this.phone,
  });
}

class MedicineStorage {
  final String temperature;
  final String lightProtection;
  final String afterOpening;

  MedicineStorage({
    required this.temperature,
    required this.lightProtection,
    required this.afterOpening,
  });
}

class Medicine {
  final int id;
  final String name;
  final String barcode;
  final String batchNumber;
  final String composition;
  final String form;
  final String route;
  final String animalType;
  final String category;
  final List<String> indications;
  final String dosage;
  final String administrationInstructions;
  final String usage;
  final List<String> sideEffects;
  final List<String> interactions;
  final List<String> contraindications;
  final String overdose;
  final String handlingPrecautions;
  final MedicineStorage storage;
  final String withdrawalPeriod;
  final String packaging;
  final Manufacturer manufacturer;
  final String regulatoryApprovalNumber;
  final double price;
  final int stock;
  final String expiryDate;
  final String imageUrl; // Added image URL field

  Medicine({
    required this.id,
    required this.name,
    required this.barcode,
    required this.batchNumber,
    required this.composition,
    required this.form,
    required this.route,
    required this.animalType,
    required this.category,
    required this.indications,
    required this.dosage,
    required this.administrationInstructions,
    required this.usage,
    required this.sideEffects,
    required this.interactions,
    required this.contraindications,
    required this.overdose,
    required this.handlingPrecautions,
    required this.storage,
    required this.withdrawalPeriod,
    required this.packaging,
    required this.manufacturer,
    required this.regulatoryApprovalNumber,
    required this.price,
    required this.stock,
    required this.expiryDate,
    required this.imageUrl,
  });

  // Get color based on category
  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'antibiotic':
        return const Color(0xFF2196F3);
      case 'anti-parasitic':
        return const Color(0xFF4CAF50);
      case 'flea & tick':
        return const Color(0xFFFF9800);
      case 'pain relief':
        return const Color(0xFFF44336);
      case 'anti-inflammatory':
        return const Color(0xFF9C27B0);
      case 'heartworm prevention':
        return const Color(0xFF00BCD4);
      default:
        return const Color(0xFF607D8B);
    }
  }

  // Get animal icon
  IconData getAnimalIcon() {
    if (animalType.toLowerCase().contains('cat')) {
      return Icons.pets;
    } else if (animalType.toLowerCase().contains('dog')) {
      return Icons.pets;
    } else {
      return Icons.pets;
    }
  }
}

// Sample medicines data with real image URLs
List<Medicine> medicines = [
  Medicine(
    id: 1,
    name: "Ivermectin 1% Injection",
    barcode: "8964500123456",
    batchNumber: "IVM-2024-07A",
    composition: "Ivermectin 10 mg/mL in propylene glycol base",
    form: "Injection",
    route: "Subcutaneous (SC)",
    animalType: "Dogs, Cats",
    category: "Anti-parasitic",
    indications: [
      "Demodectic mange",
      "Sarcoptic mange",
      "Ear mites",
      "Intestinal roundworms",
      "Heartworm prevention (off-label)",
    ],
    dosage: "0.2 mg/kg single dose SC",
    administrationInstructions:
        "Use sterile syringe, inject under loose skin over the shoulder blade.",
    usage: "Treatment and control of internal and external parasites.",
    sideEffects: [
      "Vomiting",
      "Temporary lethargy",
      "Hypersalivation (rare)",
      "Ataxia in overdose",
    ],
    interactions: [
      "Avoid combining with spinosad (increases toxicity risk)",
      "Caution with sedatives and CNS depressants",
    ],
    contraindications: [
      "Do not use in Collies, Shelties, Australian Shepherds with MDR1 mutation",
      "Do not use in kittens or puppies under 6 weeks",
    ],
    overdose:
        "Causes tremors, blindness, coma — treat with supportive care only.",
    handlingPrecautions:
        "Wear gloves; avoid skin and eye contact; wash hands after use.",
    storage: MedicineStorage(
      temperature: "Store below 30°C",
      lightProtection: "Keep in dark, protect from sunlight",
      afterOpening: "Use within 28 days",
    ),
    withdrawalPeriod: "Not applicable",
    packaging: "50 mL multidose vial",
    manufacturer: Manufacturer(
      name: "VetPharm International",
      address: "320 VetCare Drive, Berlin, Germany",
      phone: "+49 30 450 9987",
    ),
    regulatoryApprovalNumber: "VP-IM-2024-117",
    price: 14.50,
    stock: 40,
    expiryDate: "2026-07-10",
    imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZziobKqyqnZ211QL6pGctxrmU3d825urtxw&s",
  ),
  Medicine(
    id: 2,
    name: "Amoxicillin 250mg Tablet",
    barcode: "8964500123457",
    batchNumber: "AMX-2024-08B",
    composition: "Amoxicillin Trihydrate 250mg",
    form: "Tablet",
    route: "Oral",
    animalType: "Dogs, Cats",
    category: "Antibiotic",
    indications: [
      "Skin infections",
      "Urinary tract infections",
      "Respiratory infections",
      "Dental infections",
    ],
    dosage: "10-15 mg/kg every 12 hours",
    administrationInstructions: "Administer with food to reduce GI upset.",
    usage: "Broad-spectrum antibiotic for bacterial infections.",
    sideEffects: [
      "Diarrhea",
      "Vomiting",
      "Loss of appetite",
      "Allergic reactions (rare)",
    ],
    interactions: [
      "May reduce effectiveness of live bacterial vaccines",
      "Avoid with tetracyclines",
    ],
    contraindications: [
      "Known penicillin allergy",
      "Liver dysfunction",
      "Renal impairment",
    ],
    overdose: "May cause severe GI upset. Supportive treatment recommended.",
    handlingPrecautions:
        "Store in original packaging. Keep away from children.",
    storage: MedicineStorage(
      temperature: "Store at 15-25°C",
      lightProtection: "Protect from light",
      afterOpening: "Use within expiry date",
    ),
    withdrawalPeriod: "5 days for milk, 7 days for meat",
    packaging: "100 tablets per bottle",
    manufacturer: Manufacturer(
      name: "PetMed Pharmaceuticals",
      address: "123 Animal Health Ave, Mumbai, India",
      phone: "+91 22 4567 8901",
    ),
    regulatoryApprovalNumber: "PM-AMX-2024-245",
    price: 8.99,
    stock: 125,
    expiryDate: "2025-12-15",
    imageUrl:
        "https://5.imimg.com/data5/SELLER/Default/2024/5/422250798/QF/UG/MH/15333893/almox-250-mg-capsule-amoxycillin-250mg.jpg",
  ),
  Medicine(
    id: 3,
    name: "Revolution for Cats",
    barcode: "8964500123458",
    batchNumber: "REV-2024-09C",
    composition: "Selamectin 45mg, 60mg, 120mg per tube",
    form: "Topical Solution",
    route: "Topical",
    animalType: "Cats",
    category: "Flea & Tick",
    indications: [
      "Flea prevention and treatment",
      "Ear mites",
      "Heartworm prevention",
      "Roundworm control",
    ],
    dosage: "6mg/kg monthly",
    administrationInstructions:
        "Apply to skin at base of neck between shoulder blades.",
    usage: "Monthly parasite prevention.",
    sideEffects: [
      "Hair loss at application site",
      "Temporary itching",
      "Lethargy",
    ],
    interactions: [],
    contraindications: ["Sick or debilitated animals", "Kittens under 6 weeks"],
    overdose: "Rare. May cause vomiting or diarrhea.",
    handlingPrecautions:
        "Avoid contact with skin. Wash hands after application.",
    storage: MedicineStorage(
      temperature: "Store below 30°C",
      lightProtection: "Store in original packaging",
      afterOpening: "Use immediately",
    ),
    withdrawalPeriod: "Not applicable",
    packaging: "Single dose pipettes (3 or 6 pack)",
    manufacturer: Manufacturer(
      name: "Zoetis Animal Health",
      address: "10 Sylvan Way, Parsippany, NJ 07054, USA",
      phone: "+1 973 444 2000",
    ),
    regulatoryApprovalNumber: "ZOE-REV-2024-378",
    price: 24.99,
    stock: 75,
    expiryDate: "2025-10-20",
    imageUrl:
        "https://cdn11.bigcommerce.com/s-jie5o9x4em/images/stencil/1280x1280/products/127/386/RevolutionFelinePlus__99956.1687616722.PNG?c=1",
  ),
  Medicine(
    id: 4,
    name: "Rimadyl 100mg Chewable",
    barcode: "8964500123459",
    batchNumber: "RIM-2024-10D",
    composition: "Carprofen 100mg",
    form: "Chewable Tablet",
    route: "Oral",
    animalType: "Dogs",
    category: "Pain Relief",
    indications: [
      "Osteoarthritis pain",
      "Post-operative pain",
      "Inflammation reduction",
    ],
    dosage: "2mg/kg every 12 hours",
    administrationInstructions: "May be given with or without food.",
    usage: "Non-steroidal anti-inflammatory drug (NSAID).",
    sideEffects: [
      "Vomiting",
      "Diarrhea",
      "Decreased appetite",
      "Liver enzyme changes",
    ],
    interactions: [
      "Avoid with other NSAIDs",
      "Use cautiously with corticosteroids",
    ],
    contraindications: [
      "Liver disease",
      "Kidney disease",
      "Gastrointestinal ulcers",
      "Pregnant animals",
    ],
    overdose: "May cause GI bleeding or kidney failure.",
    handlingPrecautions: "Keep out of reach of children.",
    storage: MedicineStorage(
      temperature: "Store at 20-25°C",
      lightProtection: "Protect from moisture",
      afterOpening: "Use within 60 days",
    ),
    withdrawalPeriod: "Not for use in food-producing animals",
    packaging: "60 tablets per bottle",
    manufacturer: Manufacturer(
      name: "Pfizer Animal Health",
      address: "235 East 42nd Street, New York, NY 10017, USA",
      phone: "+1 212 733 2323",
    ),
    regulatoryApprovalNumber: "PFE-RIM-2024-512",
    price: 65.50,
    stock: 30,
    expiryDate: "2026-03-15",
    imageUrl:
        "https://pilldroppets.co.nz/cdn/shop/products/PillDrop_Rimadyl100.jpg?crop=center&height=540&v=1654305534&width=540",
  ),
  Medicine(
    id: 5,
    name: "Metacam Oral Suspension",
    barcode: "8964500123460",
    batchNumber: "MET-2024-11E",
    composition: "Meloxicam 1.5mg/mL",
    form: "Oral Suspension",
    route: "Oral",
    animalType: "Dogs, Cats",
    category: "Anti-inflammatory",
    indications: [
      "Acute and chronic pain",
      "Musculoskeletal disorders",
      "Post-operative inflammation",
    ],
    dosage: "0.1mg/kg initial dose, then 0.05mg/kg daily",
    administrationInstructions: "Shake well before use. Administer with food.",
    usage: "Long-term pain management.",
    sideEffects: [
      "GI upset",
      "Increased thirst",
      "Kidney changes with long-term use",
    ],
    interactions: ["Avoid with other NSAIDs", "Increased risk with diuretics"],
    contraindications: [
      "Active GI ulcers",
      "Severe kidney disease",
      "Dehydration",
    ],
    overdose: "May cause renal failure. Supportive treatment required.",
    handlingPrecautions: "Use measuring syringe provided.",
    storage: MedicineStorage(
      temperature: "Store below 25°C",
      lightProtection: "Protect from light",
      afterOpening: "Discard after 6 months",
    ),
    withdrawalPeriod: "28 days",
    packaging: "32mL bottle with dosing syringe",
    manufacturer: Manufacturer(
      name: "Boehringer Ingelheim",
      address: "Binger Strasse 173, 55216 Ingelheim am Rhein, Germany",
      phone: "+49 6132 77 0",
    ),
    regulatoryApprovalNumber: "BI-MET-2024-689",
    price: 42.75,
    stock: 55,
    expiryDate: "2025-09-30",
    imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRljduaUknkE1q-NFK_iYE7xBdjOuWPzzczbg&s",
  ),
  Medicine(
    id: 6,
    name: "Heartgard Plus Chewables",
    barcode: "8964500123461",
    batchNumber: "HGP-2024-12F",
    composition: "Ivermectin 68μg, Pyrantel 57mg",
    form: "Chewable Tablet",
    route: "Oral",
    animalType: "Dogs",
    category: "Heartworm Prevention",
    indications: [
      "Heartworm prevention",
      "Roundworm control",
      "Hookworm control",
    ],
    dosage: "According to weight - 1 tablet monthly",
    administrationInstructions:
        "Administer monthly. Dogs will usually eat as treat.",
    usage: "Monthly heartworm and intestinal parasite prevention.",
    sideEffects: ["Vomiting (rare)", "Diarrhea (rare)", "Lethargy (rare)"],
    interactions: [],
    contraindications: [
      "MDR1 mutation breeds (Collies, etc.)",
      "Puppies under 6 weeks",
    ],
    overdose: "Low toxicity. May cause temporary neurological signs.",
    handlingPrecautions: "Store in original packaging.",
    storage: MedicineStorage(
      temperature: "Store at room temperature",
      lightProtection: "Protect from moisture",
      afterOpening: "Use within expiry date",
    ),
    withdrawalPeriod: "Not applicable",
    packaging: "6 tablets per box",
    manufacturer: Manufacturer(
      name: "Merial",
      address: "3239 Satellite Blvd, Duluth, GA 30096, USA",
      phone: "+1 888 637 4251",
    ),
    regulatoryApprovalNumber: "MER-HGP-2024-734",
    price: 75.00,
    stock: 90,
    expiryDate: "2026-05-10",
    imageUrl:
        "https://www.vetnpetdirect.com.au/cdn/shop/products/759736_1200x.jpg?v=1569369288",
  ),
  Medicine(
    id: 7,
    name: "Clavamox Drops",
    barcode: "8964500123462",
    batchNumber: "CLA-2024-13G",
    composition: "Amoxicillin 62.5mg, Clavulanic acid 12.5mg per mL",
    form: "Oral Suspension",
    route: "Oral",
    animalType: "Dogs, Cats",
    category: "Antibiotic",
    indications: [
      "Skin infections",
      "Soft tissue infections",
      "Dental infections",
      "Respiratory infections",
    ],
    dosage: "12.5mg/kg every 12 hours",
    administrationInstructions:
        "Shake well before use. Refrigerate after reconstitution.",
    usage: "Broad-spectrum antibiotic for resistant infections.",
    sideEffects: ["GI upset", "Diarrhea", "Loss of appetite"],
    interactions: ["Avoid with bacteriostatic antibiotics"],
    contraindications: ["Penicillin allergy", "History of liver disease"],
    overdose: "May cause severe GI symptoms.",
    handlingPrecautions: "Use provided dosing syringe.",
    storage: MedicineStorage(
      temperature: "Refrigerate at 2-8°C after reconstitution",
      lightProtection: "Store in original carton",
      afterOpening: "Discard after 10 days",
    ),
    withdrawalPeriod: "7 days",
    packaging: "15mL bottle with syringe",
    manufacturer: Manufacturer(
      name: "Zoetis Animal Health",
      address: "10 Sylvan Way, Parsippany, NJ 07054, USA",
      phone: "+1 973 444 2000",
    ),
    regulatoryApprovalNumber: "ZOE-CLA-2024-845",
    price: 28.50,
    stock: 65,
    expiryDate: "2025-07-20",
    imageUrl:
        "https://imagedelivery.net/OWeDZSTbTyzlX4Fsq0SDAw/10074/w=700,h=700,q=80",
  ),
  Medicine(
    id: 8,
    name: "Frontline Plus for Dogs",
    barcode: "8964500123463",
    batchNumber: "FRT-2024-14H",
    composition: "Fipronil 9.8%, (S)-methoprene 8.8%",
    form: "Topical Solution",
    route: "Topical",
    animalType: "Dogs",
    category: "Flea & Tick",
    indications: [
      "Flea treatment and prevention",
      "Tick control",
      "Lice control",
    ],
    dosage: "According to weight - 1 pipette monthly",
    administrationInstructions: "Apply to skin between shoulder blades.",
    usage: "Monthly external parasite control.",
    sideEffects: ["Skin irritation at site", "Hair loss", "Temporary itching"],
    interactions: [],
    contraindications: ["Sick, debilitated animals", "Puppies under 8 weeks"],
    overdose: "Rare. May cause vomiting or excessive salivation.",
    handlingPrecautions: "Wear gloves. Avoid contact with skin.",
    storage: MedicineStorage(
      temperature: "Store below 30°C",
      lightProtection: "Store in original packaging",
      afterOpening: "Use immediately",
    ),
    withdrawalPeriod: "Not applicable",
    packaging: "6 pipettes per box",
    manufacturer: Manufacturer(
      name: "Merial",
      address: "3239 Satellite Blvd, Duluth, GA 30096, USA",
      phone: "+1 888 637 4251",
    ),
    regulatoryApprovalNumber: "MER-FRT-2024-912",
    price: 175.00,
    stock: 120,
    expiryDate: "2026-01-30",
    imageUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQG9MnWSsNov39HKOkpSK_2ObGS2R2BZUBROQ&s",
  ),
];
