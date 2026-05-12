class MyPet {
  const MyPet({
    required this.id,
    required this.name,
    required this.age,
    required this.type,
  });

  final String id;
  final String name;
  final int age;
  final String type;

  MyPet copyWith({String? id, String? name, int? age, String? type}) {
    return MyPet(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      type: type ?? this.type,
    );
  }
}
