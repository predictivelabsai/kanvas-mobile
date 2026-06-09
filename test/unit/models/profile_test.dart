import 'package:flutter_test/flutter_test.dart';
import 'package:kanvas/models/profile.dart';

void main() {
  group('UserProfile', () {
    test('fromJson parses full profile', () {
      final json = {
        'name': 'Julian',
        'email': 'julian@test.com',
        'phone': '+372555',
        'country': 'Estonia',
        'city': 'Tallinn',
        'currency': 'EUR',
        'language': 'et',
        'preferred_mediums': ['Oil on canvas', 'Watercolor'],
        'preferred_periods': ['Contemporary', 'Modern'],
        'notify_weekly_digest': true,
      };

      final p = UserProfile.fromJson(json);

      expect(p.name, 'Julian');
      expect(p.email, 'julian@test.com');
      expect(p.phone, '+372555');
      expect(p.country, 'Estonia');
      expect(p.city, 'Tallinn');
      expect(p.currency, 'EUR');
      expect(p.language, 'et');
      expect(p.preferredMediums, ['Oil on canvas', 'Watercolor']);
      expect(p.preferredPeriods, ['Contemporary', 'Modern']);
      expect(p.notifyWeeklyDigest, true);
    });

    test('fromJson handles empty/null values', () {
      final p = UserProfile.fromJson({});

      expect(p.name, '');
      expect(p.email, '');
      expect(p.currency, 'EUR');
      expect(p.language, 'en');
      expect(p.preferredMediums, isEmpty);
      expect(p.preferredPeriods, isEmpty);
      expect(p.notifyWeeklyDigest, false);
    });
  });

  group('UpdateProfileRequest', () {
    test('toJson includes only non-null fields', () {
      const req = UpdateProfileRequest(
        name: 'Julian',
        language: 'et',
        preferredMediums: ['Oil on canvas'],
      );

      final json = req.toJson();

      expect(json['name'], 'Julian');
      expect(json['language'], 'et');
      expect(json['preferred_mediums'], ['Oil on canvas']);
      expect(json.containsKey('phone'), false);
      expect(json.containsKey('country'), false);
    });

    test('toJson returns empty map when all null', () {
      const req = UpdateProfileRequest();
      final json = req.toJson();
      expect(json, isEmpty);
    });

    test('toJson includes notification settings', () {
      const req = UpdateProfileRequest(notifyWeeklyDigest: true);

      final json = req.toJson();

      expect(json['notify_weekly_digest'], true);
    });
  });
}
