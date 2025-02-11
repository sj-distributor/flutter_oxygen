import 'package:flutter/rendering.dart';

/// Defines a single color as well a color swatch with ten shades of the color.
class ThemeColor extends ColorSwatch<int> {
  /// Creates a color swatch and a set of 10 shades of the color.
  const ThemeColor(super.primary, super.swatch);

  /// Color-1
  Color get shade100 => this[100]!;

  /// Color-2
  Color get shade200 => this[200]!;

  /// Color-3
  Color get shade300 => this[300]!;

  /// Color-4
  Color get shade400 => this[400]!;

  /// Color-5
  Color get shade500 => this[500]!;

  /// Color-6, normally this is the primary color
  Color get shade600 => this[600]!;

  /// Color-7
  Color get shade700 => this[700]!;

  /// Color-8
  Color get shade800 => this[800]!;

  /// Color-9
  Color get shade900 => this[900]!;

  /// Color-10
  Color get shade1000 => this[1000]!;

  Color get primary => shade600;

  /// 白色：#ffffff \
  /// 最纯的白色，常用于背景或高亮区域
  Color get white => neutral.shade100;

  /// 灰白：#fafafa \
  /// 极浅的灰，接近白色但有轻微冷感，适合柔和背景
  Color get grayWhite => neutral.shade200;

  /// 浅灰：#f5f5f5 \
  /// 常见于组件背景或分隔线，视觉上轻盈
  Color get lightGray => neutral.shade300;

  /// 银灰：#f0f0f0 \
  /// 中性浅灰，适合次级背景或悬浮效果
  Color get silverGray => neutral.shade400;

  /// 中灰：#d9d9d9 \
  /// 中等明度的灰色，常用于边框或禁用状态
  Color get mediumGray => neutral.shade500;

  /// 岩石灰：#bfbfbf \
  /// 稍深的灰色，适合次级文本或图标
  Color get stoneGray => neutral.shade600;

  /// 炭灰：#8c8c8c \
  /// 较暗的灰，用于正文文本或次要内容
  Color get charcoalGray => neutral.shade700;

  /// 深灰：#595959 \
  /// 强调性文本或重要图标，对比度适中
  Color get darkGray => neutral.shade800;

  /// 墨灰：#434343 \
  /// 接近黑色的深灰，适合标题或高对比元素
  Color get inkGray => neutral.shade900;

  /// 暗黑灰：#262626 \
  /// 极深灰，常用于深色模式下的背景或强调
  Color get darkCharcoal => neutral.shade1000;

  /// 午夜灰：#1f1f1f \
  /// 接近纯黑的深灰，用于高对比场景
  Color get midnightGray => neutral.shade1100;

  /// 黑灰：#141414 \
  /// 几乎黑色，但保留微弱灰度层次
  Color get blackGray => neutral.shade1200;

  /// 黑色：#000000 \
  /// 纯黑色，用于正文或核心元素
  Color get black => neutral.shade1300;

  /// ## 中性色板 neutral color palette
  /// 中性色包含了黑、白、灰。在蚂蚁中后台的网页设计中被大量使用到，
  /// 合理地选择中性色能够令页面信息具备良好的主次关系，助力阅读体验。
  /// Ant Design 的中性色板一共包含了从白到黑的 13 个颜色。
  static const neutral = NeutralColor(0xffbfbfbf, <int, Color>{
    100: Color(0xffffffff),
    200: Color(0xfffafafa),
    300: Color(0xfff5f5f5),
    400: Color(0xfff0f0f0),
    500: Color(0xffd9d9d9),
    600: Color(0xffbfbfbf),
    700: Color(0xff8c8c8c),
    800: Color(0xff595959),
    900: Color(0xff434343),
    1000: Color(0xff262626),
    1100: Color(0xff1f1f1f),
    1200: Color(0xff141414),
    1300: Color(0xff000000),
  });

  /// generate ThemeColor from primary Color.
  static ThemeColor generate(Color primaryColor) {
    final hsv = HSVColor.fromColor(primaryColor);
    Map<int, Color> swatch = {};
    for (var i = 1; i <= 10; i++) {
      final isLight = i <= 6;
      final distance = (6 - i).abs();
      final hue = _computeHue(hsv.hue, isLight, distance);
      final saturation = _computeSaturation(hsv, isLight, distance);
      final value = _computeValue(hsv.value, isLight, distance);
      if (i == 6) {
        swatch[i * 100] = primaryColor;
      } else {
        swatch.putIfAbsent(
          i * 100,
          () => HSVColor.fromAHSV(1, hue, saturation, value).toColor(),
        );
      }
    }
    return ThemeColor(primaryColor.value, swatch);
  }

  /// get computed hue
  static double _computeHue(double hue, bool light, int distance) {
    const hueStep = 2;

    hue = hue.roundToDouble();

    late double result;
    if (hue >= 60 && hue <= 240) {
      result = light ? hue - hueStep * distance : hue + hueStep * distance;
    } else {
      result = light ? hue + hueStep * distance : hue - hueStep * distance;
    }

    if (result < 0) {
      result += 360;
    } else if (result >= 360) {
      result -= 360;
    }

    return result;
  }

  /// get computed saturation
  static double _computeSaturation(HSVColor color, bool isLight, int distance) {
    final saturation = color.saturation;
    if (color.saturation == 0 && color.hue == 0) return saturation;
    const saturationStep = 0.16;
    const saturationStep2 = 0.05;
    late double result;
    if (isLight) {
      result = saturation - saturationStep * distance;
    } else if (distance == 4) {
      result = saturation + saturationStep;
    } else {
      result = saturation + saturationStep2 * distance;
    }
    if (result > 1) {
      result = 1;
    }
    if (isLight && distance == 5 && saturation > 0.1) {
      result = 0.1;
    }
    if (result < 0.06) {
      result = 0.06;
    }

    return double.parse(result.toStringAsFixed(2));
  }

  /// get computed hsv value
  static double _computeValue(double value, bool isLight, int distance) {
    const brightnessStep1 = 0.05;
    const brightnessStep2 = 0.15;
    late double result;
    if (isLight) {
      result = value + brightnessStep1 * distance;
    } else {
      result = value - brightnessStep2 * distance;
    }
    if (result > 1) {
      result = 1;
    }
    return double.parse(result.toStringAsFixed(2));
  }

  /// convert color to hex
  static String colorToHex(Color color) {
    final hexColorStr = '#'
        '${color.red.toRadixString(16).padLeft(2, '0')}'
        '${color.green.toRadixString(16).padLeft(2, '0')}'
        '${color.blue.toRadixString(16).padLeft(2, '0')}';
    return hexColorStr.toUpperCase();
  }
}

/// Defines a single color as well a color swatch with ten shades of the color.
/// same as AntColor but has 3 more shades of the color.

class NeutralColor extends ThemeColor {
  /// Creates a color swatch and a set of 13 shades of the color.
  const NeutralColor(super.primary, super.swatch);

  /// Color-11
  Color get shade1100 => this[1100]!;

  /// Color-12
  Color get shade1200 => this[1200]!;

  /// Color-13
  Color get shade1300 => this[1300]!;
}

/// A color that is represented in hexadecimal format.
Color hexColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // 默认 Alpha 为 FF（不透明）
  }
  return Color(int.parse(hexColor, radix: 16));
}
