import 'dart:async';

import 'package:bpsock/src/core/handler.dart';
import 'package:bpsock/src/utils/tags.dart';
import 'package:bpsock/src/utils/type_def.dart';

class HookHandler extends Handler {
  final Tag16 _tag;
  final ActionFunc _function;
  final StreamController<String> _cancel = StreamController.broadcast();

  HookHandler(this._tag, this._function);

  @override
  String get tag => _tag.name;

  Tag16 get tagRow => _tag;

  @override
  ActionFunc get function => _function;

  @override
  StreamController<String> get cancel => _cancel;

  @override
  void dispose() {
    _cancel.close();
  }
}

class ReqHandler extends Handler {
  final Tag8 _tag;
  final ActionFunc _function;
  final StreamController<String> _cancel = StreamController.broadcast();

  ReqHandler(this._tag, this._function);

  @override
  String get tag => _tag.name;

  Tag8 get tagRow => _tag;

  @override
  ActionFunc get function => _function;

  @override
  StreamController<String> get cancel => _cancel;

  @override
  void dispose() {
    _cancel.close();
  }
}
