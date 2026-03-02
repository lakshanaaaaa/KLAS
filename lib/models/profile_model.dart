enum Gender {
  female,
  male,
  other;

  String get displayName {
    switch (this) {
      case Gender.female:
        return 'Female';
      case Gender.male:
        return 'Male';
      case Gender.other:
        return 'Other';
    }
  }
}

enum SkinType {
  dry,
  oily,
  combination;

  String get displayName {
    switch (this) {
      case SkinType.dry:
        return 'Dry';
      case SkinType.oily:
        return 'Oily';
      case SkinType.combination:
        return 'Combination';
    }
  }
}

enum HairType {
  curly,
  straight,
  wavy;

  String get displayName {
    switch (this) {
      case HairType.curly:
        return 'Curly';
      case HairType.straight:
        return 'Straight';
      case HairType.wavy:
        return 'Wavy';
    }
  }
}

enum PrimaryConcern {
  acne,
  pigmentation,
  hairFall,
  dullSkin,
  frizz;

  String get displayName {
    switch (this) {
      case PrimaryConcern.acne:
        return 'Acne';
      case PrimaryConcern.pigmentation:
        return 'Pigmentation';
      case PrimaryConcern.hairFall:
        return 'Hair Fall';
      case PrimaryConcern.dullSkin:
        return 'Dull Skin';
      case PrimaryConcern.frizz:
        return 'Frizz';
    }
  }
}

enum FitPreference {
  loose,
  regular,
  slim;

  String get displayName {
    switch (this) {
      case FitPreference.loose:
        return 'Loose';
      case FitPreference.regular:
        return 'Regular';
      case FitPreference.slim:
        return 'Slim';
    }
  }
}

class ProfileModel {
  final String id;
  final String name;
  final int age;
  final Gender gender;
  final String? avatarUrl;
  
  // Size Details
  final String topSize;
  final String bottomSize;
  final String footwearSize;
  final FitPreference fitPreference;
  
  // Skin & Hair
  final SkinType skinType;
  final HairType hairType;
  final PrimaryConcern primaryConcern;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.age,
    this.gender = Gender.female,
    this.avatarUrl,
    required this.topSize,
    required this.bottomSize,
    required this.footwearSize,
    this.fitPreference = FitPreference.regular,
    required this.skinType,
    required this.hairType,
    required this.primaryConcern,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory ProfileModel.empty() {
    return ProfileModel(
      id: '',
      name: '',
      age: 0,
      topSize: '',
      bottomSize: '',
      footwearSize: '',
      skinType: SkinType.combination,
      hairType: HairType.straight,
      primaryConcern: PrimaryConcern.dullSkin,
    );
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    int? age,
    Gender? gender,
    String? avatarUrl,
    String? topSize,
    String? bottomSize,
    String? footwearSize,
    FitPreference? fitPreference,
    SkinType? skinType,
    HairType? hairType,
    PrimaryConcern? primaryConcern,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      topSize: topSize ?? this.topSize,
      bottomSize: bottomSize ?? this.bottomSize,
      footwearSize: footwearSize ?? this.footwearSize,
      fitPreference: fitPreference ?? this.fitPreference,
      skinType: skinType ?? this.skinType,
      hairType: hairType ?? this.hairType,
      primaryConcern: primaryConcern ?? this.primaryConcern,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender.name,
      'avatarUrl': avatarUrl,
      'topSize': topSize,
      'bottomSize': bottomSize,
      'footwearSize': footwearSize,
      'fitPreference': fitPreference.name,
      'skinType': skinType.name,
      'hairType': hairType.name,
      'primaryConcern': primaryConcern.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: Gender.values.firstWhere(
        (g) => g.name == json['gender'],
        orElse: () => Gender.female,
      ),
      avatarUrl: json['avatarUrl'],
      topSize: json['topSize'] ?? '',
      bottomSize: json['bottomSize'] ?? '',
      footwearSize: json['footwearSize'] ?? '',
      fitPreference: FitPreference.values.firstWhere(
        (f) => f.name == json['fitPreference'],
        orElse: () => FitPreference.regular,
      ),
      skinType: SkinType.values.firstWhere(
        (s) => s.name == json['skinType'],
        orElse: () => SkinType.combination,
      ),
      hairType: HairType.values.firstWhere(
        (h) => h.name == json['hairType'],
        orElse: () => HairType.straight,
      ),
      primaryConcern: PrimaryConcern.values.firstWhere(
        (p) => p.name == json['primaryConcern'],
        orElse: () => PrimaryConcern.dullSkin,
      ),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String get initials {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase() + 
           parts[1].substring(0, 1).toUpperCase();
  }

  bool get isEmpty {
    return name.isEmpty && age == 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProfileModel(id: $id, name: $name, age: $age)';
  }
}
