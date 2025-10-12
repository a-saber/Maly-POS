import 'package:hive/hive.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/features/permissions/data/model/permission_model.dart';

part 'role_model.g.dart';

@HiveType(typeId: 1)
class RoleModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final bool? sales;
  @HiveField(4)
  final bool? purchase;
  @HiveField(5)
  final bool? users;
  @HiveField(6)
  final bool? roles;
  @HiveField(7)
  final bool? settings;
  @HiveField(8)
  final bool? categories;
  @HiveField(9)
  final bool? products;
  @HiveField(10)
  final bool? units;
  @HiveField(11)
  final bool? branches;
  @HiveField(12)
  final bool? customers;
  @HiveField(13)
  final bool? expenseCategories;
  @HiveField(14)
  final bool? expenses;
  @HiveField(15)
  final bool? purchaseReturn;
  @HiveField(16)
  final bool? saleReturn;
  @HiveField(17)
  final bool? suppliers;
  @HiveField(18)
  final bool? taxes;
  @HiveField(19)
  final bool? discounts;
  @HiveField(22)
  final bool? inventory;
  @HiveField(23)
  final bool? stock;
  @HiveField(24)
  final bool? printers;
  @HiveField(20)
  final String? createdAt;
  @HiveField(21)
  final String? updatedAt;

  RoleModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.sales,
      required this.purchase,
      required this.users,
      required this.roles,
      required this.settings,
      required this.categories,
      required this.products,
      required this.units,
      required this.branches,
      required this.customers,
      required this.expenseCategories,
      required this.expenses,
      required this.purchaseReturn,
      required this.saleReturn,
      required this.suppliers,
      required this.taxes,
      required this.discounts,
      required this.inventory,
      required this.stock,
      required this.printers,
      required this.createdAt,
      required this.updatedAt});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      description: json[ApiKeys.description],
      sales: json[ApiKeys.sales],
      purchase: json[ApiKeys.purchase],
      users: json[ApiKeys.users],
      roles: json[ApiKeys.roles],
      settings: json[ApiKeys.settings],
      categories: json[ApiKeys.categories],
      products: json[ApiKeys.products],
      units: json[ApiKeys.units],
      branches: json[ApiKeys.branches],
      customers: json[ApiKeys.customers],
      expenseCategories: json[ApiKeys.expensecategories],
      expenses: json[ApiKeys.expenses],
      purchaseReturn: json[ApiKeys.purchasereturn],
      saleReturn: json[ApiKeys.salereturn],
      suppliers: json[ApiKeys.suppliers],
      taxes: json[ApiKeys.taxes],
      discounts: json[ApiKeys.discounts],
      printers: json[ApiKeys.printers],
      createdAt: json[ApiKeys.createdat],
      updatedAt: json[ApiKeys.updatedat],
      inventory:
          json[ApiKeys.inventory] is int ? json[ApiKeys.inventory] == 1 : false,
      stock: json[ApiKeys.stock] is int ? json[ApiKeys.stock] == 1 : false,
    );
  }

  factory RoleModel.createNew({
    required name,
    required description,
    required List<PermissionItemModel> permissions,
  }) {
    final Map<String, bool> permMap = {
      for (var p in permissions) p.name!: p.isSelected,
    };

    return RoleModel(
      id: null,
      name: name,
      description: description,
      sales: permMap[ApiKeys.sales],
      purchase: permMap[ApiKeys.purchase],
      users: permMap[ApiKeys.users],
      roles: permMap[ApiKeys.roles],
      settings: permMap[ApiKeys.settings],
      categories: permMap[ApiKeys.categories],
      products: permMap[ApiKeys.products],
      units: permMap[ApiKeys.units],
      branches: permMap[ApiKeys.branches],
      customers: permMap[ApiKeys.customers],
      expenseCategories: permMap[ApiKeys.expensecategories],
      expenses: permMap[ApiKeys.expenses],
      purchaseReturn: permMap[ApiKeys.purchasereturn],
      saleReturn: permMap[ApiKeys.salereturn],
      suppliers: permMap[ApiKeys.suppliers],
      taxes: permMap[ApiKeys.taxes],
      discounts: permMap[ApiKeys.discounts],
      inventory: permMap[ApiKeys.inventory],
      stock: permMap[ApiKeys.stock],
      printers: permMap[ApiKeys.printers],
      createdAt: null,
      updatedAt: null,
    );
  }

  Map<String, dynamic> toJsonWithoutId() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;

    // convert bool? → int (true=1, false=0, null=0)
    int boolToInt(bool? value) => (value ?? false) ? 1 : 0;

    data[ApiKeys.sales] = boolToInt(sales);
    data[ApiKeys.purchase] = boolToInt(purchase);
    data[ApiKeys.users] = boolToInt(users);
    data[ApiKeys.roles] = boolToInt(roles);
    data[ApiKeys.settings] = boolToInt(settings);
    data[ApiKeys.categories] = boolToInt(categories);
    data[ApiKeys.products] = boolToInt(products);
    data[ApiKeys.units] = boolToInt(units);
    data[ApiKeys.branches] = boolToInt(branches);
    data[ApiKeys.customers] = boolToInt(customers);
    data[ApiKeys.expensecategories] = boolToInt(expenseCategories);
    data[ApiKeys.expenses] = boolToInt(expenses);
    data[ApiKeys.purchasereturn] = boolToInt(purchaseReturn);
    data[ApiKeys.salereturn] = boolToInt(saleReturn);
    data[ApiKeys.suppliers] = boolToInt(suppliers);
    data[ApiKeys.taxes] = boolToInt(taxes);
    data[ApiKeys.discounts] = boolToInt(discounts);
    data[ApiKeys.inventory] = boolToInt(inventory);
    data[ApiKeys.stock] = boolToInt(stock);
    data[ApiKeys.printers] = boolToInt(printers);

    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[ApiKeys.id] = id;
    data[ApiKeys.name] = name;
    data[ApiKeys.description] = description;
    data[ApiKeys.sales] = sales;
    data[ApiKeys.purchase] = purchase;
    data[ApiKeys.users] = users;
    data[ApiKeys.roles] = roles;
    data[ApiKeys.settings] = settings;
    data[ApiKeys.categories] = categories;
    data[ApiKeys.products] = products;
    data[ApiKeys.units] = units;
    data[ApiKeys.branches] = branches;
    data[ApiKeys.customers] = customers;
    data[ApiKeys.expensecategories] = expenseCategories;
    data[ApiKeys.expenses] = expenses;
    data[ApiKeys.purchasereturn] = purchaseReturn;
    data[ApiKeys.salereturn] = saleReturn;
    data[ApiKeys.suppliers] = suppliers;
    data[ApiKeys.taxes] = taxes;
    data[ApiKeys.discounts] = discounts;
    data[ApiKeys.inventory] = inventory;
    data[ApiKeys.stock] = stock;
    data[ApiKeys.printers] = printers;
    data[ApiKeys.createdat] = createdAt;
    data[ApiKeys.updatedat] = updatedAt;

    return data;
  }

  Map<String, bool?> get permissions => {
        ApiKeys.sales: sales,
        ApiKeys.purchase: purchase,
        ApiKeys.users: users,
        ApiKeys.roles: roles,
        ApiKeys.settings: settings,
        ApiKeys.categories: categories,
        ApiKeys.products: products,
        ApiKeys.units: units,
        ApiKeys.branches: branches,
        ApiKeys.customers: customers,
        ApiKeys.expensecategories: expenseCategories,
        ApiKeys.expenses: expenses,
        ApiKeys.purchasereturn: purchaseReturn,
        ApiKeys.salereturn: saleReturn,
        ApiKeys.suppliers: suppliers,
        ApiKeys.taxes: taxes,
        ApiKeys.discounts: discounts,
        ApiKeys.inventory: inventory,
        ApiKeys.stock: stock,
        ApiKeys.printers: printers
      };
}
