/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-08-26 09:21:54
 */
/// 应用内的统一异常定义
class AppExceptionCore implements Exception {
  final String message;
  final String? code;
  final Exception? original;

  AppExceptionCore(this.message, {this.code, this.original});

  @override
  String toString() => 'AppException($code): $message';
}

/// 网络错误
class NetworkExceptionCore extends AppExceptionCore {
  NetworkExceptionCore(super.message, {super.code, super.original});
}

/// 认证错误
class AuthExceptionCore extends AppExceptionCore {
  AuthExceptionCore(super.message, {super.code, super.original});
}

/// 服务端错误
class ServerExceptionCore extends AppExceptionCore {
  ServerExceptionCore(super.message, {super.code, super.original});
}
