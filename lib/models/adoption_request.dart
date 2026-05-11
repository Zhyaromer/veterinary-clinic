class AdoptionRequest {
  final dynamic id; // Firestore doc ID
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String petType;
  final String petName;
  final String breed;
  final String age;
  final String gender;
  final String reason;
  final String specialNeeds;
  final bool isVaccinated;
  final bool isNeutered;
  final bool hasMedicalIssues;
  final bool isHouseTrained;
  final bool agreeToTerms;
  final bool homeVisitAgreed;
  final bool canAffordCare;
  final bool hasExperience;
  final DateTime submittedDate;
  final String status; // pending, approved, rejected, adopted
  final String? shelterPetId; // Link to the shelter pet being adopted
  final String? notes;

  AdoptionRequest({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.petType,
    required this.petName,
    required this.breed,
    required this.age,
    required this.gender,
    required this.reason,
    required this.specialNeeds,
    required this.isVaccinated,
    required this.isNeutered,
    required this.hasMedicalIssues,
    required this.isHouseTrained,
    required this.agreeToTerms,
    required this.homeVisitAgreed,
    required this.canAffordCare,
    required this.hasExperience,
    required this.submittedDate,
    this.status = 'pending',
    this.shelterPetId,
    this.notes,
  });
}
