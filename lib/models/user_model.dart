class User {
  final int id;
  final String name;
  final String email;
  final String? sex;
  final ProfilePhoto? profilePicture;
  final Campus? campus;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.sex,
    this.profilePicture,
    this.campus,
  });

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      sex: json['sex']?.toString(),
      profilePicture: json['profile_picture'] != null
          ? ProfilePhoto.fromJson(json['profile_picture'])
          : null,
      campus: json['campus'] != null
          ? Campus.fromJson(json['campus'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "sex": sex,
      "profile_picture": profilePicture?.toJson(),
      "campus": campus?.toJson(),
    };
  }
}

class ProfilePhoto {
  final String url;
  final String? originalName;

  ProfilePhoto({required this.url, this.originalName});

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      url: json['url'],
      originalName: json['original_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "original_name": originalName,
    };
  }
}

class Campus {
  final int id;
  final String campus;
  final String abbrev;
  final String address;

  Campus({
    required this.id,
    required this.campus,
    required this.abbrev,
    required this.address,
  });

  factory Campus.fromJson(Map<String, dynamic> json) {
    return Campus(
      id: json['id'],
      campus: json['campus'],
      abbrev: json['abbrev'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "campus": campus,
      "abbrev": abbrev,
      "address": address,
    };
  }
}
