import 'package:shared_preferences/shared_preferences.dart';
import 'data_classes/ticket.dart';
import 'data_classes/user.dart';
import 'package:dio/dio.dart';

abstract class Services {
  static const String url = "http://10.0.2.2:8000";
  static const String apiUrl = "$url/api";
  static late SharedPreferences prefs;

  // static const String url = "http://192.168.1.200:3000/";

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
  static Future<Map?> getAllAssets(int? page) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/assets',
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
  static Future<Map?> getAllTickets(int? page) async {
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
      Response? response = await Dio().put('$apiUrl/spare-parts/purchase/cancel',
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
      Response? response = await Dio().put('$apiUrl/spare-parts/purchase/receive',
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
  static Future<Map?> getAllSpareParts({required int page, int? typeId, int? statusId}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token').toString();
      Response? response = await Dio().get(
        '$apiUrl/spare-parts',
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
        }
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
