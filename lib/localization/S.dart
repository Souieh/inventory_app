import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'S_ar.dart';
import 'S_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/S.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Inventory App'**
  String get app_title;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @logged_in_as.
  ///
  /// In en, this message translates to:
  /// **'Logged in as:'**
  String get logged_in_as;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @export_excel.
  ///
  /// In en, this message translates to:
  /// **'Export Data as Excel'**
  String get export_excel;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @reset_database.
  ///
  /// In en, this message translates to:
  /// **'Reset Database'**
  String get reset_database;

  /// No description provided for @confirm_logout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirm_logout;

  /// No description provided for @logout_question.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get logout_question;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @password_updated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get password_updated;

  /// No description provided for @password_label.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get password_label;

  /// No description provided for @password_validation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 4 characters'**
  String get password_validation;

  /// No description provided for @reset_db_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data?'**
  String get reset_db_confirmation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @language_selection.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get language_selection;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Please select a language'**
  String get select_language;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_default;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @agents.
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get agents;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @addArticle.
  ///
  /// In en, this message translates to:
  /// **'Add Article'**
  String get addArticle;

  /// No description provided for @editArticle.
  ///
  /// In en, this message translates to:
  /// **'Edit Article'**
  String get editArticle;

  /// No description provided for @deleteArticle.
  ///
  /// In en, this message translates to:
  /// **'Delete Article'**
  String get deleteArticle;

  /// No description provided for @noArticlesFound.
  ///
  /// In en, this message translates to:
  /// **'No articles found'**
  String get noArticlesFound;

  /// No description provided for @addAgent.
  ///
  /// In en, this message translates to:
  /// **'Add Agent'**
  String get addAgent;

  /// No description provided for @editAgent.
  ///
  /// In en, this message translates to:
  /// **'Edit Agent'**
  String get editAgent;

  /// No description provided for @deleteAgent.
  ///
  /// In en, this message translates to:
  /// **'Delete Agent'**
  String get deleteAgent;

  /// No description provided for @noAgentsFound.
  ///
  /// In en, this message translates to:
  /// **'No agents found'**
  String get noAgentsFound;

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add Location'**
  String get addLocation;

  /// No description provided for @editLocation.
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get editLocation;

  /// No description provided for @deleteLocation.
  ///
  /// In en, this message translates to:
  /// **'Delete Location'**
  String get deleteLocation;

  /// No description provided for @noLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get noLocationsFound;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit App'**
  String get exitApp;

  /// No description provided for @exit_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exit_confirmation;

  /// No description provided for @exit_question.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exit_question;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @agent_code_required.
  ///
  /// In en, this message translates to:
  /// **'Agent Code *'**
  String get agent_code_required;

  /// No description provided for @code_required.
  ///
  /// In en, this message translates to:
  /// **'Code is required'**
  String get code_required;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @description_optional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get description_optional;

  /// No description provided for @password_required.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get password_required;

  /// No description provided for @save_agent.
  ///
  /// In en, this message translates to:
  /// **'Save Agent'**
  String get save_agent;

  /// No description provided for @agent_added_successfully.
  ///
  /// In en, this message translates to:
  /// **'Agent added successfully'**
  String get agent_added_successfully;

  /// No description provided for @failed_to_add_agent.
  ///
  /// In en, this message translates to:
  /// **'Failed to add agent'**
  String get failed_to_add_agent;

  /// No description provided for @add_article.
  ///
  /// In en, this message translates to:
  /// **'Add Article'**
  String get add_article;

  /// No description provided for @article_code.
  ///
  /// In en, this message translates to:
  /// **'Article Code'**
  String get article_code;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @location_required.
  ///
  /// In en, this message translates to:
  /// **'Location is required'**
  String get location_required;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantity_required.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get quantity_required;

  /// No description provided for @invalid_quantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get invalid_quantity;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @save_article.
  ///
  /// In en, this message translates to:
  /// **'Save Article'**
  String get save_article;

  /// No description provided for @article_exists.
  ///
  /// In en, this message translates to:
  /// **'Article already exists'**
  String get article_exists;

  /// No description provided for @article_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Article saved successfully'**
  String get article_saved_successfully;

  /// No description provided for @error_saving_article.
  ///
  /// In en, this message translates to:
  /// **'Error saving article'**
  String get error_saving_article;

  /// No description provided for @no_name.
  ///
  /// In en, this message translates to:
  /// **'(No Name)'**
  String get no_name;

  /// No description provided for @no_description.
  ///
  /// In en, this message translates to:
  /// **'(No Description)'**
  String get no_description;

  /// No description provided for @no_category.
  ///
  /// In en, this message translates to:
  /// **'(No Category)'**
  String get no_category;

  /// No description provided for @no_condition.
  ///
  /// In en, this message translates to:
  /// **'(No Condition)'**
  String get no_condition;

  /// No description provided for @no_location.
  ///
  /// In en, this message translates to:
  /// **'(No Location)'**
  String get no_location;

  /// No description provided for @unknown_agent.
  ///
  /// In en, this message translates to:
  /// **'(Unknown Agent)'**
  String get unknown_agent;

  /// No description provided for @add_location.
  ///
  /// In en, this message translates to:
  /// **'إضافة موقع'**
  String get add_location;

  /// No description provided for @location_code.
  ///
  /// In en, this message translates to:
  /// **'رمز الموقع'**
  String get location_code;

  /// No description provided for @occupation.
  ///
  /// In en, this message translates to:
  /// **'occupation'**
  String get occupation;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'type'**
  String get type;

  /// No description provided for @save_location.
  ///
  /// In en, this message translates to:
  /// **'save_location'**
  String get save_location;

  /// No description provided for @location_exists.
  ///
  /// In en, this message translates to:
  /// **'location_exists'**
  String get location_exists;

  /// No description provided for @location_saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'location_saved_successfully'**
  String get location_saved_successfully;

  /// No description provided for @error_saving_location.
  ///
  /// In en, this message translates to:
  /// **'error_saving_location'**
  String get error_saving_location;

  /// No description provided for @no_type.
  ///
  /// In en, this message translates to:
  /// **'(No Type)'**
  String get no_type;

  /// No description provided for @no_occupation.
  ///
  /// In en, this message translates to:
  /// **'(No Occupation)'**
  String get no_occupation;

  /// No description provided for @location_saved.
  ///
  /// In en, this message translates to:
  /// **'Location saved successfully'**
  String get location_saved;

  /// No description provided for @create_first_user.
  ///
  /// In en, this message translates to:
  /// **'Create First User'**
  String get create_first_user;

  /// No description provided for @user_code.
  ///
  /// In en, this message translates to:
  /// **'User Code'**
  String get user_code;

  /// No description provided for @please_enter_user_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter user code'**
  String get please_enter_user_code;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @please_enter_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get please_enter_password;

  /// No description provided for @create_user.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get create_user;

  /// No description provided for @user_created_success.
  ///
  /// In en, this message translates to:
  /// **'User created successfully!'**
  String get user_created_success;

  /// No description provided for @error_creating_user.
  ///
  /// In en, this message translates to:
  /// **'Error creating user: {error}'**
  String error_creating_user(Object error);

  /// No description provided for @user_auth.
  ///
  /// In en, this message translates to:
  /// **'User Authentication'**
  String get user_auth;

  /// No description provided for @password_optional.
  ///
  /// In en, this message translates to:
  /// **'Password (if required)'**
  String get password_optional;

  /// No description provided for @please_enter_your_code.
  ///
  /// In en, this message translates to:
  /// **'Please enter your user code'**
  String get please_enter_your_code;

  /// No description provided for @please_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_your_password;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get user_not_found;

  /// No description provided for @incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrect_password;

  /// No description provided for @welcome_user.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {code}'**
  String welcome_user(Object code);

  /// No description provided for @reset_db.
  ///
  /// In en, this message translates to:
  /// **'Reset Database'**
  String get reset_db;

  /// No description provided for @reset_db_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data?'**
  String get reset_db_confirm;

  /// No description provided for @db_reset_success.
  ///
  /// In en, this message translates to:
  /// **'Database reset successfully'**
  String get db_reset_success;

  /// No description provided for @useDummyData.
  ///
  /// In en, this message translates to:
  /// **'Use Dummy Data'**
  String get useDummyData;

  /// No description provided for @dummy_data_added.
  ///
  /// In en, this message translates to:
  /// **'Dummy data added successfully'**
  String get dummy_data_added;

  /// No description provided for @failed_to_add_dummy_data.
  ///
  /// In en, this message translates to:
  /// **'Failed to add dummy data'**
  String get failed_to_add_dummy_data;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Inventory App'**
  String get app_name;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developed_by.
  ///
  /// In en, this message translates to:
  /// **'Developed by'**
  String get developed_by;

  /// No description provided for @disable_dev_mode.
  ///
  /// In en, this message translates to:
  /// **'Disable Developer Mode'**
  String get disable_dev_mode;

  /// No description provided for @change_dev_passkey.
  ///
  /// In en, this message translates to:
  /// **'Change Developer Passkey'**
  String get change_dev_passkey;

  /// No description provided for @dev_mode.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get dev_mode;

  /// No description provided for @dev_mode_disabled.
  ///
  /// In en, this message translates to:
  /// **'Developer mode disabled'**
  String get dev_mode_disabled;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @disable_dev_mode_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to disable developer mode? This action cannot be undone.'**
  String get disable_dev_mode_confirm;

  /// No description provided for @passkey_changed_success.
  ///
  /// In en, this message translates to:
  /// **'Passkey changed successfully'**
  String get passkey_changed_success;

  /// No description provided for @passkey_validation.
  ///
  /// In en, this message translates to:
  /// **'Passkey is required'**
  String get passkey_validation;

  /// No description provided for @new_passkey.
  ///
  /// In en, this message translates to:
  /// **'New Passkey'**
  String get new_passkey;

  /// No description provided for @articlesStatus.
  ///
  /// In en, this message translates to:
  /// **'Articles Status'**
  String get articlesStatus;

  /// No description provided for @articlesStatusChart.
  ///
  /// In en, this message translates to:
  /// **'Articles Status Chart'**
  String get articlesStatusChart;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
