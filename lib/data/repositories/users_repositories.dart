import 'dart:convert';

import 'package:flutter/material.dart';

import '/core/errors/error_handler.dart';
import '/app/services/api/api_response_model.dart';
import '/app/services/api/api_services.dart';
import '/app/services/api/dio_consumer.dart';
import '/app/services/api/end_points.dart';
import '../entities/attedance_entitie.dart';

abstract class UsersRepositories {
  Future<AppResponse> attedance({required String id});
  Future<AppResponse> updatePoint({required String id, required int points});
}

class ImpUsersRepositories implements UsersRepositories {
  final ApiServices api;
  ImpUsersRepositories({required this.api});

  @override
  Future<AppResponse> attedance({required String id}) async {
    AppResponse response = AppResponse(success: false);
    try {
      response.data = await api.request(
        url: EndPoints.baserUrl + EndPoints.attendance,
        method: Method.post,
        requiredToken: false,
        params: {
          ApiKey.id: id,
          ApiKey.attended_at: DateTime.now().toIso8601String(),
        },
      );
      debugPrint(response.data.toString());
      final data = jsonDecode(response.data.toString()) as Map<String, dynamic>;
      response.data = AttedanceEntitie.fromMap(data);
      response.success = true;
    } on ErrorHandler catch (e) {
      response.networkFailure = e.failure;
    }
    return response;
  }

  @override
  Future<AppResponse> updatePoint({
    required String id,
    required int points,
  }) async {
    AppResponse response = AppResponse(success: false);
    try {
      response.data = await api.request(
        url:
            EndPoints.baserUrl +
            EndPoints.updatePointStep1 +
            id +
            EndPoints.updatePointStep2,
        method: Method.post,
        requiredToken: false,
        params: {'points': points},
      );
      debugPrint(response.data.toString());
      final data = jsonDecode(response.data.toString()) as Map<String, dynamic>;
      response.data = data['message'];
      response.success = true;
    } on ErrorHandler catch (e) {
      response.networkFailure = e.failure;
    }
    return response;
  }
}
