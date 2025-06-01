// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'S.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Inventory App';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get welcome => 'Welcome';

  @override
  String get user => 'User';

  @override
  String get logged_in_as => 'Logged in as:';

  @override
  String get change_password => 'Change Password';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get data => 'Data';

  @override
  String get export_excel => 'Export Data as Excel';

  @override
  String get admin => 'Admin';

  @override
  String get reset_database => 'Reset Database';

  @override
  String get confirm_logout => 'Confirm Logout';

  @override
  String get logout_question => 'Do you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get password_updated => 'Password updated';

  @override
  String get password_label => 'New Password';

  @override
  String get password_validation => 'Password must be at least 4 characters';

  @override
  String get reset_db_confirmation =>
      'Are you sure you want to delete all data?';

  @override
  String get reset => 'Reset';

  @override
  String get language => 'Language';

  @override
  String get language_selection => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get select_language => 'Please select a language';

  @override
  String get system_default => 'System Default';

  @override
  String get articles => 'Articles';

  @override
  String get locations => 'Locations';

  @override
  String get agents => 'Agents';

  @override
  String get inventory => 'Inventory';

  @override
  String get addArticle => 'Add Article';

  @override
  String get editArticle => 'Edit Article';

  @override
  String get deleteArticle => 'Delete Article';

  @override
  String get noArticlesFound => 'No articles found';

  @override
  String get addAgent => 'Add Agent';

  @override
  String get editAgent => 'Edit Agent';

  @override
  String get deleteAgent => 'Delete Agent';

  @override
  String get noAgentsFound => 'No agents found';

  @override
  String get addLocation => 'Add Location';

  @override
  String get editLocation => 'Edit Location';

  @override
  String get deleteLocation => 'Delete Location';

  @override
  String get noLocationsFound => 'No locations found';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get exit => 'Exit';

  @override
  String get exitApp => 'Exit App';

  @override
  String get exit_confirmation => 'Are you sure you want to exit the app?';

  @override
  String get exit_question => 'Do you want to exit the app?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get error => 'Error';

  @override
  String get stay => 'Stay';

  @override
  String get agent_code_required => 'Agent Code *';

  @override
  String get code_required => 'Code is required';

  @override
  String get name => 'Name';

  @override
  String get description_optional => 'Description (optional)';

  @override
  String get password_required => 'Password *';

  @override
  String get save_agent => 'Save Agent';

  @override
  String get agent_added_successfully => 'Agent added successfully';

  @override
  String get failed_to_add_agent => 'Failed to add agent';

  @override
  String get add_article => 'Add Article';

  @override
  String get article_code => 'Article Code';

  @override
  String get location => 'Location';

  @override
  String get location_required => 'Location is required';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantity_required => 'Quantity is required';

  @override
  String get invalid_quantity => 'Enter a valid quantity';

  @override
  String get condition => 'Condition';

  @override
  String get category => 'Category';

  @override
  String get description => 'Description';

  @override
  String get optional => 'optional';

  @override
  String get required => 'Required';

  @override
  String get save_article => 'Save Article';

  @override
  String get article_exists => 'Article already exists';

  @override
  String get article_saved_successfully => 'Article saved successfully';

  @override
  String get error_saving_article => 'Error saving article';

  @override
  String get no_name => '(No Name)';

  @override
  String get no_description => '(No Description)';

  @override
  String get no_category => '(No Category)';

  @override
  String get no_condition => '(No Condition)';

  @override
  String get no_location => '(No Location)';

  @override
  String get unknown_agent => '(Unknown Agent)';

  @override
  String get add_location => 'إضافة موقع';

  @override
  String get location_code => 'رمز الموقع';

  @override
  String get occupation => 'occupation';

  @override
  String get type => 'type';

  @override
  String get save_location => 'save_location';

  @override
  String get location_exists => 'location_exists';

  @override
  String get location_saved_successfully => 'location_saved_successfully';

  @override
  String get error_saving_location => 'error_saving_location';

  @override
  String get no_type => '(No Type)';

  @override
  String get no_occupation => '(No Occupation)';

  @override
  String get location_saved => 'Location saved successfully';

  @override
  String get create_first_user => 'Create First User';

  @override
  String get user_code => 'User Code';

  @override
  String get please_enter_user_code => 'Please enter user code';

  @override
  String get password => 'Password';

  @override
  String get please_enter_password => 'Please enter password';

  @override
  String get create_user => 'Create User';

  @override
  String get user_created_success => 'User created successfully!';

  @override
  String error_creating_user(Object error) {
    return 'Error creating user: $error';
  }

  @override
  String get user_auth => 'User Authentication';

  @override
  String get password_optional => 'Password (if required)';

  @override
  String get please_enter_your_code => 'Please enter your user code';

  @override
  String get please_enter_your_password => 'Please enter your password';

  @override
  String get user_not_found => 'User not found';

  @override
  String get incorrect_password => 'Incorrect password';

  @override
  String welcome_user(Object code) {
    return 'Welcome, $code';
  }

  @override
  String get reset_db => 'Reset Database';

  @override
  String get reset_db_confirm => 'Are you sure you want to delete all data?';

  @override
  String get db_reset_success => 'Database reset successfully';

  @override
  String get useDummyData => 'Use Dummy Data';

  @override
  String get dummy_data_added => 'Dummy data added successfully';

  @override
  String get failed_to_add_dummy_data => 'Failed to add dummy data';

  @override
  String get about => 'About';

  @override
  String get app_name => 'Inventory App';

  @override
  String get version => 'Version';

  @override
  String get developed_by => 'Developed by';

  @override
  String get disable_dev_mode => 'Disable Developer Mode';

  @override
  String get change_dev_passkey => 'Change Developer Passkey';

  @override
  String get dev_mode => 'Developer Mode';

  @override
  String get dev_mode_disabled => 'Developer mode disabled';

  @override
  String get disable => 'Disable';

  @override
  String get disable_dev_mode_confirm =>
      'Are you sure you want to disable developer mode? This action cannot be undone.';

  @override
  String get passkey_changed_success => 'Passkey changed successfully';

  @override
  String get passkey_validation => 'Passkey is required';

  @override
  String get new_passkey => 'New Passkey';

  @override
  String get articlesStatus => 'Articles Status';

  @override
  String get articlesStatusChart => 'Articles Status Chart';
}
