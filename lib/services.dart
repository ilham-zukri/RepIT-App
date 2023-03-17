import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  // static const String url = "http://10.0.2.2:8000/api";
  static const String url = "http://192.168.100.250:8000/api";
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
        var userResponse = await Dio().get(
          "$url/user/current",
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer ${response.data.toString()}"
            },
          ),
        );

        if (userResponse.statusCode == 200) {
          return User(
            id: userResponse.data["current_user"]["id"],
            email: userResponse.data["current_user"]["email"],
            token: response.data.toString(),
            name: userResponse.data["current_user"]["name"],
          );
        }
      }

      return null;
    } catch (e) {
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

      // throw Exception(e);
    }
  }
}
