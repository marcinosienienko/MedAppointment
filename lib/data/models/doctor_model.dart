class Doctor {
  final String name;
  final String category;
  final String? avatarUrl; // Dodane, jeśli chcesz obsłużyć zdjęcia
  final String? pwzNumber; // Dodane, jeśli potrzebujesz numeru PWZ
  final String? description; // Dodane, jeśli potrzebujesz opisu

  Doctor({
    required this.name,
    required this.category,
    this.avatarUrl,
    this.pwzNumber,
    this.description,
  });
}
