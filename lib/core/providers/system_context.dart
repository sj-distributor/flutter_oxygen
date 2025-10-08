/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-10-08 16:26:17
 */
// lib/core/system_context.dart

class SystemContext {
  final String currentProject;
  final String? parentProject;

  const SystemContext({required this.currentProject, this.parentProject});

  bool get isSubSystem => parentProject != null;
}
