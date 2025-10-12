import 'package:get_it/get_it.dart';
import 'package:pos_app/core/api/api_helper.dart';
import 'package:pos_app/core/api/api_interceptor.dart';
import 'package:pos_app/features/auth/login/data/repo/login_repo.dart';
import 'package:pos_app/features/auth/register/data/repo/register_repo.dart';
import 'package:pos_app/features/branch/data/repo/branches_repo.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/manager/search_branch_cubit/search_branch_cubit.dart';
import 'package:pos_app/features/categories/data/repo/category_repo.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/manager/search_category/search_category_cubit.dart';
import 'package:pos_app/features/clients/data/repo/clients_repo.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/clients/manager/search_client/search_client_cubit.dart';
import 'package:pos_app/features/discounts/data/repo/discounts_repo.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/discounts/manager/search_discount_cubit/search_discount_cubit.dart';
import 'package:pos_app/features/expense_categories/data/repo/expense_categories_repo.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/home/data/repo/home_repo.dart';
import 'package:pos_app/features/home/manager/cubit/home_cubit.dart';
import 'package:pos_app/features/permissions/data/repo/permission_repo.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/permissions/manager/search_permission/search_permission_cubit.dart';
import 'package:pos_app/features/products/data/repo/products_repo.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/sales/data/repo/sales_repo.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales_returns/data/repo/sales_return_repo.dart';
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';
import 'package:pos_app/features/selling_point/data/repo/selling_point_repo.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_product_cubit/selling_point_product_cubit.dart';
import 'package:pos_app/features/shop_setting/data/repo/shop_setting_repo.dart';
import 'package:pos_app/features/shop_setting/manager/cubit/shop_setting_cubit.dart';
import 'package:pos_app/features/store_move/data/repo/store_move_repo.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';
import 'package:pos_app/features/store_quantity/data/repo/store_quantity_repo.dart';
import 'package:pos_app/features/store_quantity/manager/store_quantity_cubit/store_quantity_cubit.dart';
import 'package:pos_app/features/suppliers/data/repo/suppliers_repo.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/features/taxes/data/repo/taxes_repo.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/taxes/manager/search_taxes/search_taxes_cubit.dart';
import 'package:pos_app/features/units/data/repo/units_repo.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/units/manager/search_unit_cubit/search_unit_cubit.dart';
import 'package:pos_app/features/users/data/repo/users_repo.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/features/users/manager/search_user/search_user_cubit.dart';

import '../../features/products/manager/search_product_cubit/search_product_cubit.dart';

class MyServiceLocator {
  static final GetIt getIt = GetIt.instance;

  static void init() {
    registerSingleton<ApiHelper>(ApiHelper(
      dio: getDio(),
    ));
    registerSingleton<PermissionsRepo>(PermissionsRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<CategoryRepo>(CategoryRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<UsersRepo>(UsersRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<ClientsRepo>(ClientsRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<SuppliersRepo>(SuppliersRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<UnitsRepo>(UnitsRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<BranchesRepo>(BranchesRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<ProductsRepo>(ProductsRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<DiscountsRepo>(DiscountsRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<TaxesRepo>(TaxesRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<ExpenseCategoriesRepo>(ExpenseCategoriesRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<StoreQuantityRepo>(StoreQuantityRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<StoreMoveRepo>(StoreMoveRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<SellingPointRepo>(SellingPointRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<RegisterRepo>(RegisterRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<LoginRepo>(LoginRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<SalesRepo>(SalesRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<SalesReturnRepo>(SalesReturnRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<HomeRepo>(HomeRepo(
      api: getSingleton<ApiHelper>(),
    ));
    registerSingleton<ShopSettingRepo>(ShopSettingRepo(
      getSingleton<ApiHelper>(),
    ));
    registerSingleton<GetCategoryCubit>(GetCategoryCubit(
      getIt(),
    ));
    registerSingleton<HomeCubit>(HomeCubit(
      getIt(),
    ));
    registerSingleton<GetPermissionsCubit>(GetPermissionsCubit(
      getIt(),
    ));
    registerSingleton<GetUsersCubit>(GetUsersCubit(
      getIt(),
    ));
    registerSingleton<GetClientsCubit>(GetClientsCubit(
      getIt(),
    ));
    registerSingleton<GetSuppliersCubit>(GetSuppliersCubit(
      getIt(),
    ));
    registerSingleton<GetAllUnitsCubit>(GetAllUnitsCubit(
      getIt(),
    ));
    registerSingleton<GetAllBranchesCubit>(GetAllBranchesCubit(
      getIt(),
    ));
    registerSingleton<GetAllProductsCubit>(GetAllProductsCubit(
      getIt(),
    ));
    registerSingleton<GetAllDiscountsCubit>(GetAllDiscountsCubit(
      getIt(),
    ));
    registerSingleton<GetAllTaxesCubit>(GetAllTaxesCubit(
      getIt(),
    ));
    registerSingleton<GetExpenseCategoriesCubit>(GetExpenseCategoriesCubit(
      getIt(),
    ));
    registerSingleton<StoreQuantityCubit>(StoreQuantityCubit(
      getIt(),
    ));
    registerSingleton<StoreMoveCubit>(StoreMoveCubit(
      getIt(),
    ));
    registerSingleton<SellingPointCubit>(SellingPointCubit(
      getIt(),
    ));
    registerSingleton<SearchPermissionCubit>(SearchPermissionCubit(
      getIt(),
    ));
    registerSingleton<SearchBranchCubit>(SearchBranchCubit(
      getIt(),
    ));
    registerSingleton<SearchCategoryCubit>(SearchCategoryCubit(
      repo: getIt(),
    ));
    registerSingleton<SearchUnitCubit>(SearchUnitCubit(
      getIt(),
    ));
    registerSingleton<SearchTaxesCubit>(SearchTaxesCubit(
      getIt(),
    ));
    registerSingleton<SearchDiscountCubit>(SearchDiscountCubit(
      getIt(),
    ));
    registerSingleton<SearchClientCubit>(SearchClientCubit(
      getIt(),
    ));
    registerSingleton<SellingPointProductCubit>(SellingPointProductCubit(
      getIt(),
    ));
    registerSingleton<SearchProductCubit>(SearchProductCubit(
      getIt(),
    ));
    registerSingleton<GetSalesCubit>(GetSalesCubit(
      getIt(),
    ));
    registerSingleton<SearchUserCubit>(SearchUserCubit(
      getIt(),
    ));
    registerSingleton<GetSalesReturnCubit>(GetSalesReturnCubit(
      getIt(),
    ));
    registerSingleton<ShopSettingCubit>(ShopSettingCubit(
      getIt(),
    ));
  }

  static void registerSingleton<T extends Object>(T instance) {
    getIt.registerSingleton<T>(instance);
  }

  static T getSingleton<T extends Object>() {
    return getIt.get<T>();
  }
}
