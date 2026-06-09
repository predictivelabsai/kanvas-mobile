class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String country;
  final String city;
  final String currency;
  final String language;
  final List<String> preferredMediums;
  final List<String> preferredPeriods;
  final bool notifyWeeklyDigest;

  const UserProfile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.country = '',
    this.city = '',
    this.currency = 'EUR',
    this.language = 'en',
    this.preferredMediums = const [],
    this.preferredPeriods = const [],
    this.notifyWeeklyDigest = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    country: json['country'] as String? ?? '',
    city: json['city'] as String? ?? '',
    currency: json['currency'] as String? ?? 'EUR',
    language: json['language'] as String? ?? 'en',
    preferredMediums:
        (json['preferred_mediums'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    preferredPeriods:
        (json['preferred_periods'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        const [],
    notifyWeeklyDigest: json['notify_weekly_digest'] as bool? ?? false,
  );
}

class UpdateProfileRequest {
  final String? name;
  final String? phone;
  final String? country;
  final String? city;
  final String? currency;
  final String? language;
  final List<String>? preferredMediums;
  final List<String>? preferredPeriods;
  final bool? notifyWeeklyDigest;

  const UpdateProfileRequest({
    this.name,
    this.phone,
    this.country,
    this.city,
    this.currency,
    this.language,
    this.preferredMediums,
    this.preferredPeriods,
    this.notifyWeeklyDigest,
  });

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (phone != null) 'phone': phone,
    if (country != null) 'country': country,
    if (city != null) 'city': city,
    if (currency != null) 'currency': currency,
    if (language != null) 'language': language,
    if (preferredMediums != null) 'preferred_mediums': preferredMediums,
    if (preferredPeriods != null) 'preferred_periods': preferredPeriods,
    if (notifyWeeklyDigest != null) 'notify_weekly_digest': notifyWeeklyDigest,
  };
}
