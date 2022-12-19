import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

extension LayoutExtension on BuildContext {
  bool get isDesktop => breakpoint >= LayoutBreakpoint.lg;

  bool get isLaptop => breakpoint == LayoutBreakpoint.md;

  bool get isMobile => breakpoint <= LayoutBreakpoint.sm;
}
