import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  // static const String url = "http://10.0.2.2:8000/api";
  static late SharedPreferences prefs;
  static const String url = "http://192.168.1.200:3000/api";

  //// Login ////
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

  //// Get User Data ////
  static Future<User?> getUserData(String token) async {
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
          id: userResponse.data["current_user"]["id"],
          email: userResponse.data["current_user"]["email"],
          token: token,
          name: userResponse.data["current_user"]["name"],
        );
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  //// Logout ////
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
        return true;
      }
      return false;
    } catch (e) {
      throw exceptionHandling(e);
    }
  }

  //// get current User list of assets ////

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

  //// Handling Exception From API ////
  static exceptionHandling(var e) {
    if (e is DioError) {
      if (e.response != null) {
        // throw Exception(e.response!.data["message"]);
        throw e.response!.data["error"].toString();
      } else {
        throw Exception("Terjadi kesalahan pada koneksi.");
      }
    } else {
      throw Exception(e);
    }
  }
}
