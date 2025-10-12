import 'package:hive/hive.dart';
import 'package:pos_app/features/auth/login/data/model/branche_model.dart';
import 'package:pos_app/features/auth/login/data/model/pivot_model.dart';
import 'package:pos_app/features/auth/login/data/model/role_model.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

void hiveRegisterAdapter() {
  Hive.registerAdapter(PivotModelAdapter());
  Hive.registerAdapter(BrancheModelAdapter());
  Hive.registerAdapter(RoleModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
}
