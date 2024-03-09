import 'package:bpsock/src/utils/type_def.dart';

abstract class Handler {
  String get tag;
  ActionFunc get function;
  Stream<String> get cancel;

  void dispose();
}
