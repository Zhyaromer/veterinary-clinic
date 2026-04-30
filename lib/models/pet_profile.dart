class PetProfile {
  PetProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    this.notes = '',
  });

  final int id;
  final String name;
  final String type;
  final String breed;
  final String age;
  final String notes;

  PetProfile copyWith({
    int? id,
    String? name,
    String? type,
    String? breed,
    String? age,
    String? notes,
  }) {
    return PetProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      notes: notes ?? this.notes,
    );
  }
}

/// Seed data for local-only CRUD operations.
List<PetProfile> petProfiles = [
  PetProfile(
    id: 1,
    name: 'Buddy',
    type: 'Dog',
    breed: 'Golden Retriever',
    age: '3 years',
    notes: 'Friendly and active.',
  ),
  PetProfile(
    id: 2,
    name: 'Luna',
    type: 'Cat',
    breed: 'Siamese',
    age: '2 years',
    notes: 'Prefers quiet spaces.',
  ),
  PetProfile(
    id: 3,
    name: 'Kiwi',
    type: 'Bird',
    breed: 'Parrot',
    age: '11 months',
    notes: 'Learning new words.',
  ),
];
