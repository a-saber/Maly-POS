import 'package:flutter/material.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';

void resetAllGetCubit(BuildContext context) {
  //
  MyServiceLocator.getSingleton<GetAllBranchesCubit>().reset();
  // GetAllBranchesCubit.get(context).reset();
  //
  //
  // GetCategoryCubit.get(context).reset();
  MyServiceLocator.getSingleton<GetCategoryCubit>().reset();
  //
  //
  MyServiceLocator.getSingleton<GetClientsCubit>().reset();
  // GetClientsCubit.get(context).reset();
  /////
  MyServiceLocator.getSingleton<GetAllDiscountsCubit>().reset();
  // GetAllDiscountsCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<GetExpenseCategoriesCubit>().reset();
  // GetExpenseCategoriesCubit.get(context).reset();

  ///
  MyServiceLocator.getSingleton<GetPermissionsCubit>().reset();
  // GetPermissionsCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<GetAllProductsCubit>().reset();
  // GetAllProductsCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<GetSalesCubit>().reset();
  // GetSalesCubit.get(context).reset();
  MyServiceLocator.getSingleton<GetSalesReturnCubit>().reset();
  // GetSalesReturnCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<GetSuppliersCubit>().reset();
  // GetSuppliersCubit.get(context).reset();
  //
  //
  MyServiceLocator.getSingleton<GetAllTaxesCubit>().reset();
  // GetAllTaxesCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<GetAllUnitsCubit>().reset();
  // GetAllUnitsCubit.get(context).reset();
  //
  //
  MyServiceLocator.getSingleton<GetUsersCubit>().reset();
  // GetUsersCubit.get(context).reset();
  //
  MyServiceLocator.getSingleton<SellingPointCubit>().reset(context: context);
  // SellingPointCubit.get(context).reset(context: context);
}
