import 'package:flutter/material.dart';
import 'package:pos_app/core/api/api_keys.dart';
import 'package:pos_app/core/cache/custom_user_hive_box.dart';
import 'package:pos_app/core/router/app_route.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/home/data/model/home_view_item_model.dart';
import 'package:pos_app/features/home/view/widget/home_view_item_builder.dart';
import 'package:pos_app/features/permissions/data/model/permission_model.dart';
import 'package:pos_app/features/products/data/model/product_type.dart';
import 'package:pos_app/features/sales/data/model/sort_model.dart';
import 'package:pos_app/features/selling_point/data/model/payment_method_model.dart';
import 'package:pos_app/features/selling_point/data/model/type_of_take_order_model.dart';
import 'package:pos_app/features/store_move/data/model/type_of_movement_model.dart';
import 'package:pos_app/generated/l10n.dart';

class AppConstant {
  static int formExpandedTableandMobile = 4;

  static List<HomeViewItemBuilder> gridItems({required BuildContext context}) {
    UserModel user = CustomUserHiveBox.getUser();
    List<HomeViewItemModel> homeviewItems = [
      HomeViewItemModel(
        color: Color(0xffFF6D6D),
        pageRoute: AppRoutes.sellingPointsView,
        icon: Icons.shopping_basket_outlined,
        title: S.of(context).sellingPoint,
        // canAccess: user.role.sellingPoint,
        canAccess: true,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        pageRoute: AppRoutes.categories,
        icon: Icons.category_outlined,
        title: S.of(context).categories,
        canAccess: user.role?.categories ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.products,
        icon: Icons.shopping_bag_outlined,
        title: S.of(context).products,
        canAccess: user.role?.products ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.units,
        icon: Icons.widgets_outlined,
        title: S.of(context).units,
        canAccess: user.role?.units ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.discounts,
        icon: Icons.discount_outlined,
        title: S.of(context).discounts,
        canAccess: user.role?.discounts ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.taxes,
        icon: Icons.attach_money_outlined,
        title: S.of(context).taxes,
        canAccess: user.role?.taxes ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.expenseCategoriesView,
        icon: Icons.attach_money,
        title: S.of(context).expensecategories,
        canAccess: user.role?.expenseCategories ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xfff37736),
        pageRoute: AppRoutes.branches,
        icon: Icons.account_tree_outlined,
        title: S.of(context).branches,
        canAccess: user.role?.branches ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffFF6D6D),
        icon: Icons.manage_accounts_outlined,
        pageRoute: AppRoutes.users,
        title: S.of(context).users,
        canAccess: user.role?.users ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffFF6D6D),
        icon: Icons.security_rounded,
        pageRoute: AppRoutes.permissions,
        title: S.of(context).permissions,
        canAccess: user.role?.roles ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.groups_2_outlined,
        pageRoute: AppRoutes.clients,
        title: S.of(context).clients,
        canAccess: user.role?.customers ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.handshake_outlined,
        pageRoute: AppRoutes.suppliers,
        title: S.of(context).suppliers,
        canAccess: user.role?.suppliers ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.settings_outlined,
        pageRoute: AppRoutes.shopSettingView,
        title: S.of(context).shopSetting,
        canAccess: user.role?.settings ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.sell_outlined,
        pageRoute: AppRoutes.salesView,
        title: S.of(context).sales,
        canAccess: user.role?.sales ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.autorenew_outlined,
        pageRoute: AppRoutes.salesReturnView,
        title: S.of(context).salesReturn,
        canAccess: user.role?.saleReturn ?? false,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.production_quantity_limits_outlined,
        pageRoute: AppRoutes.storequantity,
        title: S.of(context).storeQuantity,
        // canAccess: user.role?.storeQuantity ?? false,
        canAccess: true,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.store_outlined,
        pageRoute: AppRoutes.storeMoveView,
        title: S.of(context).storeMove,
        // canAccess: user.role?.storeMove ?? false,
        canAccess: true,
      ),
      HomeViewItemModel(
        color: Color(0xffffa700),
        icon: Icons.print_outlined,
        pageRoute: AppRoutes.storeMoveView,
        title: S.of(context).storeMove, // TODO: change title to Printers
        // canAccess: user.role?.storeMove ?? false,
        canAccess: true,
      ),
    ];

    List<HomeViewItemBuilder> homeViewItemBuilders = [];
    homeviewItems.map((e) {
      if (e.canAccess) {
        homeViewItemBuilders.add(HomeViewItemBuilder(
          color: e.color,
          pageRoute: e.pageRoute,
          icon: e.icon,
          title: e.title,
          canAccess: e.canAccess,
        ));
      }
    }).toList();

    return homeViewItemBuilders;
  }

  static List<PermissionItemModel> allPermissions({bool asAdmin = false}) => [
        PermissionItemModel(name: ApiKeys.sales, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.purchase, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.users, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.roles, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.settings, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.categories, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.products, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.units, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.branches, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.customers, isSelected: asAdmin),
        PermissionItemModel(
            name: ApiKeys.expensecategories, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.expenses, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.purchasereturn, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.salereturn, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.suppliers, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.taxes, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.discounts, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.inventory, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.stock, isSelected: asAdmin),
        PermissionItemModel(name: ApiKeys.printers, isSelected: asAdmin),
      ];
  static List<PermissionItemModel> getUserPermissions(RoleModel role) {
    return role.permissions.entries
        .map((e) =>
            PermissionItemModel(name: e.key, isSelected: e.value ?? false))
        .toList();
  }

  static List<TypeOfTakeOrderModel> typesOfTakeOrder(context) => [
        TypeOfTakeOrderModel(
          id: 0,
          name: S.of(context).hall,
          apiKey: ApiKeys.hall,
          icon: Icons.restaurant,
        ),
        TypeOfTakeOrderModel(
          id: 1,
          name: S.of(context).takeaway,
          apiKey: ApiKeys.takeaway,
          icon: Icons.local_mall,
        ),
        TypeOfTakeOrderModel(
          id: 2,
          name: S.of(context).delivery,
          apiKey: ApiKeys.delivery,
          icon: Icons.delivery_dining,
        ),
      ];

  static List<PaymentMethodModel> paymentMethods(context) => [
        PaymentMethodModel(
          id: 0,
          name: S.of(context).cash,
          icon: Icons.account_balance_wallet_outlined,
          apiKey: ApiKeys.cash,
        ),
        PaymentMethodModel(
          id: 1,
          name: S.of(context).online,
          icon: Icons.language,
          apiKey: ApiKeys.online,
        ),
      ];
  static List<ProductType> producttype(context) => [
        ProductType(
          id: 1,
          value: ApiKeys.inventory,
          name: S.of(context).inventory,
        ),
        ProductType(
          id: 2,
          value: ApiKeys.service,
          name: S.of(context).service,
        ),
      ];

  // 'purchase', 'sale', 'sale_return', 'purchase_return', 'wastage'
  static List<TypeOfMovementModel> typeOfMovements(context) => [
        TypeOfMovementModel(
          id: 1,
          name: S.of(context).purchase,
          value: 'purchase',
        ),
        TypeOfMovementModel(
          id: 2,
          name: S.of(context).sale,
          value: 'sale',
        ),
        TypeOfMovementModel(
          id: 3,
          name: S.of(context).salereturn,
          value: 'sale_return',
        ),
        TypeOfMovementModel(
          id: 4,
          name: S.of(context).purchasereturn,
          value: 'purchase_return',
        ),
        TypeOfMovementModel(
          id: 5,
          name: S.of(context).wastage,
          value: 'wastage',
        ),
      ];

  static List<SortModel> sorts(context) => [
        SortModel(
          id: 1,
          name: S.of(context).ascending,
          apiKey: ApiKeys.asc,
        ),
        SortModel(
          id: 2,
          name: S.of(context).descending,
          apiKey: ApiKeys.desc,
        ),
      ];
  static List<SortByModel> sortsBySales(context) => [
        SortByModel(
          id: 1,
          name: S.of(context).total,
          apiKey: ApiKeys.total,
        ),
        SortByModel(
          id: 2,
          name: S.of(context).createdAt,
          apiKey: ApiKeys.createdat,
        ),
      ];
  static List<SortByModel> sortsByMovements(context) => [
        SortByModel(
          id: 1,
          name: S.of(context).Quantity,
          apiKey: ApiKeys.quantity,
        ),
        SortByModel(
          id: 2,
          name: S.of(context).createdAt,
          apiKey: ApiKeys.createdat,
        ),
      ];

  static const int numberOfCardLoading = 10;
  static const int debouncingMillSeconds = 300;
  static const int callPaginationSeconds = 0;
  static const String noAvilableImage =
      "data:image/png;base64,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";
}
