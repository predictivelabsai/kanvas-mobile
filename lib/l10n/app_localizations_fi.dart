// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class L10nFi extends L10n {
  L10nFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Kanvas';

  @override
  String get heroTitle => 'Tekoäly-taideneuvonantajasi.';

  @override
  String get heroSubtitle =>
      'Research artists, track auctions, and value artworks across the Baltic and Nordic markets.';

  @override
  String get signIn => 'Kirjaudu';

  @override
  String get signOut => 'Kirjaudu ulos';

  @override
  String get register => 'Rekisteröidy';

  @override
  String get createAccount => 'Luo tili';

  @override
  String get forgotPassword => 'Unohditko salasanan?';

  @override
  String get email => 'Sähköposti';

  @override
  String get password => 'Salasana';

  @override
  String get name => 'Nimi';

  @override
  String get or => 'tai';

  @override
  String get signInWithGoogle => 'Kirjaudu Googlella';

  @override
  String get dontHaveAccount => 'Ei tiliä?';

  @override
  String get alreadyHaveAccount => 'Onko jo tili?';

  @override
  String get sendResetLink => 'Lähetä palautuslinkki';

  @override
  String get backToSignIn => 'Takaisin kirjautumiseen';

  @override
  String get newChat => 'Uusi keskustelu';

  @override
  String get chatPlaceholder => 'Ask about an artist, artwork, or market...';

  @override
  String get chatWelcomeTitle => 'Kanvas AI-neuvoja';

  @override
  String get chatWelcomeBody =>
      'Kysy automalleista, markkinatrendeistä, arvioista tai ostoneuvoja.';

  @override
  String get thinking => 'Miettii';

  @override
  String get calling => 'Kutsuu';

  @override
  String get done => 'Valmis';

  @override
  String get results => 'Tulokset';

  @override
  String get share => 'Jaa';

  @override
  String get copy => 'Kopioi';

  @override
  String get copied => 'Kopioitu!';

  @override
  String get profile => 'Profiili ja asetukset';

  @override
  String get account => 'Tili';

  @override
  String get artPreferences => 'Art Preferences';

  @override
  String get notifications => 'Ilmoitukset';

  @override
  String get save => 'Tallenna';

  @override
  String get saved => 'Tallennettu!';

  @override
  String get delete => 'Poista';

  @override
  String get cancel => 'Peruuta';

  @override
  String get confirm => 'Vahvista';

  @override
  String get error => 'Virhe';

  @override
  String get retry => 'Yritä uudelleen';

  @override
  String get loading => 'Ladataan...';

  @override
  String get noData => 'Ei tietoja saatavilla';

  @override
  String get about => 'Tietoa';

  @override
  String get contact => 'Yhteystiedot';

  @override
  String get sendMessage => 'Lähetä viesti';

  @override
  String get learnMore => 'Learn More';

  @override
  String get aiAgents => 'AI Agents';

  @override
  String get artists => 'Artists';

  @override
  String get countries => 'Maat';

  @override
  String get auctionHouses => 'Auction Houses';

  @override
  String get preferredMediums => 'Preferred Mediums';

  @override
  String get preferredPeriods => 'Preferred Periods';

  @override
  String get weeklyDigestNotify => 'Viikoittainen markkinakatsaus';
}
