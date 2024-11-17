// ignore_for_file: unnecessary_null_comparison

/* RESPONSIVE SIZE */

// class Responsive {
//   static double _screenWidth = 0;
//   static double _screenHeight = 0;
//   static double _blockSizeHorizontal = 0;
//   static double _blockSizeVertical = 0;
//   static double text = 0;
//   static double radius = 0;
//   static double height = 0;
//   static double width = 0;
//   static bool isPortrait = true;
//   static bool isMobilePortrait = false;

//   void init(BoxConstraints constraints, Orientation orientation) {
//     if (orientation == Orientation.portrait) {
//       _screenWidth = constraints.maxWidth;
//       _screenHeight = constraints.maxHeight;
//       isPortrait = true;
//       if (_screenWidth < 450) {
//         isMobilePortrait = true;
//       }
//     } else {
//       _screenWidth = constraints.maxHeight;
//       _screenHeight = constraints.maxWidth;
//       isPortrait = false;
//       isMobilePortrait = false;
//     }

//     _blockSizeHorizontal = _screenWidth / 100;
//     _blockSizeVertical = _screenHeight / 100;

//     text = _blockSizeVertical;
//     radius = _blockSizeHorizontal;
//     height = _blockSizeVertical;
//     width = _blockSizeHorizontal;
//   }
// }
import 'package:flutter/material.dart';

class Responsive {
  // Private constructor to enforce singleton
  Responsive._();
  static final Responsive _instance = Responsive._();

  // Factory constructor to return singleton instance
  factory Responsive() => _instance;

  // Screen information
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  // Breakpoints
  static const double mobileBreakpoint = 450;
  static const double tabletBreakpoint = 768;
  static const double desktopBreakpoint = 1024;

  // Device type flags
  static bool isMobile = false;
  static bool isTablet = false;
  static bool isDesktop = false;

  // Orientation flags
  static bool isPortrait = true;

  // Commonly used sizes
  late double text;
  late double radius;
  late double height;
  late double width;

  void init(BoxConstraints constraints, Orientation orientation) {
    // Set screen dimensions based on orientation
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
    } else {
      screenWidth = constraints.maxHeight;
      screenHeight = constraints.maxWidth;
      isPortrait = false;
    }

    // Calculate relative block sizes
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    // Set device type based on width
    isMobile = screenWidth < mobileBreakpoint;
    isTablet =
        screenWidth >= mobileBreakpoint && screenWidth < tabletBreakpoint;
    isDesktop = screenWidth >= desktopBreakpoint;

    // Set commonly used dimensions
    text = blockSizeVertical;
    radius = blockSizeHorizontal;
    height = blockSizeVertical;
    width = blockSizeHorizontal;
  }

  // Helper methods for responsive values
  static double wp(double percentage) => blockSizeHorizontal * percentage;
  static double hp(double percentage) => blockSizeVertical * percentage;
  static double rp(double percentage) => blockSizeHorizontal * percentage;

  // Get responsive font size
  static double sp(double size) {
    final baseFontSize = isTablet
        ? size * 1.2
        : isDesktop
            ? size * 1.4
            : size;
    return baseFontSize * (blockSizeVertical / 6.4);
  }
}

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            Responsive().init(constraints, orientation);
            return child;
          },
        );
      },
    );
  }
}

/* RESPONSIVE SIZE */

extension ListExtension<T> on List<T>? {
  bool isListNullOrEmpty() {
    return this == null || this?.isEmpty == true;
  }
}

extension StringExtension on String? {
  bool isNullOrEmpty() {
    return this == null || this == '';
  }
}

extension IntExtension on int? {
  int getOrZero() {
    return this ?? 0;
  }
}
