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
  String showSendingRate(int rate) {
    final intl.NumberFormat rateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String rateString = rateNumberFormat.format(rate);

    return 'レート: $rateString Hz';
  }

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

  @override
  String get backToSetting => '設定画面に戻る';

  @override
  String get errorTitle => 'エラー';

  @override
  String get udpServiceAlreadyRunningErrorMessage => '内部エラーが発生しました。アプリを再起動して再度お試しください。';

  @override
  String get ipAddressInvalidErrorMessage => '無効なIPアドレスです。設定を見直してください。';

  @override
  String get portNumberInvalidErrorMessage => '無効なポート番号です。設定を見直してください。';

  @override
  String get socketExceptionErrorMessage => 'ネットワークエラーが発生しました。設定を見直すか、アプリを再起動してください。';

  @override
  String get somethingWentWrongErrorMessage => '未知のエラーが発生しました。アプリを再起動して再度お試しください。';

  @override
  String get pcSetup => 'PC側のセットアップ';

  @override
  String get pcSetupDescription1 => 'Windowsストアで「TouchSenderタブレット」をインストール';

  @override
  String get pcSetupDescription2 => 'PCアプリと本アプリのIPアドレス・ポート番号を合わせて設定';

  @override
  String get pcSetupDescription3 => 'PCアプリと本アプリをそれぞれ開始する（順不同）';

  @override
  String get touchScreenRotation => '回転可能なタッチ画面';

  @override
  String get touchScreenRotationDescription => '画面の向きに合わせて、マウスカーソルの動く向きも自動的に変わります。';

  @override
  String get sensitivitySetting => 'マウス感度';

  @override
  String get sensitivitySettingDescription => 'PCアプリのメイン画面で、縦方向・横方向の感度を設定可能です。';

  @override
  String get sendingRateSetting => '送信レート';

  @override
  String get sendingRateSettingDescription => 'スマホのタッチサンプリングレートが高い場合は、本アプリの送信レートを上げることで、よりスムーズな入力が期待できます。';
}
