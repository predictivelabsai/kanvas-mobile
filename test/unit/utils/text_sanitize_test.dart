import 'package:flutter_test/flutter_test.dart';
import 'package:kanvas/utils/text_sanitize.dart';

void main() {
  group('stripLeadingSql', () {
    test('strips a leading SELECT with ILIKE ending', () {
      const input =
          "SELECT COUNT(*) AS lots_sold, SUM(price) FROM kanvas.auction_lots "
          "al JOIN kanvas.artworks a ON a.id = al.artwork_id "
          "WHERE a.artist_name ILIKE '%Adamson-Eric%'Adamson-Eric was a leading "
          "Estonian modernist painter.";
      final out = stripLeadingSql(input);
      expect(out, startsWith('Adamson-Eric was a leading'));
      expect(out.toUpperCase(), isNot(contains('SELECT ')));
    });

    test('strips a leading SELECT ending in LIMIT', () {
      const input =
          'SELECT author, total_sales FROM kanvas.auction_lots ORDER BY '
          'total_sales DESC LIMIT 10 Here are the top artists by sales.';
      final out = stripLeadingSql(input);
      expect(out, startsWith('Here are the top artists'));
    });

    test('leaves ordinary prose untouched', () {
      const input = 'Konrad Mägi was an Estonian painter known for landscapes.';
      expect(stripLeadingSql(input), input);
    });

    test('does not strip prose that merely starts with the word Select', () {
      const input = 'Select works by this artist appear at auction each year.';
      expect(stripLeadingSql(input), input);
    });

    test('ignores SELECT without a kanvas schema reference', () {
      const input = "SELECT a winner from the shortlist of nominees.";
      expect(stripLeadingSql(input), input);
    });
  });

  group('friendlyError', () {
    test('hides SQL / DB errors', () {
      const raw =
          '(psycopg2.errors.UndefinedTable) relation "kanvas.artists" does '
          'not exist\nLINE 1: SELECT a.name FROM kanvas.artists...';
      final out = friendlyError(raw);
      expect(out, isNot(contains('SELECT')));
      expect(out, isNot(contains('psycopg')));
      expect(out.toLowerCase(), contains('rephrasing'));
    });

    test('passes through a short, safe message', () {
      const raw = 'Network timeout';
      expect(friendlyError(raw), raw);
    });

    test('replaces overly long opaque messages', () {
      final raw = 'x' * 400;
      expect(friendlyError(raw), 'Something went wrong. Please try again.');
    });
  });
}
