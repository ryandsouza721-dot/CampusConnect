class UserProfile {
  final String id;
  String name;
  String email;
  String department; // CSE, Mechanical, Civil, EXTC
  String yearOfStudy; // 1st, 2nd, 3rd, 4th
  String division; // Div B
  String rollNumber; // 42
  List<String> clubs; // AI/ML, Coding, E-Cell, Sports, Cultural
  String avatarInitials;
  bool isProfileComplete;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.yearOfStudy,
    required this.division,
    required this.rollNumber,
    required this.clubs,
    required this.avatarInitials,
    this.isProfileComplete = true,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? department,
    String? yearOfStudy,
    String? division,
    String? rollNumber,
    List<String>? clubs,
    String? avatarInitials,
    bool? isProfileComplete,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      division: division ?? this.division,
      rollNumber: rollNumber ?? this.rollNumber,
      clubs: clubs ?? List.from(this.clubs),
      avatarInitials: avatarInitials ?? this.avatarInitials,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  factory UserProfile.defaultUser() {
    return UserProfile(
      id: 'usr_001',
      name: 'Darvin',
      email: 'darvin.student@fcrit.ac.in',
      department: 'CSE',
      yearOfStudy: '2nd',
      division: 'Div B',
      rollNumber: '42',
      clubs: ['Coding'],
      avatarInitials: 'FC',
      isProfileComplete: true,
    );
  }
}
