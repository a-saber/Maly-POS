import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_app/core/cache/cache_keys.dart';
import 'package:pos_app/core/cache/custom_secure_storage.dart';

abstract class ApiKeys {
  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String email = 'email';
  static const String password = 'password';
  static const String name = 'name';
  static const String address = 'address';
  static const String phone = 'phone';
  static const String status = 'status';
  static const String message = 'message';
  static const String errors = 'errors';
  static const String userid = 'user_id';
  static const String branchid = 'branch_id';
  static const String id = 'id';
  static const String createdat = 'created_at';
  static const String updatedat = 'updated_at';
  static const String pivot = 'pivot';
  static const String description = 'description';
  static const String sales = 'sales';
  static const String purchase = 'purchase';
  static const String users = 'users';
  static const String roles = 'roles';
  static const String settings = 'settings';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String units = 'units';
  static const String branches = 'branches';
  static const String customers = 'customers';
  static const String expensecategories = 'expense_categories';
  static const String expenses = 'expenses';
  static const String purchasereturn = 'purchase_return';
  static const String salereturn = 'sale_return';
  static const String suppliers = 'suppliers';
  static const String taxes = 'taxes';
  static const String discounts = 'discounts';
  static const String imagepath = 'image_path';
  static const String emailverifiedat = 'email_verified_at';
  static const String centraluserid = 'central_user_id';
  static const String roleid = 'role_id';
  static const String imageurl = 'image_url';
  static const String role = 'role';
  static const String token = 'token';
  static const String user = 'user';
  static const String domain = 'domain';
  static const String currentpage = 'current_page';
  static const String data = 'data';
  static const String movements = 'movements';
  static const String firstpageurl = 'first_page_url';
  static const String from = 'from';
  static const String lastpage = 'last_page';
  static const String lastpageurl = 'last_page_url';
  static const String links = 'links';
  static const String nextpageurl = 'next_page_url';
  static const String path = 'path';
  static const String perpage = 'per_page';
  static const String prevpageurl = 'prev_page_url';
  static const String to = 'to';
  static const String total = 'total';
  static const String url = 'url';
  static const String label = 'label';
  static const String active = 'active';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
  static const String branch = 'branch';
  static const String image = 'image';
  static const String search = 'search';
  static const String customer = 'customer';
  static const String supplier = 'supplier';
  static const String title = 'title';
  static const String type = 'type';
  static const String value = 'value';
  static const String success = 'success';
  static const String discount = 'discount';
  static const String percentage = 'percentage';
  static const String tax = 'tax';
  static const String unit = 'unit';
  static const String expenseCategory = 'expenseCategory';
  static const String category = 'category';
  static const String categoryId = 'category_id';
  static const String unitId = 'unit_id';
  static const String barcode = 'barcode';
  static const String brand = 'brand';
  static const String price = 'price';
  static const String openingquantity = 'opening_quantity';
  static const String product = 'product';
  static const String online = 'online';
  static const String cash = 'cash';
  static const String paymentmethod = 'payment_method';
  static const String productid = 'product_id';
  static const String quantity = 'quantity';
  static const String taxid = 'tax_id';
  static const String discountid = 'discount_id';
  static const String customerid = 'customer_id';
  static const String priceAfterTax = 'price_after_tax';
  static const String totalaftertax = 'total_after_tax';
  static const String taxtotal = 'tax_total';
  static const String totalafterdiscount = 'total_after_discount';
  static const String discounttotal = 'discount_total';
  static const String subtotal = 'subtotal';
  static const String service = 'service';
  static const String inventory = 'inventory';
  static const String saleid = 'sale_id';
  static const String unitpriceafterdiscount = 'unit_price_after_discount';
  static const String linetotalbeforediscount = 'line_total_before_discount';
  static const String linetotalafterdiscount = 'line_total_after_discount';
  static const String taxamount = 'tax_amount';
  static const String linetotalaftertax = 'line_total_after_tax';
  static const String movementtype = 'movement_type';
  static const String referencetype = 'reference_type';
  static const String referenceid = 'reference_id';
  static const String reference = 'reference';
  static const String salesReturnId = 'sales_return_id';
  static const String saleproducts = 'sale_products';
  static const String sort = 'sort';
  static const String sortBy = 'sort_by';
  static const String asc = 'asc';
  static const String desc = 'desc';
  static const String reason = 'reason';
  static const String sale = 'sale';
  static const String startDate = 'start_date';
  static const String endDate = 'end_date';
  static const String sortOrder = 'sort_order';
  static const String quantityMin = 'quantity_min';
  static const String quantityMax = 'quantity_max';
  static const String shopname = 'shop_name';
  static const String postalcode = 'postal_code';
  static const String taxno = 'tax_no';
  static const String commercialno = 'commercial_no';
  static const String logourl = 'logo_url';
  static const String stock = 'stock';
  static const String printers = 'printers';
  static const String ordertype = 'order_type';
  static const String takeaway = 'take_away';
  static const String delivery = 'delivery';
  static const String hall = 'hall';
  static const String zatcaQrcode = 'zatca_qrcode';
  static const String perPage = 'per_page';
}

abstract class ApiEndPoints {
  // Login And Register
  static const String _loginAndRegisterBaseUrl =
      'http://pos.engazat.net:8000/api/';
  static const String register = "${_loginAndRegisterBaseUrl}register";
  static const String login = "${_loginAndRegisterBaseUrl}login";

  // Pos Feature And Domain

  static Future<String> _getPosUrl() async {
    try {
      String? domainEndocde =
          await CustomSecureStorage.read(key: CacheKeys.domain);
      String domain =
          domainEndocde != null ? utf8.decode(base64Decode(domainEndocde)) : "";
      debugPrint("domain : $domain");
      // final domain = CacheHelper.getString(key: CacheKeys.domain) ?? '';
      return "http://$domain:8000/";
    } catch (e) {
      debugPrint(e.toString());
      return "http://:8000/";
    }
  }

  static Future<String> getRoles() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}roles";
  }

  static Future<String> getUsers() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}users";
  }

  static Future<String> getBranches() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}branches";
  }

  static Future<String> getCustomers() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}customers";
  }

  static Future<String> getSuppliers() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}suppliers";
  }

  static Future<String> getDiscounts() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}discounts";
  }

  static Future<String> getTaxes() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}taxes";
  }

  static Future<String> getUnits() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}units";
  }

  static Future<String> getExpenseCategories() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}expense-categories";
  }

  static Future<String> getCategories() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}categories";
  }

  static Future<String> getProducts() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}products";
  }

  static Future<String> getSales() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}sales";
  }

  static Future<String> getStoreQuantity() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}inventory";
  }

  static Future<String> getStoreMovements() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}stock-movements";
  }

  static Future<String> getSalesReturns() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}sales-returns";
  }

  static Future<String> getShopSetting() async {
    final baseUrl = await _getPosUrl();
    return "${baseUrl}settings";
  }
}
