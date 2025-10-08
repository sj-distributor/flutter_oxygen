/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-08-26 09:22:08
 */
import 'package:dio/dio.dart';
import 'package:flutter_oxygen/core/l10n/index.dart';

import 'app_exception.dart';

/// 把 Dio 或其他异常转成统一的 AppExceptionCore
class ErrorMapper {
  ErrorMapper(this.lang);

  final AppLocalizations lang;

  AppExceptionCore map(Exception error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return NetworkExceptionCore(lang.sendTimeout, original: error);
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) {
            return AuthExceptionCore(
              lang.authException,
              code: "401",
              original: error,
            );
          }
          return ServerExceptionCore(
            "${lang.serverException}($statusCode)",
            original: error,
          );
        default:
          return NetworkExceptionCore(lang.networkException, original: error);
      }
    }

    return AppExceptionCore(lang.appException, original: error);
  }
}
