import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff36618e),
      surfaceTint: Color(0xff5d5f5f),
      onPrimary: Color(0x00fefdff),
      primaryContainer: Color(0xffd1e4ff),
      onPrimaryContainer: Color(0xff001d36),
      secondary: Color(0xff535f70),
      onSecondary: Color(0xffffffff),
      // 导航栏按钮背景色
      secondaryContainer: Color(0xffd7e3f7),
      // 导航栏按钮图标选中颜色
      onSecondaryContainer: Color(0xff101c2b),
      tertiary: Color(0xff6b5778),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff2daff),
      onTertiaryContainer: Color(0xff251431),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      // 屏幕背景色
      surface: Color(0xfff0f0f0),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444748),
      outline: Color(0xffC3C3C3),
      outlineVariant: Color(0xffc4c7c8),
      shadow: Colors.white60,
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc6c6c7),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1a1c1c),
      primaryFixedDim: Color(0xffc6c6c7),
      onPrimaryFixedVariant: Color(0xff454747),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe2e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc6c6c7),
      onTertiaryFixedVariant: Color(0xff454747),
      surfaceDim: Color(0xffddd9d9),

      surfaceBright: Color(0xfffcf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      // elevatedButtonBackground
      surfaceContainerLow: Color(0xffffffff),
      // 导航栏背景色
      surfaceContainer: Color(0xffffffff),
      // 搜索框背景色
      surfaceContainerHigh: Color(0xfff0f0f0),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }


  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa0cafd),
      surfaceTint: Color(0xffc6c6c7),
      onPrimary: Color(0xff003258),
      primaryContainer: Color(0xff194975),
      onPrimaryContainer: Color(0xffd1e4ff),
      secondary: Color(0xffbbc7db),
      onSecondary: Color(0xff253140),
      // 导航栏按钮背景色
      secondaryContainer: Color(0xff3b4858),
      onSecondaryContainer: Color(0xffd7e3f7),
      tertiary: Color(0xffd6bee4),
      onTertiary: Color(0xff3b2948),
      tertiaryContainer: Color(0xff523f5f),
      onTertiaryContainer: Color(0xfff2daff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111418),
      onSurface: Color(0xffe1e2e8),
      onSurfaceVariant: Color(0xffc3c7cf),
      outline: Color(0xff3e3e3e),
      outlineVariant: Color(0xff444748),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff5d5f5f),
      primaryFixed: Color(0xffe2e2e2),
      onPrimaryFixed: Color(0xff1a1c1c),
      primaryFixedDim: Color(0xffc6c6c7),
      onPrimaryFixedVariant: Color(0xff454747),
      secondaryFixed: Color(0xffe2e2e2),
      onSecondaryFixed: Color(0xff1a1c1c),
      secondaryFixedDim: Color(0xffc6c6c7),
      onSecondaryFixedVariant: Color(0xff454747),
      tertiaryFixed: Color(0xffe2e2e2),
      onTertiaryFixed: Color(0xff1a1c1c),
      tertiaryFixedDim: Color(0xffc6c6c7),
      onTertiaryFixedVariant: Color(0xff454747),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      // 按钮背景色
      surfaceContainerLow: Color(0xff1c1c1c),
      surfaceContainer: Color(0xff201f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353434),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,

    // 按钮主题
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        backgroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.surfaceTint, width: 1),
        ),
      ),
    ),
    // 升级按钮主题
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // minimumSize: Size(200, 50),
        // maximumSize: Size(double.infinity, 50),
        // fixedSize: Size(double.infinity, 50),
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
