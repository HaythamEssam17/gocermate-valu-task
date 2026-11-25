import 'package:flutter/foundation.dart';

class ShellTabController extends ValueNotifier<int> {
  /// 0 Home, 1 Search, 2 Cart, 3 Orders.

  ShellTabController() : super(0);

  void go(int index) => value = index;
}
