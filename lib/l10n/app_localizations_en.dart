// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get help => 'Help';

  @override
  String get setting => 'Setting';

  @override
  String get network => 'Network';

  @override
  String get appearance => 'Appearance';

  @override
  String get ipAddress => 'IP Address';

  @override
  String get portNumber => 'Port Number';

  @override
  String get sendingRate => 'Sending Rate';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String expectedSendingRate(int rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rateString = rateNumberFormat.format(rate);

    return 'Expected: $rateString Hz';
  }

  @override
  String actualSendingRate(int rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rateString = rateNumberFormat.format(rate);

    return 'Actual: $rateString Hz';
  }

  @override
  String get back => 'Back';
}
