/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2025-04-15 20:38:31
 */
import 'package:web/web.dart' as web;

class WebWrapper {
  static void setTitle(String title) {
    web.document.title = title;
  }
}
