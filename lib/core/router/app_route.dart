import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/core/helper/my_service_locator.dart';
import 'package:pos_app/core/helper/printer_helper.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';
import 'package:pos_app/features/auth/login/view/login_view.dart';
import 'package:pos_app/features/auth/register/view/register_view.dart';
import 'package:pos_app/features/branch/manager/get_all_branches_cubit/get_all_branches_cubit.dart';
import 'package:pos_app/features/branch/view/add_branch_view.dart';
import 'package:pos_app/features/branch/view/branches_view.dart';
import 'package:pos_app/features/branch/view/edit_branch_view.dart';
import 'package:pos_app/features/categories/data/model/category_model.dart';
import 'package:pos_app/features/categories/manager/get_category/get_category_cubit.dart';
import 'package:pos_app/features/categories/view/add_category_view.dart';
import 'package:pos_app/features/categories/view/categories_view.dart';
import 'package:pos_app/features/categories/view/edit_category_view.dart';
import 'package:pos_app/features/clients/data/model/customer_model.dart';
import 'package:pos_app/features/clients/manager/get_clients/get_clients_cubit.dart';
import 'package:pos_app/features/clients/view/add_client_view.dart';
import 'package:pos_app/features/clients/view/clients_view.dart';
import 'package:pos_app/features/clients/view/edit_client_view.dart';
import 'package:pos_app/features/discounts/data/model/discount_model.dart';
import 'package:pos_app/features/discounts/manager/get_all_discounts_cubit/get_all_discounts_cubit.dart';
import 'package:pos_app/features/discounts/view/add_discount_view.dart';
import 'package:pos_app/features/discounts/view/discounts_view.dart';
import 'package:pos_app/features/discounts/view/edit_discount_view.dart';
import 'package:pos_app/features/expense_categories/data/model/expense_categories_model.dart';
import 'package:pos_app/features/expense_categories/manager/get_expense_categories_cubit/get_expense_categories_cubit.dart';
import 'package:pos_app/features/expense_categories/presentation/add_expense_categories_view.dart';
import 'package:pos_app/features/expense_categories/presentation/edit_expense_categories_view.dart';
import 'package:pos_app/features/expense_categories/presentation/expense_categories_view.dart';
import 'package:pos_app/features/home/manager/cubit/home_cubit.dart';
import 'package:pos_app/features/home/view/home_view.dart';
import 'package:pos_app/features/home/view/profile_view.dart';
import 'package:pos_app/features/home/view/setting_view.dart';
import 'package:pos_app/features/permissions/manager/get_permission/get_permissions_cubit.dart';
import 'package:pos_app/features/permissions/view/add_permission_view.dart';
import 'package:pos_app/features/permissions/view/edit_permission_view.dart';
import 'package:pos_app/features/permissions/view/permissions_view.dart';
import 'package:pos_app/features/printer/view/add_printer_view.dart';
import 'package:pos_app/features/printer/view/printer_detailes.dart';
import 'package:pos_app/features/printer/view/printerview.dart';
import 'package:pos_app/features/products/data/model/product_model.dart';
import 'package:pos_app/features/products/manager/get_all_products_cubit/get_all_products_cubit.dart';
import 'package:pos_app/features/products/view/add_product_view.dart';
import 'package:pos_app/features/products/view/edit_product_view.dart';
import 'package:pos_app/features/products/view/products_view.dart';
import 'package:pos_app/features/sales/data/model/sales_model.dart';
import 'package:pos_app/features/sales/manager/get_sales_cubit/get_sales_cubit.dart';
import 'package:pos_app/features/sales/view/return_sales_confirm_view.dart';
import 'package:pos_app/features/sales/view/sales_details_view.dart';
import 'package:pos_app/features/sales/view/sales_view.dart';
import 'package:pos_app/features/sales_returns/data/model/sales_return_model.dart';
import 'package:pos_app/features/sales_returns/manager/get_sales_return_cubit/get_sales_return_cubit.dart';
import 'package:pos_app/features/sales_returns/view/sales_return_details_view.dart';
import 'package:pos_app/features/sales_returns/view/sales_return_view.dart';
import 'package:pos_app/features/selling_point/manager/selling_point_cubit/selling_point_cubit.dart';
import 'package:pos_app/features/selling_point/view/selling_point_card_view.dart';
import 'package:pos_app/features/selling_point/view/selling_point_view.dart';
import 'package:pos_app/features/shop_setting/manager/cubit/shop_setting_cubit.dart';
import 'package:pos_app/features/shop_setting/view/shop_setting_view.dart';
import 'package:pos_app/features/splash/splash_view.dart';
import 'package:pos_app/features/store_move/data/model/store_movement_data.dart';
import 'package:pos_app/features/store_move/manager/store_move_cubit/store_move_cubit.dart';
import 'package:pos_app/features/store_move/view/store_move_details_view.dart';
import 'package:pos_app/features/store_move/view/store_move_view.dart';
import 'package:pos_app/features/store_quantity/manager/store_quantity_cubit/store_quantity_cubit.dart';
import 'package:pos_app/features/store_quantity/view/store_quantity_view.dart';
import 'package:pos_app/features/suppliers/data/models/supplier_model.dart';
import 'package:pos_app/features/suppliers/manager/get_suppliers/get_suppliers_cubit.dart';
import 'package:pos_app/features/suppliers/views/add_supplier_view.dart';
import 'package:pos_app/features/suppliers/views/edit_supplier_view.dart';
import 'package:pos_app/features/suppliers/views/suppliers_view.dart';
import 'package:pos_app/features/taxes/data/model/taxes_model.dart';
import 'package:pos_app/features/taxes/manager/get_all_taxes_cubit/get_all_taxes_cubit.dart';
import 'package:pos_app/features/taxes/view/add_taxes_view.dart';
import 'package:pos_app/features/taxes/view/edit_taxes_view.dart';
import 'package:pos_app/features/taxes/view/taxes_view.dart';
import 'package:pos_app/features/units/data/model/unit_model.dart';
import 'package:pos_app/features/units/manager/get_all_units_cubit/get_all_units_cubit.dart';
import 'package:pos_app/features/units/view/add_unit_view.dart';
import 'package:pos_app/features/units/view/edit_unit_view.dart';
import 'package:pos_app/features/units/view/units_view.dart';
import 'package:pos_app/features/users/manager/get_users/get_users_cubit.dart';
import 'package:pos_app/features/users/view/add_user_view.dart';
import 'package:pos_app/features/users/view/edit_user_view.dart';
import 'package:pos_app/features/users/view/user_view.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String addCategory = '/addCategory';
  static const String editCategory = '/editCategory';
  static const String addClient = '/addClient';
  static const String editClient = '/editClient';
  static const String profile = '/profile';
  static const String settingsView = '/settings';
  static const String sellingPointsView = '/sellingPoints';
  static const String categories = '/categories';
  static const String users = '/users';
  static const String addUser = '/addUser';
  static const String editUser = '/editUser';
  static const String permissions = '/permissions';
  static const String editPermission = '/editPermission';
  static const String addPermission = '/addPermission';

  static const String suppliers = '/suppliers';
  static const String addSupplier = '/addSupplier';
  static const String editSupplier = '/editSupplier';
  static const String clients = '/clients';
  static const String products = '/products';
  static const String addProduct = '/addProduct';
  static const String editProduct = '/editProduct';
  static const String units = '/units';
  static const String addUnit = '/addUnit';
  static const String editUnit = '/editUnit';
  static const String branches = '/branches';
  static const String addBranch = '/addBranch';
  static const String editBranch = '/editBranch';
  static const String discounts = '/discounts';
  static const String addDiscount = '/addDiscount';
  static const String editDiscount = '/editDiscount';
  static const String taxes = '/taxes';
  static const String addTaxes = '/addTaxes';
  static const String editTaxes = '/editTaxes';
  static const String storequantity = '/storequantity';
  static const String storeMoveView = '/storeMoveView';
  static const String printersView = '/printersView';
  static const String storeMoveDetailsView = '/storeMoveDetailsView';
  static const String expenseCategoriesView = '/expenseCategoriesView';
  static const String addexpenseCategoriesView = '/addexpenseCategoriesView';
  static const String editexpenseCategoriesView = '/editexpenseCategoriesView';
  static const String salesView = '/salesView';
  static const String salesDetailsView = '/salesDetailsView';
  static const String returnSalesConfirm = '/returnSalesConfirm';
  static const String salesReturnView = '/salesReturnView';
  static const String salesReturnDetailsView = '/salesReturnDetailsView';
  static const String shopSettingView = '/shopSettingView';
  static const String sellingPointCardView = '/sellingPointCardView';
  static const String addPrinter = '/addPrinter';
  static const String printerDetails = '/printerDetails';

  // Custom route with left-to-right + fade transition
  static PageRouteBuilder customGetPageRouteBuilder({
    required Widget page,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionsBuilder,
  }) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: transitionsBuilder ??
          (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut));

            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
      transitionDuration: transitionDuration,
    );
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    try {
      switch (settings.name) {
        case splash:
          return customGetPageRouteBuilder(
            page: const SplashView(),
          );

        case login:
          return customGetPageRouteBuilder(
            page: const LoginView(),
          );

        case register:
          return customGetPageRouteBuilder(
            page: const RegisterView(),
          );

        case home:
          return customGetPageRouteBuilder(
            page: HomeView(),
          );
        case addCategory:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getSingleton<GetCategoryCubit>(),
              child: const AddCategoryView(),
            ),
          );
        case editCategory:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getSingleton<GetCategoryCubit>(),
              child: EditCategoryView(
                category: (settings.arguments as CategoryModel),
              ),
            ),
          );
        case addClient:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetClientsCubit>(),
              child: const AddClientView(),
            ),
          );
        case editClient:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetClientsCubit>(),
              child: EditClientView(
                client: (settings.arguments as CustomerModel),
              ),
            ),
          );
        case expenseCategoriesView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetExpenseCategoriesCubit>()
                ..init(),
              child: ExpenseCategoriesView(),
            ),
          );
        case addexpenseCategoriesView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetExpenseCategoriesCubit>(),
              child: AddExpenseCategoriesView(),
            ),
          );
        case editexpenseCategoriesView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetExpenseCategoriesCubit>(),
              child: EditExpenseCategoriesView(
                expenseCategories:
                    (settings.arguments as ExpenseCategoriesModel),
              ),
            ),
          );
        case profile:
          return customGetPageRouteBuilder(
            page: const ProfileView(),
          );
        case settingsView:
          return customGetPageRouteBuilder(
            page: const SettingsView(),
          );
        case sellingPointsView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<SellingPointCubit>()..init(),
              child: SellingPointView(),
            ),
          );
        case sellingPointCardView:
          return customGetPageRouteBuilder(
            page: SellingPointCardView(),
          );
        case categories:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetCategoryCubit>()..init(),
              child: const CategoriesView(),
            ),
          );
        case users:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetUsersCubit>()..init(),
              child: const UsersView(),
            ),
          );
        case addUser:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetUsersCubit>(),
              child: const AddUserView(),
            ),
          );
        case editUser:
          return customGetPageRouteBuilder(
            page: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: MyServiceLocator.getSingleton<HomeCubit>(),
                ),
                BlocProvider.value(
                  value: MyServiceLocator.getIt<GetUsersCubit>(),
                ),
              ],
              child: EditUserView(
                user: (settings.arguments as UserModel),
              ),
            ),
          );
        case units:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllUnitsCubit>()..init(),
              child: const UnitsView(),
            ),
          );
        case addUnit:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllUnitsCubit>(),
              child: const AddUnitView(),
            ),
          );
        case editUnit:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllUnitsCubit>(),
              child: EditUnitView(
                unit: (settings.arguments as UnitModel),
              ),
            ),
          );
        case discounts:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllDiscountsCubit>()..init(),
              child: const DiscountsView(),
            ),
          );
        case addDiscount:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllDiscountsCubit>(),
              child: const AddDiscountView(),
            ),
          );
        case editDiscount:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllDiscountsCubit>(),
              child: EditDiscountView(
                discount: (settings.arguments as DiscountModel),
              ),
            ),
          );
        case taxes:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllTaxesCubit>()..init(),
              child: const TaxesView(),
            ),
          );
        case addTaxes:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllTaxesCubit>(),
              child: const AddTaxesView(),
            ),
          );
        case editTaxes:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllTaxesCubit>(),
              child: EditTaxesView(
                taxes: (settings.arguments as TaxesModel),
              ),
            ),
          );
        case branches:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllBranchesCubit>()
                ..init(
                  haveScrollController: true,
                ),
              child: const BranchesView(),
            ),
          );
        case addBranch:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllBranchesCubit>(),
              child: const AddBranchView(),
            ),
          );
        case editBranch:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllBranchesCubit>(),
              child: EditBranchView(
                branch: (settings.arguments as BrancheModel),
              ),
            ),
          );
        case permissions:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetPermissionsCubit>()
                ..init(haveScrollController: true),
              child: const PermissionsView(),
            ),
          );
        case suppliers:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetSuppliersCubit>()..init(),
              child: const SuppliersView(),
            ),
          );
        case addSupplier:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetSuppliersCubit>(),
              child: const AddSupplierView(),
            ),
          );
        case editSupplier:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetSuppliersCubit>(),
              child: EditSupplierView(
                supplier: (settings.arguments as SupplierModel),
              ),
            ),
          );
        case clients:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetClientsCubit>()..init(),
              child: const ClientsView(),
            ),
          );
        case editPermission:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetPermissionsCubit>(),
              child: EditPermissionView(
                permission: settings.arguments as RoleModel,
              ),
            ),
          );
        case addPermission:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetPermissionsCubit>(),
              child: const AddPermissionView(),
            ),
          );
        case products:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllProductsCubit>()..init(),
              child: ProductsView(),
            ),
          );
        case addProduct:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllProductsCubit>(),
              child: AddProductView(),
            ),
          );
        case editProduct:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetAllProductsCubit>(),
              child: EditProductView(
                product: settings.arguments as ProductModel,
              ),
            ),
          );
        case storequantity:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<StoreQuantityCubit>()..init(),
              child: StoreQuantityView(),
            ),
          );
        case storeMoveView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<StoreMoveCubit>()..init(),
              child: StoreMoveView(),
            ),
          );
        case storeMoveDetailsView:
          return customGetPageRouteBuilder(
            page: StoreMoveDetailsView(
              storeMove: settings.arguments as StoreMovementData,
            ),
          );
        case salesView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetSalesCubit>()..init(),
              child: SalesView(),
            ),
          );
        case salesDetailsView:
          return customGetPageRouteBuilder(
            page: SalesDetailsView(
              salesModel: settings.arguments as SalesModel,
            ),
          );
        case salesReturnView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<GetSalesReturnCubit>()..init(),
              child: SalesReturnView(),
            ),
          );
        case shopSettingView:
          return customGetPageRouteBuilder(
            page: BlocProvider.value(
              value: MyServiceLocator.getIt<ShopSettingCubit>()..init(),
              child: ShopSettingView(),
            ),
          );
        case salesReturnDetailsView:
          return customGetPageRouteBuilder(
            page: SalesReturnDetailsView(
              salesReturnModel: settings.arguments as SalesReturnModel,
            ),
          );
        case returnSalesConfirm:
          return customGetPageRouteBuilder(
            page: ReturnSalesConfirmView(
              salesModel: settings.arguments as SalesModel,
            ),
          );
        case printersView:
          return customGetPageRouteBuilder(
            page: const PrintersView(),
          );
        // TODO: add printer view
        // case printersView:
        // return customGetPageRouteBuilder(
        //   page: PrintersView(
        //
        //   ),
        // );
        case addPrinter:
          return customGetPageRouteBuilder(
            page: const AddPrinterView(),
          );
        case printerDetails:
          return customGetPageRouteBuilder(
            page: PrinterDetailsView(
              printer: settings.arguments as DiscoveredPrinter,
            ),
          );

        default:
          throw Exception("Route not found: ${settings.name}");
      }
    } catch (e) {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text("404 - Page Not Found\n${e.toString()}")),
        ),
      );
    }
  }
}
