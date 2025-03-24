// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get help => 'ヘルプ';

  @override
  String get setting => '設定';

  @override
  String get network => 'ネットワーク';

  @override
  String get appearance => '外観';

  @override
  String get ipAddress => 'IPアドレス';

  @override
  String get portNumber => 'ポート番号';

  @override
  String get sendingRate => '送信レート';

  @override
  String get darkMode => 'ダークモード';

  @override
  String expectedSendingRate(int rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rateString = rateNumberFormat.format(rate);

    return '期待値: $rateString Hz';
  }

  @override
  String actualSendingRate(int rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rateString = rateNumberFormat.format(rate);

    return '現在値: $rateString Hz';
  }

  @override
  String get back => '戻る';
}
