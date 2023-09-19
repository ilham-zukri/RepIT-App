import 'package:shared_preferences/shared_preferences.dart';
import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  static const String url = "http://10.0.2.2:8000/api";
  static late SharedPreferences prefs;
  // static const String url = "http://192.168.1.200:3000/api";

  /// Login ///
  static Future<User?> login(String username, String password) async {
    try {
      var response = await Dio().post(
        "$url/login",
        data: {'user_name': username, 'password': password},
        options: Options(
          headers: {
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data.toString());
        return getUserData(prefs.getString('token').toString());
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get User Data ///
  static Future<User?> getUserData(String? token) async {
    try {
      var userResponse = await Dio().get(
        '$url/user/current',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (userResponse.statusCode == 200) {
        return User(
          id: userResponse.data["data"]["id"],
          email: userResponse.data["data"]["email"],
          token: token,
          name: userResponse.data["data"]["user_name"],
          branch: userResponse.data["data"]["branch"],
          department: userResponse.data["data"]["department"],
          role: userResponse.data["data"]["role"]["role_name"]
        );
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// change user's username ///
  static Future<Response?> changeUsername(String username) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$url/user/user-name',
        options: Options(
          headers: {
            "Accept" : "application/json",
            "Authorization" : "Bearer $token"
          }
        ),
        data: {
          "user_name" : username
        }
      );

      if (response.statusCode == 200) return response;

      return null;
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// change user's username ///
  static Future<Response?> changeEmail(String email) async {
    try{
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
          '$url/user/email',
          options: Options(
              headers: {
                "Accept" : "application/json",
                "Authorization" : "Bearer $token"
              }
          ),
          data: {
            "email" : email
          }
      );

      if(response.statusCode == 200) return response;
    } catch(e){
      exceptionHandling(e);
    }
    return null;

  }

  /// Logout ///
  static Future<bool> logout(String token) async {
    try {
      var response = await Dio().get(
        '$url/logout',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        prefs.clear();
        return true;
      }
      return false;
    } catch (e) {
      throw exceptionHandling(e);
    }
  }

  /// get current User's list of assets ///
  static Future<List?> getMyAssets() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$url/asset/myAssets',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );

      if(response.statusCode == 200){
        return response.data['assets'] as List;
      } else if(response.statusCode == 204){
        return null;
      }

    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// get Supervisor's subordinates ///
  static Future<List?> getMySubordinates() async {
    try{
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$url/api/users/by-department',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        )
      );

      if(response.statusCode == 200){
        return response.data['data'] as List;
      } else if(response.statusCode == 204){
        return null;
      }

    }catch (e){
      exceptionHandling(e);
    }
    return null;
  }


  /// Handling Exception From API ///
  static exceptionHandling(var e) {
    if (e is DioError) {
      if (e.response != null) {
        throw e.response!.data["message"].toString();
      } else {
        throw Exception("Terjadi kesalahan pada koneksi.");
      }
    } else {
      throw Exception(e);
    }
  }
}
