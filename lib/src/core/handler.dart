import 'dart:async';

import 'package:bpsock/src/utils/type_def.dart';

abstract class Handler {
  String get tag;
  ActionFunc get function;
  StreamController<String> get cancel;
  Map<int, List<int>> data = {};

  void dispose();
}
