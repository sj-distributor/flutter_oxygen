/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-10-08 16:26:39
 */

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'system_context.dart';

final systemContextProvider = Provider<SystemContext>((ref) {
  return const SystemContext(currentProject: 'main_app'); // 默认主系统
});
