/// Represents a registered user of the SkillBridge platform.
///
/// A user can both OFFER skills (as a provider) and REQUEST skills
/// (as a seeker), which is the core idea behind the local skill
/// exchange concept.
class UserModel {
  final String id;
  String name;
  String email;
  String password; // NOTE: stored as plain text only for demo/mock purposes.
  String location;
  String bio;
  String avatarColorHex; // used to generate a colored avatar placeholder
  double rating; // average rating out of 5
  int ratingCount;
  List<String> skillsOffered;
  List<String> favoriteListingIds;
  DateTime joinedDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.location = 'Rawalpindi, Pakistan',
    this.bio = 'New to SkillBridge \u2014 excited to learn and share skills!',
    this.avatarColorHex = '#6C5CE7',
    this.rating = 0.0,
    this.ratingCount = 0,
    List<String>? skillsOffered,
    List<String>? favoriteListingIds,
    DateTime? joinedDate,
  })  : skillsOffered = skillsOffered ?? [],
        favoriteListingIds = favoriteListingIds ?? [],
        joinedDate = joinedDate ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'location': location,
        'bio': bio,
        'avatarColorHex': avatarColorHex,
        'rating': rating,
        'ratingCount': ratingCount,
        'skillsOffered': skillsOffered,
        'favoriteListingIds': favoriteListingIds,
        'joinedDate': joinedDate.toIso8601String(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        location: json['location'] ?? 'Rawalpindi, Pakistan',
        bio: json['bio'] ?? '',
        avatarColorHex: json['avatarColorHex'] ?? '#6C5CE7',
        rating: (json['rating'] ?? 0.0).toDouble(),
        ratingCount: json['ratingCount'] ?? 0,
        skillsOffered: List<String>.from(json['skillsOffered'] ?? []),
        favoriteListingIds: List<String>.from(json['favoriteListingIds'] ?? []),
        joinedDate: DateTime.tryParse(json['joinedDate'] ?? '') ?? DateTime.now(),
      );
}
