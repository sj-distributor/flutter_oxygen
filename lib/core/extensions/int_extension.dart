/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-09-15 13:56:59
 */
import 'package:intl/intl.dart';

extension CoreIntOptionalExtensionsCore on int? {
  bool get isNullOrZero => this == null || this == 0;

  bool get isNotNullAndZero => this != null && this! != 0;

  static NumberFormat formatter = NumberFormat("#,###");
  String get formatThousand => formatter.format(this);
}
