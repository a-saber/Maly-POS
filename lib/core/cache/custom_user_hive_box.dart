import 'package:hive/hive.dart';
import 'package:pos_app/features/auth/login/data/model/user_model.dart';

abstract class CustomUserHiveBox {
  static const String boxName = "userBox";
  static const String userKey = "user";
  static late Box<UserModel> box;
  static Future<void> init() async {
    box = await Hive.openBox<UserModel>(boxName);
  }

  static UserModel getUser() {
    return box.get(userKey) as UserModel;
  }

  static Future<void> setUser(UserModel user) async {
    await box.put(userKey, user);
  }

  static void removeUser() {
    box.delete(userKey);
  }
}
