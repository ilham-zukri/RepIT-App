import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_classes/ticket.dart';
import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  ///local url
  // static const String url = kIsWeb ? "http://127.0.0.1:8000" : "http://10.0.2.2:8000";

  static const String url = "http://192.168.100.194:8000";

  /// deploy url
  // static const String url = "https://api.repit.tech";

  static const String apiUrl = "$url/api";
  static late SharedPreferences prefs;

  /// Login ///
  static Future<User?> login(String username, String password) async {
    String? fcmToken =
        (!kIsWeb) ? await FirebaseMessaging.instance.getToken() : null;
    try {
      var response = await Dio().post(
        "$apiUrl/login",
        data: {
          'user_name': username,
          'password': password,
          'fcm_token': fcmToken
        },
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
            userName: userResponse.data["data"]["user_name"],
            fullName: userResponse.data["data"]["full_name"],
            empNumber: userResponse.data["data"]["employee_id"],
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
  static Future<Response?> changeUsername(
      String username, String userId) async {
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
  static Future<Response?> changeEmail(String email, String userId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put('$apiUrl/user/email',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {
            "email": email,
            "user_id": userId,
          });

      if (response.statusCode == 200) return response;
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Change User's full name
  static Future<Response?> changeFullName(
      String fullName, String userId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/user/full-name',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        data: {
          "full_name": fullName,
          "user_id": userId,
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Change User's password
  static Future<Response?> changePassword(
      String userId, String password, String oldPassword) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/user/password',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        data: {
          "user_id": userId,
          "password": password,
          "old_password": oldPassword,
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Reset Password
  static Future<Response?> resetPassword(String userId, String password) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put('$apiUrl/user/password/reset',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {
            "user_id": userId,
            "password": password,
          });
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Advanced User Edit
  static Future<Response?> advanceUserEdit(
    String userId,
    int departmentId,
    int branchId,
    roleId,
  ) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/user',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "user_id": userId,
          "department_id": departmentId,
          "branch_id": branchId,
          "role_id": roleId,
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  ///Set User Active
  static Future<Response?> setActive(String userId, bool active) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/user/active',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "user_id": userId,
          "active": active,
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get roles
  static Future<Map?> getRoles() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$apiUrl/user/roles',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'] as Map;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
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

  /// Get All User with search function
  static Future<Map?> getUsers(int? page, String? searchParam) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$apiUrl/users',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        queryParameters: {'page': page ?? 1, 'search_param': searchParam},
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

  /// Get User by Location and Department
  static Future<List?> getUserByLocationAndDepartment(
      int? departmentId, int? branchId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$apiUrl/users/by-location-department',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        queryParameters: {'department_id': departmentId, 'branch_id': branchId},
      );
      if (response.statusCode == 200) {
        return response.data['data'] as List;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Transfer Asset to another user
  static Future<Response?> transferAsset(
      String userId, String utilization, int assetId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/asset/transfer',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          "user_id": userId,
          "utilization": utilization,
          "asset_id": assetId
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Reserve Asset
  static Future<Response?> reserveAsset(int assetId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().put(
        '$apiUrl/asset/reserve',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {"asset_id": assetId},
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// get current User's list of assets ///
  static Future<Map?> getMyAssets(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/asset/myAssets',
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

  /// get Asset By QRcode
  static Future<Map?> getAssetByQrCode(String qrCode) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/asset/qr-code',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          queryParameters: {'qr_code': qrCode});
      if (response.statusCode == 200) {
        return response.data['data'] as Map;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
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

  /// Get Department List
  static Future<List?> getDepartmentList() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$apiUrl/departments',
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
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get Role List
  static Future<List?> getRoleList() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      var response = await Dio().get(
        '$apiUrl/roles',
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
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Add New User
  static Future<Response?> addUser(
      {required String userName,
      required String password,
      String? fullName,
      String? email,
      String? empNumber,
      required int roleId,
      required int departmentId,
      required int locationId}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/user/create',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          'user_name': userName,
          'password': password,
          'full_name': fullName,
          'email': email,
          'employee_id': empNumber,
          'role_id': roleId,
          'department_id': departmentId,
          'branch_id': locationId,
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
      return null;
    }
  }

  /// POST Create Asset Request ///
  static Future<Response?> createAssetRequest(
    String title,
    String description,
    int priority,
    String userId,
  ) async {
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

  /// Scrap Asset
  static Future<Response?> scrapAsset(int assetId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/asset/scrap',
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
  static Future<Response?> createPurchasingForm(
      int requestId,
      String vendorName,
      String description,
      List<Map<String, dynamic>> items) async {
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
            'description': description,
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

  /// Upload Received Purchase Picture
  static Future<Map?> uploadReceivedPurchasePict(
      int purchaseId, File image, String usage) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      FormData formData = FormData.fromMap(
        {
          'purchase_id': purchaseId,
          'image': MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split('/').last,
          ),
        },
      );
      late String endPoint;
      if(usage == 'asset'){
        endPoint = '/purchase/image';
      } else {
        endPoint = '/spare-parts/purchase/picture';
      }
      Response? response = await Dio().post(
        apiUrl+endPoint,
        options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
              "Content-Type": "multipart/form-data",
            }
        ),
        data: formData,
      );
      if (response.statusCode == 201) {
        return response.data as Map;
      } else{
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get Purchased Assets
  static Future<List?> getPurchasedAssets(int purchaseId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/purchase/assets',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          queryParameters: {'purchase_id': purchaseId});
      if (response.statusCode == 200) {
        return response.data['data'] as List;
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

  /// Get Ticket Categories
  static Future<List?> getTicketCategories() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/ticket-categories',
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

  /// Get Asset List for Ticket Form
  static Future<List?> getAssetList() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/asset-list',
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
        return null;
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
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/purchase/receive',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {'id': id});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Cancel Purchase
  static Future<Response?> cancelPurchase(int id) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/purchase/cancel',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {'id': id});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get All Assets
  static Future<Map?> getAllAssets(int? page, String? searchParam) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/assets',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        queryParameters: {'page': page ?? 1, 'search_param': searchParam},
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

  /// Get Received all Purchases
  static Future<Map?> getReceivedPurchases(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/purchases/received',
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

  /// Register Assets from Purchasing
  static Future<Response?> registerAssetFromPurchase(
      {int? purchaseId, List<Map<String, dynamic>>? items}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/asset/create',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {'purchase_id': purchaseId, 'items': items},
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Register Old Asset
  static Future<Response?> registerAsset(Map<String, dynamic> asset) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/asset/create',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: asset,
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Create Ticket
  static Future<Response?> createTicket(Ticket ticket) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();

      FormData formData = FormData.fromMap({
        'asset_id': ticket.assetId,
        'title': ticket.title,
        'description': ticket.description,
        'priority_id': ticket.priorityId,
        'ticket_category_id': ticket.categoryId,
      });

      if (ticket.images != null) {
        for (var image in ticket.images!) {
          formData.files.add(
            MapEntry(
              'images[]',
              MultipartFile.fromFileSync(
                image.path,
                filename: image.path.split('/').last,
              ),
            ),
          );
        }
      }
      Response? response = await Dio().post(
        '$apiUrl/ticket',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data", // Perhatikan tipe konten
          },
        ),
        data: formData,
      );

      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get My Ticket
  static Future<Map?> getMyTickets(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/tickets/my-tickets',
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

  /// Get Handled Ticket
  static Future<Map?> getHandledTickets(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/tickets/handled-tickets',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          queryParameters: {
            'page': page ?? 1,
          });
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

  /// Get All Ongoing Tickets
  static Future<Map?> getAllTickets(int? page, String? searchParam) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/tickets',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          queryParameters: {
            'page': page ?? 1,
            'search_param': searchParam
          });
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

  /// Assign Ticket
  static Future<Map?> assignTicket(int ticketId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/ticket/handle',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {'ticket_id': ticketId});
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

  ///Working on Ticket
  static Future<Map?> workingOnTicket(int ticketId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/ticket/progress',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token"
            },
          ),
          data: {'ticket_id': ticketId});
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

  /// To Be Review Ticket
  static Future<Map?> toBeReviewTicket(int ticketId, String resolveNote) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/ticket/ToBeReviewed',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {'ticket_id': ticketId, 'resolution_note': resolveNote});
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

  /// Close Ticket
  static Future<Map?> closeTicket(int ticketId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/ticket/close',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {'ticket_id': ticketId});
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

  /// Reject to close ticket
  static Future<Map?> rejectToCloseTicket(int ticketId) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put('$apiUrl/ticket/reject',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {'ticket_id': ticketId});
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

  /// Hold Ticket
  static Future<Map?> holdTicket(int ticketId, String handlerNote) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
        '$apiUrl/ticket/hold',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        data: {'ticket_id': ticketId, 'handler_note': handlerNote},
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

  /// Create Spare part Request
  static Future<Response?> createSparePartRequest(
      Map<String, dynamic> data) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/spare-parts/request',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        data: data,
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get all Spare parts requests with pagination
  static Future<Map?> getSparePartRequests(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts/requests',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
        queryParameters: {'page': page ?? 1},
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

  /// Approve Spare part request
  static Future<Response?> approveSparePartRequest(
      int requestId, bool approved) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
          '$apiUrl/spare-parts/request/approve',
          options: Options(headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          }),
          data: {'request_id': requestId, 'approved': approved});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get Spare Part Types
  static Future<List?> getSparePartTypes() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts/available-types',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      if (response.statusCode == 200) {
        return response.data as List;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get All Spare Part Types
  static Future<List?> getAllSparePartTypes() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts/types',
        options: Options(headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        }),
      );
      if (response.statusCode == 200) {
        return response.data as List;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// POST spare part purchase FORM
  static Future<Response?> createSparePartPurchaseForm(
      Map<String, dynamic> data) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/spare-parts/purchase',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        data: data,
      );
      if (response.statusCode == 201) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// GET spare part purchases with pagination
  static Future<Map?> getSparePartPurchases(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts/purchases',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        queryParameters: {'page': page ?? 1},
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

  /// Get Received Spare Part Purchase
  static Future<Map?> getReceivedSparePartPurchases(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts/purchases/received',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        queryParameters: {'page': page ?? 1},
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

  /// Cancel Spare Part Purchase
  static Future<Response?> cancelSparePartPurchase(int id) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response =
          await Dio().put('$apiUrl/spare-parts/purchase/cancel',
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Authorization": "Bearer $token"
                },
              ),
              data: {'id': id});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Receive Spare Part Purchase
  static Future<Response?> receiveSparePartPurchase(int id) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response =
          await Dio().put('$apiUrl/spare-parts/purchase/receive',
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "Authorization": "Bearer $token"
                },
              ),
              data: {'id': id});
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
      }
    } catch (e) {
      exceptionHandling(e);
    }
    return null;
  }

  /// Get All Spare Parts with Filter
  static Future<Map?> getAllSpareParts(
      {required int page, int? typeId, int? statusId}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/spare-parts',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: {
            'page': page,
            'type_id': typeId,
            'status_id': statusId
          });
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

  /// Register Spare Parts From Purchasing
  static Future<Response?> registerSparePartFromPurchase(
      {required int purchaseId,
      required List<Map<String, dynamic>>? items}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/spare-parts',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          'purchase_id': purchaseId,
          'items': items,
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
      return null;
    }
  }

  /// Register Old Spare Part
  static Future<Response?> registerOldSparePart(
      {required int typeId,
      required String brand,
      required String model,
      required String serialNumber}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().post(
        '$apiUrl/spare-parts',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          'type_id': typeId,
          'brand': brand,
          'model': model,
          'serial_number': serialNumber
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
      return null;
    }
  }

  /// Register Spare part to asset
  static Future<Response?> registerSparePartToAsset(
      {required int assetId, required List<int> sparePartsIds}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
        '$apiUrl/spare-parts/deploy',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
        data: {
          'asset_id': assetId,
          'spare_part_ids': sparePartsIds,
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Get Asset's Tickets
  static Future<Map?> getAssetTickets(
      {required int assetId, required int page}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/asset/ticket-history',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: {'page': page, 'asset_id': assetId});
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

  /// Get Asset's Spare Parts
  static Future<Map?> getAssetSpareParts(
      {required int assetId, required int page}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/asset/attached-spare-parts',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: {'page': page, 'asset_id': assetId});
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

  /// Get Performances data
  static Future<Map?> getPerformances({required int page}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get('$apiUrl/performances',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: {'page': page});
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

  /// Update Priority
  static Future<Response?> updatePriority(
      int priorityId, int maxResponseTime, int maxResolveTime) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().put(
        '$apiUrl/priority',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $token"
          },
        ),
        data: {
          'priority_id': priorityId,
          'max_response_time': maxResponseTime,
          'max_resolve_time': maxResolveTime
        },
      );
      if (response.statusCode == 200) {
        return response;
      } else {
        exceptionHandling(response.data['message']);
        return null;
      }
    } catch (e) {
      exceptionHandling(e);
      return null;
    }
  }

  /// Handling Exception From API ///
  static exceptionHandling(var e) {
    if (e is DioException) {
      if (e.response != null) {
        throw e.response!.data["message"].toString();
      } else {
        throw Exception(e.toString());
        // e.response!.data["message"].toString();
      }
    } else {
      throw Exception(e);
    }
  }
}
