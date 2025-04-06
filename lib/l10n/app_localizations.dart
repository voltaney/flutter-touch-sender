import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @ipAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get ipAddress;

  /// No description provided for @portNumber.
  ///
  /// In en, this message translates to:
  /// **'Port Number'**
  String get portNumber;

  /// No description provided for @sendingRate.
  ///
  /// In en, this message translates to:
  /// **'Sending Rate'**
  String get sendingRate;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @showSendingRate.
  ///
  /// In en, this message translates to:
  /// **'Rate: {rate} Hz'**
  String showSendingRate(int rate);

  /// No description provided for @expectedSendingRate.
  ///
  /// In en, this message translates to:
  /// **'Expected: {rate} Hz'**
  String expectedSendingRate(int rate);

  /// No description provided for @actualSendingRate.
  ///
  /// In en, this message translates to:
  /// **'Actual: {rate} Hz'**
  String actualSendingRate(int rate);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backToSetting.
  ///
  /// In en, this message translates to:
  /// **'Back to Setting'**
  String get backToSetting;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @udpServiceAlreadyRunningErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again or restart the app.'**
  String get udpServiceAlreadyRunningErrorMessage;

  /// No description provided for @ipAddressInvalidErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid IP address. Please check your settings.'**
  String get ipAddressInvalidErrorMessage;

  /// No description provided for @portNumberInvalidErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid port number. Please check your settings.'**
  String get portNumberInvalidErrorMessage;

  /// No description provided for @socketExceptionErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your settings or restart the app.'**
  String get socketExceptionErrorMessage;

  /// No description provided for @somethingWentWrongErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unknown error. Please try again or restart the app.'**
  String get somethingWentWrongErrorMessage;

  /// No description provided for @pcSetup.
  ///
  /// In en, this message translates to:
  /// **'PC Setup'**
  String get pcSetup;

  /// No description provided for @pcSetupDescription1.
  ///
  /// In en, this message translates to:
  /// **'Install \"TouchSenderTablet\" from GitHub'**
  String get pcSetupDescription1;

  /// No description provided for @pcSetupDescription2.
  ///
  /// In en, this message translates to:
  /// **'Set the same IP address and port number for both the PC app and this app'**
  String get pcSetupDescription2;

  /// No description provided for @pcSetupDescription3.
  ///
  /// In en, this message translates to:
  /// **'Start both the PC app and this app (order does not matter)'**
  String get pcSetupDescription3;

  /// No description provided for @pcSetupGitHubLink.
  ///
  /// In en, this message translates to:
  /// **'TouchSenderTablet'**
  String get pcSetupGitHubLink;

  /// No description provided for @touchScreenRotation.
  ///
  /// In en, this message translates to:
  /// **'Rotatable touch screen'**
  String get touchScreenRotation;

  /// No description provided for @touchScreenRotationDescription.
  ///
  /// In en, this message translates to:
  /// **'The direction of the mouse movement will automatically change according to the orientation of the screen.'**
  String get touchScreenRotationDescription;

  /// No description provided for @sensitivitySetting.
  ///
  /// In en, this message translates to:
  /// **'Mouse sensitivity'**
  String get sensitivitySetting;

  /// No description provided for @sensitivitySettingDescription.
  ///
  /// In en, this message translates to:
  /// **'You can set mouse sensitivities on the main screen of the PC app.'**
  String get sensitivitySettingDescription;

  /// No description provided for @sendingRateSetting.
  ///
  /// In en, this message translates to:
  /// **'Sending rate'**
  String get sendingRateSetting;

  /// No description provided for @sendingRateSettingDescription.
  ///
  /// In en, this message translates to:
  /// **'If your mobile device has a high touch sampling rate, increasing the app\'s sending rate can provide a smoother input experience.'**
  String get sendingRateSettingDescription;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
