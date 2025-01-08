/*
 * @Author: Marlon.M
 * @Email: maiguangyang@163.com
 * @Date: 2024-07-31 20:50:01
 */

/// 设备类型
enum DeviceTypeEnum {
  mobile,
  iPad,
  desktop;

  /// 默认值
  static DeviceTypeEnum getDefault() {
    return desktop;
  }
}
