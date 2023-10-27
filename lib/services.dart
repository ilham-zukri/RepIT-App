import 'package:shared_preferences/shared_preferences.dart';
import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  static const String url = "http://10.0.2.2:8000";
  static const String apiUrl = "$url/api";
  static late SharedPreferences prefs;

  // static const String url = "http://192.168.1.200:3000/api";

  /// Login ///
  static Future<User?> login(String username, String password) async {
    try {
      var response = await Dio().post(
        "$apiUrl/login",
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
        '$apiUrl/user/current',
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
            role: userResponse.data["data"]["role"]);
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
      var response = await Dio().put('$apiUrl/user/user-name',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {"user_name": username});

      if (response.statusCode == 200) return response;

      return null;
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// change user's username ///
  static Future<Response?> changeEmail(String email) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put('$apiUrl/user/email',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {"email": email});

      if (response.statusCode == 200) return response;
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Logout ///
  static Future<bool> logout(String token) async {
    try {
      var response = await Dio().get(
        '$apiUrl/logout',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (response.statusCode == 200) {
        prefs = await SharedPreferences.getInstance();
        await prefs.clear();
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
        '$apiUrl/asset/myAssets',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['assets'] as List;
      } else if (response.statusCode == 204) {
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// get Supervisor's subordinates ///
  static Future<List?> getMySubordinates() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get('$apiUrl/users/by-department',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ));

      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else if (response.statusCode == 204) {
        return exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// get Location List ///
  static Future<List?> getLocationList() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get('$apiUrl/locations',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ));

      if (response.statusCode == 200) {
        return response.data as List;
      } else if (response.statusCode == 204) {
        return exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// POST Create Asset Request ///
  static Future<Response?> createAssetRequest(String title, String description,
      int priority, String userId, int locationId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/request/create',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          'title': title,
          'description': description,
          'priority': priority,
          'for_user': userId,
          'location_id': locationId
        },
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Accept Asset ///
  static Future<Response?> acceptAsset(int assetId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/asset/accept',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {"asset_id": assetId});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// GET All Asset Requests List with pagination
  static Future<Map?> getListOfRequests(int? page,
      {String? prioritySort,
      String? createdAtSort,
      int? filterLocation}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/requests',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        queryParameters: {
          'page': page ?? 1,
          'priority_sort': prioritySort,
          'created_at_sort': createdAtSort,
          'filter_location': filterLocation
        },
      );
      if (response.statusCode == 200) {
        return response.data as Map;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  static Future<Map?> getMyListOfRequests(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/my-requests',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        queryParameters: {
          'page': page ?? 1,
        },
      );
      if (response.statusCode == 200) {
        return response.data as Map;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Approving Asset Request
  static Future<Response?> approveRequest(int requestId, bool approved) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put("$apiUrl/request/approve",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {"request_id": requestId, "approved": approved});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message'].toString());
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get List of Asset Type
  static Future<List?> getAssetType() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get("$apiUrl/asset-type",
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }));
      if (response.statusCode == 200) {
        return response.data as List;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }

    return null;
  }

  /// POST Purchasing Form
  static Future<Response?> createPurchasingForm(int requestId,
      String vendorName, List<Map<String, dynamic>> items) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post('$apiUrl/purchase',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {
            'request_id': requestId,
            'purchased_from': vendorName,
            'items': items
          });
      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get Priorities
  static Future<List?> getPriorities() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/priorities',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );
      if (response.statusCode == 200) {
        return response.data as List;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get All Purchases with pagination
  static Future<Map?> getPurchases(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/purchases',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        queryParameters: {
          'page': page ?? 1,
        },
      );
      if (response.statusCode == 200) {
        return response.data as Map;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Receive Purchase
  static Future<Response?> receivePurchase(int id) async {
    try{
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
          '$apiUrl/purchase/receive',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {
            'id' : id
          }
      );
      if(response.statusCode == 200){
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    }catch (e){
      exceptionHandling(e);
    }
    return null;
  }

  /// Cancel Purchase
  static Future<Response?> cancelPurchase(int id) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
        '$apiUrl/purchase/cancel',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          'id' : id
        }
      );
      if(response.statusCode == 200){
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
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
