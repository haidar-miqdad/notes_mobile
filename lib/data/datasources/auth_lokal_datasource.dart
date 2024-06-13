import 'package:notes_app/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel data) async {
    final preps = await SharedPreferences.getInstance();
    await preps.setString('auth_data', data.toJson());
  }

  Future<AuthResponseModel?> getAuthData() async {
    final preps = await SharedPreferences.getInstance();
    final data = preps.getString('auth_data');
    if (data == null) {
      return null; // Return null if no auth data found
    }
    return AuthResponseModel.fromJson(data);
  }

  Future<void> removeAuthData() async {
    final preps = await SharedPreferences.getInstance();
    await preps.remove('auth_data');
  }

  Future<bool> isLogin() async {
    final preps = await SharedPreferences.getInstance();
    return preps.containsKey('auth_data');
  }
}
