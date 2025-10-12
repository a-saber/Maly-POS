// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Email is required`
  String get emailisrequired {
    return Intl.message(
      'Email is required',
      name: 'emailisrequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get enteravalidemail {
    return Intl.message(
      'Enter a valid email',
      name: 'enteravalidemail',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phonenumberisrequired {
    return Intl.message(
      'Phone number is required',
      name: 'phonenumberisrequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number`
  String get enteravalidphonenumber {
    return Intl.message(
      'Enter a valid phone number',
      name: 'enteravalidphonenumber',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordisrequired {
    return Intl.message(
      'Password is required',
      name: 'passwordisrequired',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least`
  String get passwordmustbeatleast {
    return Intl.message(
      'Password must be at least',
      name: 'passwordmustbeatleast',
      desc: '',
      args: [],
    );
  }

  /// `characters`
  String get characters {
    return Intl.message('characters', name: 'characters', desc: '', args: []);
  }

  /// `email`
  String get email {
    return Intl.message('email', name: 'email', desc: '', args: []);
  }

  /// `password`
  String get password {
    return Intl.message('password', name: 'password', desc: '', args: []);
  }

  /// `login`
  String get login {
    return Intl.message('login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get donTHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'donTHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get register {
    return Intl.message('register', name: 'register', desc: '', args: []);
  }

  /// `Login Success`
  String get loginSuccess {
    return Intl.message(
      'Login Success',
      name: 'loginSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Field`
  String get field {
    return Intl.message('Field', name: 'field', desc: '', args: []);
  }

  /// `is required`
  String get isrequired {
    return Intl.message('is required', name: 'isrequired', desc: '', args: []);
  }

  /// `name`
  String get name {
    return Intl.message('name', name: 'name', desc: '', args: []);
  }

  /// `Phone`
  String get phone {
    return Intl.message('Phone', name: 'phone', desc: '', args: []);
  }

  /// `address`
  String get address {
    return Intl.message('address', name: 'address', desc: '', args: []);
  }

  /// `confirm password`
  String get confirmPassword {
    return Intl.message(
      'confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password not match`
  String get passowrdnotmatch {
    return Intl.message(
      'Password not match',
      name: 'passowrdnotmatch',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register Success`
  String get registerSuccess {
    return Intl.message(
      'Register Success',
      name: 'registerSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure want to delete?`
  String get areYouSureWantToDelete {
    return Intl.message(
      'Are you sure want to delete?',
      name: 'areYouSureWantToDelete',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message('cancel', name: 'cancel', desc: '', args: []);
  }

  /// `delete`
  String get delete {
    return Intl.message('delete', name: 'delete', desc: '', args: []);
  }

  /// `Deleted Successs`
  String get deletedSuccess {
    return Intl.message(
      'Deleted Successs',
      name: 'deletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Sure want to log out?`
  String get sureWannaLogOut {
    return Intl.message(
      'Sure want to log out?',
      name: 'sureWannaLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Selling Point`
  String get sellingPoint {
    return Intl.message(
      'Selling Point',
      name: 'sellingPoint',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Users`
  String get users {
    return Intl.message('Users', name: 'users', desc: '', args: []);
  }

  /// `Permissions`
  String get permissions {
    return Intl.message('Permissions', name: 'permissions', desc: '', args: []);
  }

  /// `Clients`
  String get clients {
    return Intl.message('Clients', name: 'clients', desc: '', args: []);
  }

  /// `Suppliers`
  String get suppliers {
    return Intl.message('Suppliers', name: 'suppliers', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `English`
  String get English {
    return Intl.message('English', name: 'English', desc: '', args: []);
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message('Arabic', name: 'Arabic', desc: '', args: []);
  }

  /// `Delete Category`
  String get deleteCategory {
    return Intl.message(
      'Delete Category',
      name: 'deleteCategory',
      desc: '',
      args: [],
    );
  }

  /// `refresh`
  String get refresh {
    return Intl.message('refresh', name: 'refresh', desc: '', args: []);
  }

  /// `description`
  String get description {
    return Intl.message('description', name: 'description', desc: '', args: []);
  }

  /// `edit`
  String get edit {
    return Intl.message('edit', name: 'edit', desc: '', args: []);
  }

  /// `add`
  String get add {
    return Intl.message('add', name: 'add', desc: '', args: []);
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `Add Category`
  String get addCategory {
    return Intl.message(
      'Add Category',
      name: 'addCategory',
      desc: '',
      args: [],
    );
  }

  /// `Added Success`
  String get addedSuccess {
    return Intl.message(
      'Added Success',
      name: 'addedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `You don't have data`
  String get youHaveNoData {
    return Intl.message(
      'You don\'t have data',
      name: 'youHaveNoData',
      desc: '',
      args: [],
    );
  }

  /// `Delete User`
  String get deleteUser {
    return Intl.message('Delete User', name: 'deleteUser', desc: '', args: []);
  }

  /// `Add User`
  String get addUser {
    return Intl.message('Add User', name: 'addUser', desc: '', args: []);
  }

  /// `Edit User`
  String get editUser {
    return Intl.message('Edit User', name: 'editUser', desc: '', args: []);
  }

  /// `Updated Success`
  String get updatedSuccess {
    return Intl.message(
      'Updated Success',
      name: 'updatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete Permission`
  String get deletePermission {
    return Intl.message(
      'Delete Permission',
      name: 'deletePermission',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Add Permission`
  String get addPermission {
    return Intl.message(
      'Add Permission',
      name: 'addPermission',
      desc: '',
      args: [],
    );
  }

  /// `Edit Permission`
  String get editPermission {
    return Intl.message(
      'Edit Permission',
      name: 'editPermission',
      desc: '',
      args: [],
    );
  }

  /// `Delete Client`
  String get deleteClient {
    return Intl.message(
      'Delete Client',
      name: 'deleteClient',
      desc: '',
      args: [],
    );
  }

  /// `Add Client`
  String get addClient {
    return Intl.message('Add Client', name: 'addClient', desc: '', args: []);
  }

  /// `Commercial Register`
  String get commercialRegister {
    return Intl.message(
      'Commercial Register',
      name: 'commercialRegister',
      desc: '',
      args: [],
    );
  }

  /// `Tax Identification Number`
  String get taxIdentificationNumber {
    return Intl.message(
      'Tax Identification Number',
      name: 'taxIdentificationNumber',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message('Note', name: 'note', desc: '', args: []);
  }

  /// `Edit Client`
  String get editClient {
    return Intl.message('Edit Client', name: 'editClient', desc: '', args: []);
  }

  /// `Delete Supplier`
  String get deleteSupplier {
    return Intl.message(
      'Delete Supplier',
      name: 'deleteSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Add Supplier`
  String get addSupplier {
    return Intl.message(
      'Add Supplier',
      name: 'addSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Edit Supplier`
  String get editSupplier {
    return Intl.message(
      'Edit Supplier',
      name: 'editSupplier',
      desc: '',
      args: [],
    );
  }

  /// `Units`
  String get units {
    return Intl.message('Units', name: 'units', desc: '', args: []);
  }

  /// `Delete Unit`
  String get deleteUnit {
    return Intl.message('Delete Unit', name: 'deleteUnit', desc: '', args: []);
  }

  /// `Add Unit`
  String get addUnit {
    return Intl.message('Add Unit', name: 'addUnit', desc: '', args: []);
  }

  /// `Edit Unit`
  String get editUnit {
    return Intl.message('Edit Unit', name: 'editUnit', desc: '', args: []);
  }

  /// `Branches`
  String get branches {
    return Intl.message('Branches', name: 'branches', desc: '', args: []);
  }

  /// `Delete Branch`
  String get deleteBranch {
    return Intl.message(
      'Delete Branch',
      name: 'deleteBranch',
      desc: '',
      args: [],
    );
  }

  /// `Add Branch`
  String get addBranch {
    return Intl.message('Add Branch', name: 'addBranch', desc: '', args: []);
  }

  /// `Edit Branch`
  String get editBranch {
    return Intl.message('Edit Branch', name: 'editBranch', desc: '', args: []);
  }

  /// `Delete Product`
  String get deleteProduct {
    return Intl.message(
      'Delete Product',
      name: 'deleteProduct',
      desc: '',
      args: [],
    );
  }

  /// `Add Product`
  String get addProduct {
    return Intl.message('Add Product', name: 'addProduct', desc: '', args: []);
  }

  /// `Edit Product`
  String get editProduct {
    return Intl.message(
      'Edit Product',
      name: 'editProduct',
      desc: '',
      args: [],
    );
  }

  /// `Price Per Unit`
  String get pricePerUnit {
    return Intl.message(
      'Price Per Unit',
      name: 'pricePerUnit',
      desc: '',
      args: [],
    );
  }

  /// `must be at least`
  String get mustbeatleast {
    return Intl.message(
      'must be at least',
      name: 'mustbeatleast',
      desc: '',
      args: [],
    );
  }

  /// `do not match`
  String get donotmatch {
    return Intl.message('do not match', name: 'donotmatch', desc: '', args: []);
  }

  /// `Field is required`
  String get fieldisrequired {
    return Intl.message(
      'Field is required',
      name: 'fieldisrequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid integer`
  String get enteravalidinteger {
    return Intl.message(
      'Enter a valid integer',
      name: 'enteravalidinteger',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid price`
  String get enteravalidprice {
    return Intl.message(
      'Enter a valid price',
      name: 'enteravalidprice',
      desc: '',
      args: [],
    );
  }

  /// `Initial Quantity`
  String get initialQuantity {
    return Intl.message(
      'Initial Quantity',
      name: 'initialQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Select an item`
  String get selectanitem {
    return Intl.message(
      'Select an item',
      name: 'selectanitem',
      desc: '',
      args: [],
    );
  }

  /// `Select Category`
  String get selectCategory {
    return Intl.message(
      'Select Category',
      name: 'selectCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select Unit`
  String get selectUnit {
    return Intl.message('Select Unit', name: 'selectUnit', desc: '', args: []);
  }

  /// `Select Branch`
  String get selectBranch {
    return Intl.message(
      'Select Branch',
      name: 'selectBranch',
      desc: '',
      args: [],
    );
  }

  /// `Discounts`
  String get discounts {
    return Intl.message('Discounts', name: 'discounts', desc: '', args: []);
  }

  /// `Add Discount`
  String get addDiscount {
    return Intl.message(
      'Add Discount',
      name: 'addDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Edit Discount`
  String get editDiscount {
    return Intl.message(
      'Edit Discount',
      name: 'editDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Delete Discount`
  String get deleteDiscount {
    return Intl.message(
      'Delete Discount',
      name: 'deleteDiscount',
      desc: '',
      args: [],
    );
  }

  /// `title`
  String get title {
    return Intl.message('title', name: 'title', desc: '', args: []);
  }

  /// `value as percentage`
  String get valueAsPercentage {
    return Intl.message(
      'value as percentage',
      name: 'valueAsPercentage',
      desc: '',
      args: [],
    );
  }

  /// `enter a valid percentage`
  String get enteravalidpercentage {
    return Intl.message(
      'enter a valid percentage',
      name: 'enteravalidpercentage',
      desc: '',
      args: [],
    );
  }

  /// `between`
  String get between {
    return Intl.message('between', name: 'between', desc: '', args: []);
  }

  /// `and`
  String get and {
    return Intl.message('and', name: 'and', desc: '', args: []);
  }

  /// `Taxes`
  String get taxes {
    return Intl.message('Taxes', name: 'taxes', desc: '', args: []);
  }

  /// `Add Tax`
  String get addTax {
    return Intl.message('Add Tax', name: 'addTax', desc: '', args: []);
  }

  /// `Edit Tax`
  String get editTax {
    return Intl.message('Edit Tax', name: 'editTax', desc: '', args: []);
  }

  /// `Delete Tax`
  String get deleteTax {
    return Intl.message('Delete Tax', name: 'deleteTax', desc: '', args: []);
  }

  /// `value`
  String get value {
    return Intl.message('value', name: 'value', desc: '', args: []);
  }

  /// `enter a valid number`
  String get enteravalidnumber {
    return Intl.message(
      'enter a valid number',
      name: 'enteravalidnumber',
      desc: '',
      args: [],
    );
  }

  /// `Store Quantity`
  String get storeQuantity {
    return Intl.message(
      'Store Quantity',
      name: 'storeQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Store Quantity Filter`
  String get storeQuantityFilter {
    return Intl.message(
      'Store Quantity Filter',
      name: 'storeQuantityFilter',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message('Filter', name: 'filter', desc: '', args: []);
  }

  /// `Range Price`
  String get rangePrice {
    return Intl.message('Range Price', name: 'rangePrice', desc: '', args: []);
  }

  /// `Range Quantity`
  String get rangeQuantity {
    return Intl.message(
      'Range Quantity',
      name: 'rangeQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Store Movements`
  String get storeMove {
    return Intl.message(
      'Store Movements',
      name: 'storeMove',
      desc: '',
      args: [],
    );
  }

  /// `Store Movements Details`
  String get storeMoveDetails {
    return Intl.message(
      'Store Movements Details',
      name: 'storeMoveDetails',
      desc: '',
      args: [],
    );
  }

  /// `Store Movements Filter`
  String get storeMoveFilter {
    return Intl.message(
      'Store Movements Filter',
      name: 'storeMoveFilter',
      desc: '',
      args: [],
    );
  }

  /// `Select Type Of Movements`
  String get selectTypeOfMove {
    return Intl.message(
      'Select Type Of Movements',
      name: 'selectTypeOfMove',
      desc: '',
      args: [],
    );
  }

  /// `Select Product`
  String get selectProduct {
    return Intl.message(
      'Select Product',
      name: 'selectProduct',
      desc: '',
      args: [],
    );
  }

  /// `Select User`
  String get selectUser {
    return Intl.message('Select User', name: 'selectUser', desc: '', args: []);
  }

  /// `Start Date`
  String get startDate {
    return Intl.message('Start Date', name: 'startDate', desc: '', args: []);
  }

  /// `End Date`
  String get endDate {
    return Intl.message('End Date', name: 'endDate', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `No Categories`
  String get noCategories {
    return Intl.message(
      'No Categories',
      name: 'noCategories',
      desc: '',
      args: [],
    );
  }

  /// `Hall`
  String get hall {
    return Intl.message('Hall', name: 'hall', desc: '', args: []);
  }

  /// `Take Away`
  String get takeaway {
    return Intl.message('Take Away', name: 'takeaway', desc: '', args: []);
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Select Tax`
  String get selectTax {
    return Intl.message('Select Tax', name: 'selectTax', desc: '', args: []);
  }

  /// `Item`
  String get item {
    return Intl.message('Item', name: 'item', desc: '', args: []);
  }

  /// `Qty`
  String get quantity {
    return Intl.message('Qty', name: 'quantity', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Continue to Payment`
  String get continuetoPayment {
    return Intl.message(
      'Continue to Payment',
      name: 'continuetoPayment',
      desc: '',
      args: [],
    );
  }

  /// `Sub total`
  String get subTotal {
    return Intl.message('Sub total', name: 'subTotal', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Select Discount`
  String get selectDiscount {
    return Intl.message(
      'Select Discount',
      name: 'selectDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirmPayment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirmPayment',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `2 payment method available`
  String get paymentmethodavailable {
    return Intl.message(
      '2 payment method available',
      name: 'paymentmethodavailable',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentmethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentmethod',
      desc: '',
      args: [],
    );
  }

  /// `online`
  String get online {
    return Intl.message('online', name: 'online', desc: '', args: []);
  }

  /// `cash`
  String get cash {
    return Intl.message('cash', name: 'cash', desc: '', args: []);
  }

  /// `Client`
  String get client {
    return Intl.message('Client', name: 'client', desc: '', args: []);
  }

  /// `Confirm Payment Success`
  String get confirmPaymentSuccess {
    return Intl.message(
      'Confirm Payment Success',
      name: 'confirmPaymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Connection timeout, please try again.`
  String get connectionTimeout {
    return Intl.message(
      'Connection timeout, please try again.',
      name: 'connectionTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Send timeout, please check your internet.`
  String get sendTimeout {
    return Intl.message(
      'Send timeout, please check your internet.',
      name: 'sendTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Receive timeout, please try again later.`
  String get receiveTimeout {
    return Intl.message(
      'Receive timeout, please try again later.',
      name: 'receiveTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Request was cancelled.`
  String get requestCancelled {
    return Intl.message(
      'Request was cancelled.',
      name: 'requestCancelled',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get noInternet {
    return Intl.message(
      'No internet connection.',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error occurred.`
  String get unknownError {
    return Intl.message(
      'Unknown error occurred.',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `No response from server.`
  String get noResponseFromServer {
    return Intl.message(
      'No response from server.',
      name: 'noResponseFromServer',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred.`
  String get anErrorOccurred {
    return Intl.message(
      'An error occurred.',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Server error`
  String get serverError {
    return Intl.message(
      'Server error',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Not allow to access this screen`
  String get notallowtoaccessthisscreen {
    return Intl.message(
      'Not allow to access this screen',
      name: 'notallowtoaccessthisscreen',
      desc: '',
      args: [],
    );
  }

  /// `Select Role`
  String get selectRole {
    return Intl.message('Select Role', name: 'selectRole', desc: '', args: []);
  }

  /// `Login Failed`
  String get loginFailed {
    return Intl.message(
      'Login Failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Register Failed`
  String get registerFailed {
    return Intl.message(
      'Register Failed',
      name: 'registerFailed',
      desc: '',
      args: [],
    );
  }

  /// `No Name`
  String get noName {
    return Intl.message('No Name', name: 'noName', desc: '', args: []);
  }

  /// `Discount Type`
  String get discountType {
    return Intl.message(
      'Discount Type',
      name: 'discountType',
      desc: '',
      args: [],
    );
  }

  /// `Expense Categories`
  String get expensecategories {
    return Intl.message(
      'Expense Categories',
      name: 'expensecategories',
      desc: '',
      args: [],
    );
  }

  /// `Delete Expense Categories`
  String get deleteexpensecategories {
    return Intl.message(
      'Delete Expense Categories',
      name: 'deleteexpensecategories',
      desc: '',
      args: [],
    );
  }

  /// `Add Expense Categories`
  String get addexpensecategories {
    return Intl.message(
      'Add Expense Categories',
      name: 'addexpensecategories',
      desc: '',
      args: [],
    );
  }

  /// `Edit Expense Categories`
  String get editexpensecategories {
    return Intl.message(
      'Edit Expense Categories',
      name: 'editexpensecategories',
      desc: '',
      args: [],
    );
  }

  /// `No Unit Name`
  String get noUnitName {
    return Intl.message('No Unit Name', name: 'noUnitName', desc: '', args: []);
  }

  /// `barcode`
  String get barcode {
    return Intl.message('barcode', name: 'barcode', desc: '', args: []);
  }

  /// `brand`
  String get brand {
    return Intl.message('brand', name: 'brand', desc: '', args: []);
  }

  /// `Search Discount`
  String get searchDiscount {
    return Intl.message(
      'Search Discount',
      name: 'searchDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Search Taxes`
  String get searchTaxes {
    return Intl.message(
      'Search Taxes',
      name: 'searchTaxes',
      desc: '',
      args: [],
    );
  }

  /// `No Item In Cart`
  String get noItemInCart {
    return Intl.message(
      'No Item In Cart',
      name: 'noItemInCart',
      desc: '',
      args: [],
    );
  }

  /// `Select Tax And Discount`
  String get selectTaxAndDiscount {
    return Intl.message(
      'Select Tax And Discount',
      name: 'selectTaxAndDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Search Branch`
  String get searchBranch {
    return Intl.message(
      'Search Branch',
      name: 'searchBranch',
      desc: '',
      args: [],
    );
  }

  /// `Search Unit`
  String get searchUnit {
    return Intl.message('Search Unit', name: 'searchUnit', desc: '', args: []);
  }

  /// `Search Category`
  String get searchCategory {
    return Intl.message(
      'Search Category',
      name: 'searchCategory',
      desc: '',
      args: [],
    );
  }

  /// `Search Role`
  String get searchRole {
    return Intl.message('Search Role', name: 'searchRole', desc: '', args: []);
  }

  /// `Search Client`
  String get searchClient {
    return Intl.message(
      'Search Client',
      name: 'searchClient',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method are required`
  String get paymentMethodarerequired {
    return Intl.message(
      'Payment Method are required',
      name: 'paymentMethodarerequired',
      desc: '',
      args: [],
    );
  }

  /// `Select Client`
  String get selectClient {
    return Intl.message(
      'Select Client',
      name: 'selectClient',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `service`
  String get service {
    return Intl.message('service', name: 'service', desc: '', args: []);
  }

  /// `inventory`
  String get inventory {
    return Intl.message('inventory', name: 'inventory', desc: '', args: []);
  }

  /// `Select Product Type`
  String get selectProductType {
    return Intl.message(
      'Select Product Type',
      name: 'selectProductType',
      desc: '',
      args: [],
    );
  }

  /// `Quantity of product is finished`
  String get quantityOfProductIsFinished {
    return Intl.message(
      'Quantity of product is finished',
      name: 'quantityOfProductIsFinished',
      desc: '',
      args: [],
    );
  }

  /// `No Quantity`
  String get noQuantity {
    return Intl.message('No Quantity', name: 'noQuantity', desc: '', args: []);
  }

  /// `Total After Discount`
  String get totalafterdiscount {
    return Intl.message(
      'Total After Discount',
      name: 'totalafterdiscount',
      desc: '',
      args: [],
    );
  }

  /// `Taxes Total`
  String get taxestotal {
    return Intl.message('Taxes Total', name: 'taxestotal', desc: '', args: []);
  }

  /// `Total After Tax`
  String get totalaftertax {
    return Intl.message(
      'Total After Tax',
      name: 'totalaftertax',
      desc: '',
      args: [],
    );
  }

  /// `Not Determined Price`
  String get notdeterminedprice {
    return Intl.message(
      'Not Determined Price',
      name: 'notdeterminedprice',
      desc: '',
      args: [],
    );
  }

  /// `unit`
  String get unit {
    return Intl.message('unit', name: 'unit', desc: '', args: []);
  }

  /// `Search Product`
  String get searchProduct {
    return Intl.message(
      'Search Product',
      name: 'searchProduct',
      desc: '',
      args: [],
    );
  }

  /// `purchase`
  String get purchase {
    return Intl.message('purchase', name: 'purchase', desc: '', args: []);
  }

  /// `sale`
  String get sale {
    return Intl.message('sale', name: 'sale', desc: '', args: []);
  }

  /// `sale return`
  String get salereturn {
    return Intl.message('sale return', name: 'salereturn', desc: '', args: []);
  }

  /// `purchase_return`
  String get purchasereturn {
    return Intl.message(
      'purchase_return',
      name: 'purchasereturn',
      desc: '',
      args: [],
    );
  }

  /// `wastage`
  String get wastage {
    return Intl.message('wastage', name: 'wastage', desc: '', args: []);
  }

  /// `Branch`
  String get branch {
    return Intl.message('Branch', name: 'branch', desc: '', args: []);
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Movement Type`
  String get movementType {
    return Intl.message(
      'Movement Type',
      name: 'movementType',
      desc: '',
      args: [],
    );
  }

  /// `Created At`
  String get createdAt {
    return Intl.message('Created At', name: 'createdAt', desc: '', args: []);
  }

  /// `Updated At`
  String get UpdatedAt {
    return Intl.message('Updated At', name: 'UpdatedAt', desc: '', args: []);
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message('Type', name: 'type', desc: '', args: []);
  }

  /// `Price After Tax`
  String get priceAfterTax {
    return Intl.message(
      'Price After Tax',
      name: 'priceAfterTax',
      desc: '',
      args: [],
    );
  }

  /// `Reference Details`
  String get referenceDetails {
    return Intl.message(
      'Reference Details',
      name: 'referenceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Line Total After Tax`
  String get lineTotalAfterTax {
    return Intl.message(
      'Line Total After Tax',
      name: 'lineTotalAfterTax',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get Quantity {
    return Intl.message('Quantity', name: 'Quantity', desc: '', args: []);
  }

  /// `Sales`
  String get sales {
    return Intl.message('Sales', name: 'sales', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `id`
  String get id {
    return Intl.message('id', name: 'id', desc: '', args: []);
  }

  /// `unknown Date`
  String get unknownDate {
    return Intl.message(
      'unknown Date',
      name: 'unknownDate',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Sales Details`
  String get salesDetails {
    return Intl.message(
      'Sales Details',
      name: 'salesDetails',
      desc: '',
      args: [],
    );
  }

  /// `Search User`
  String get searchUser {
    return Intl.message('Search User', name: 'searchUser', desc: '', args: []);
  }

  /// `Sales Filter`
  String get salesFilter {
    return Intl.message(
      'Sales Filter',
      name: 'salesFilter',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get descending {
    return Intl.message('Descending', name: 'descending', desc: '', args: []);
  }

  /// `Ascending`
  String get ascending {
    return Intl.message('Ascending', name: 'ascending', desc: '', args: []);
  }

  /// `Select Payment Method`
  String get selectPaymentMethod {
    return Intl.message(
      'Select Payment Method',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Select Sort`
  String get selectSort {
    return Intl.message('Select Sort', name: 'selectSort', desc: '', args: []);
  }

  /// `Select Both Sort And Sort By`
  String get selectBothSortAndSortBy {
    return Intl.message(
      'Select Both Sort And Sort By',
      name: 'selectBothSortAndSortBy',
      desc: '',
      args: [],
    );
  }

  /// `Select Both Start Date And End Date`
  String get selectBothFromDateAndToDate {
    return Intl.message(
      'Select Both Start Date And End Date',
      name: 'selectBothFromDateAndToDate',
      desc: '',
      args: [],
    );
  }

  /// `Select Sort By`
  String get selectSortBy {
    return Intl.message(
      'Select Sort By',
      name: 'selectSortBy',
      desc: '',
      args: [],
    );
  }

  /// `Sale Info`
  String get saleInfo {
    return Intl.message('Sale Info', name: 'saleInfo', desc: '', args: []);
  }

  /// `Sale ID`
  String get saleId {
    return Intl.message('Sale ID', name: 'saleId', desc: '', args: []);
  }

  /// `Discount Total`
  String get discountTotal {
    return Intl.message(
      'Discount Total',
      name: 'discountTotal',
      desc: '',
      args: [],
    );
  }

  /// `UnKnown ID`
  String get unknownId {
    return Intl.message('UnKnown ID', name: 'unknownId', desc: '', args: []);
  }

  /// `UnKnown Price`
  String get unKnownPrice {
    return Intl.message(
      'UnKnown Price',
      name: 'unKnownPrice',
      desc: '',
      args: [],
    );
  }

  /// `Total After Discount`
  String get totalAfterDiscount {
    return Intl.message(
      'Total After Discount',
      name: 'totalAfterDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Total After Tax`
  String get totalAfterTax {
    return Intl.message(
      'Total After Tax',
      name: 'totalAfterTax',
      desc: '',
      args: [],
    );
  }

  /// `User Info`
  String get userInfo {
    return Intl.message('User Info', name: 'userInfo', desc: '', args: []);
  }

  /// `role`
  String get role {
    return Intl.message('role', name: 'role', desc: '', args: []);
  }

  /// `Branch Info`
  String get branchInfo {
    return Intl.message('Branch Info', name: 'branchInfo', desc: '', args: []);
  }

  /// `Unit Price`
  String get unitPrice {
    return Intl.message('Unit Price', name: 'unitPrice', desc: '', args: []);
  }

  /// `Line Total Before Discount`
  String get lineTotalBeforeDiscount {
    return Intl.message(
      'Line Total Before Discount',
      name: 'lineTotalBeforeDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Product Type`
  String get productType {
    return Intl.message(
      'Product Type',
      name: 'productType',
      desc: '',
      args: [],
    );
  }

  /// `unknown Percentage`
  String get unknownPercentage {
    return Intl.message(
      'unknown Percentage',
      name: 'unknownPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Role Id`
  String get roleId {
    return Intl.message('Role Id', name: 'roleId', desc: '', args: []);
  }

  /// `return`
  String get Return {
    return Intl.message('return', name: 'Return', desc: '', args: []);
  }

  /// `Is Returned Already`
  String get isReturnedAlready {
    return Intl.message(
      'Is Returned Already',
      name: 'isReturnedAlready',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure You Want To Return`
  String get areYouSureWantToReturn {
    return Intl.message(
      'Are You Sure You Want To Return',
      name: 'areYouSureWantToReturn',
      desc: '',
      args: [],
    );
  }

  /// `Sure`
  String get sure {
    return Intl.message('Sure', name: 'sure', desc: '', args: []);
  }

  /// `Return Sales Confirm`
  String get returnSalesConfirm {
    return Intl.message(
      'Return Sales Confirm',
      name: 'returnSalesConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Sales Return Details`
  String get salesReturnDetails {
    return Intl.message(
      'Sales Return Details',
      name: 'salesReturnDetails',
      desc: '',
      args: [],
    );
  }

  /// `Sales Return`
  String get salesReturn {
    return Intl.message(
      'Sales Return',
      name: 'salesReturn',
      desc: '',
      args: [],
    );
  }

  /// `Sales Return Filter`
  String get salesReturnFilter {
    return Intl.message(
      'Sales Return Filter',
      name: 'salesReturnFilter',
      desc: '',
      args: [],
    );
  }

  /// `Return Info`
  String get returnInfo {
    return Intl.message('Return Info', name: 'returnInfo', desc: '', args: []);
  }

  /// `Return User`
  String get returnUser {
    return Intl.message('Return User', name: 'returnUser', desc: '', args: []);
  }

  /// `Sale User`
  String get saleUser {
    return Intl.message('Sale User', name: 'saleUser', desc: '', args: []);
  }

  /// `Customer Info`
  String get customerInfo {
    return Intl.message(
      'Customer Info',
      name: 'customerInfo',
      desc: '',
      args: [],
    );
  }

  /// `Discount Info`
  String get discountInfo {
    return Intl.message(
      'Discount Info',
      name: 'discountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Minimum Quantity`
  String get minimumQuantity {
    return Intl.message(
      'Minimum Quantity',
      name: 'minimumQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Maximum Quantity`
  String get maximumQuantity {
    return Intl.message(
      'Maximum Quantity',
      name: 'maximumQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Select Both Minimum And Maximum Quantity`
  String get selectBothMinimumAndMaximumQuantity {
    return Intl.message(
      'Select Both Minimum And Maximum Quantity',
      name: 'selectBothMinimumAndMaximumQuantity',
      desc: '',
      args: [],
    );
  }

  /// `Shop Name`
  String get shopName {
    return Intl.message('Shop Name', name: 'shopName', desc: '', args: []);
  }

  /// `Shop Setting`
  String get shopSetting {
    return Intl.message(
      'Shop Setting',
      name: 'shopSetting',
      desc: '',
      args: [],
    );
  }

  /// `Postal Code`
  String get postalCode {
    return Intl.message('Postal Code', name: 'postalCode', desc: '', args: []);
  }

  /// `Tax Number`
  String get taxNo {
    return Intl.message('Tax Number', name: 'taxNo', desc: '', args: []);
  }

  /// `Commercial Number`
  String get commercialNo {
    return Intl.message(
      'Commercial Number',
      name: 'commercialNo',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Paid`
  String get paid {
    return Intl.message('Paid', name: 'paid', desc: '', args: []);
  }

  /// `Paid Required`
  String get paidRequired {
    return Intl.message(
      'Paid Required',
      name: 'paidRequired',
      desc: '',
      args: [],
    );
  }

  /// `Rest`
  String get rest {
    return Intl.message('Rest', name: 'rest', desc: '', args: []);
  }

  /// `Paid Should Be More Than Total Price`
  String get paidShouldBeMoreThanTotalPrice {
    return Intl.message(
      'Paid Should Be More Than Total Price',
      name: 'paidShouldBeMoreThanTotalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Order Type`
  String get orderType {
    return Intl.message('Order Type', name: 'orderType', desc: '', args: []);
  }

  /// `Select Type Of Take Order`
  String get selectTypeOfTakeOrder {
    return Intl.message(
      'Select Type Of Take Order',
      name: 'selectTypeOfTakeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Reset Discount`
  String get resetDiscount {
    return Intl.message(
      'Reset Discount',
      name: 'resetDiscount',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
