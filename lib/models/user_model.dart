class User {
  final int id;
  final String last_name;
  final String first_name;
  final String email;
  final String? sex;
  final String? contact_number;
  final ProfilePhoto? profilePicture; 
  final Campus? campus;
  final String? id_number;
  final String? role;
  final String? external_organization;
  final int? patron_type;
  final String? ebc; 
  final String? address;

  User({
    required this.id,
    required this.last_name,
    required this.first_name,
    required this.email,
    this.contact_number,
    this.sex,
    this.profilePicture,
    this.campus,
    this.id_number,
    this.role,
    this.external_organization,
    this.patron_type,
    this.ebc,
    this.address,
  });

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  factory User.fromJson(Map<String, dynamic> json) {

    return User(
      id: json['id'] ?? 0,
      last_name: json['last_name'] ?? '',
      first_name: json['first_name'] ?? '',
      email: json['email'] ?? '',
      sex: json['sex']?.toString(),
      contact_number: json['contact_number']?.toString(),
      // profilePicture: json['profile_picture']?.toString(),
      profilePicture: json['profile_photo'] != null
          ? ProfilePhoto.fromJson(json['profile_photo'])
          : null, 
      campus: json['campus'] != null ? Campus.fromJson(json['campus']) : null,
      id_number: json['id_number']?.toString(),
      ebc: json['ebc']?.toString(),
      role: json['role'],
      patron_type: json['patron_type'],
      external_organization: json['external_organization']?.toString(),
      address: json['address'],
    );
    
  }

  Map<String, dynamic> toJson() {

    return {
      "id": id,
      "last_name": last_name,
      "first_name": first_name,
      "email": email,
      "sex": sex,
      "contact_number": contact_number,
      "profile_picture": profilePicture?.toJson(),
      "campus_id": campus?.toJson(),
      "id_number": id_number,
      "ebc": ebc,
      "role": role,
      "external_organization": external_organization,
      "patron_type": patron_type,
      "address": address
    };

  }
}

class ProfilePhoto {
  final String url;
  final String? originalName;

  ProfilePhoto({required this.url, this.originalName});

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      url: json['path'] ?? '',
      originalName: json['original_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "path": url,
      "original_name": originalName,
    };
  }
}

class Campus {
  final int? id;
  final String name;
  final String? abbrev;
  final String? address;

  Campus({
    this.id,
    required this.name,
    this.abbrev,
    this.address,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'],
      name: json['name'] ?? json['name'] ?? 'Unknown Campus',
      abbrev: json['abbrev'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "abbrev": abbrev,
      "address": address,
    };
  }
}
