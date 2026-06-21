/// The exchange type of a listing.
enum ExchangeType { skillSwap, paidGig, free }

extension ExchangeTypeLabel on ExchangeType {
  String get label {
    switch (this) {
      case ExchangeType.skillSwap:
        return 'Skill Swap';
      case ExchangeType.paidGig:
        return 'Paid Gig';
      case ExchangeType.free:
        return 'Free Help';
    }
  }
}

/// Represents a single skill / freelance listing posted by a user.
///
/// This is the central entity of the app: a person posts what they can
/// do (e.g. "Guitar Lessons"), how they want to be compensated
/// (money, a swapped skill, or simply helping the community for free),
/// and other users can browse, search and request it.
class SkillModel {
  final String id;
  final String userId;
  String title;
  String category;
  String description;
  ExchangeType type;
  double? price; // used when type == paidGig
  String? wantedInExchange; // used when type == skillSwap
  String location;
  DateTime postedDate;
  String imageSeed; // used to deterministically pick a placeholder image/icon
  double rating;
  int completedCount;

  SkillModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.description,
    required this.type,
    this.price,
    this.wantedInExchange,
    required this.location,
    DateTime? postedDate,
    String? imageSeed,
    this.rating = 4.5,
    this.completedCount = 0,
  })  : postedDate = postedDate ?? DateTime.now(),
        imageSeed = imageSeed ?? title;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'category': category,
        'description': description,
        'type': type.name,
        'price': price,
        'wantedInExchange': wantedInExchange,
        'location': location,
        'postedDate': postedDate.toIso8601String(),
        'imageSeed': imageSeed,
        'rating': rating,
        'completedCount': completedCount,
      };

  factory SkillModel.fromJson(Map<String, dynamic> json) => SkillModel(
        id: json['id'],
        userId: json['userId'],
        title: json['title'],
        category: json['category'],
        description: json['description'],
        type: ExchangeType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ExchangeType.skillSwap,
        ),
        price: json['price'] == null ? null : (json['price']).toDouble(),
        wantedInExchange: json['wantedInExchange'],
        location: json['location'],
        postedDate: DateTime.tryParse(json['postedDate'] ?? '') ?? DateTime.now(),
        imageSeed: json['imageSeed'] ?? json['title'],
        rating: (json['rating'] ?? 4.5).toDouble(),
        completedCount: json['completedCount'] ?? 0,
      );
}
