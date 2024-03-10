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
  late final Tag16 _tag;
  final ActionFunc _function;
  final StreamController<String> _cancel = StreamController.broadcast();

  ReqHandler(Tag8 tag, this._function) {
    //Generate a tag ephemera starting with 1
    final String microsecond = DateTime.now().microsecondsSinceEpoch.toString();
    String subTag = microsecond.substring(2, microsecond.length - 3);
    subTag = int.parse(subTag).toRadixString(32);
    _tag = Tag16('1$subTag${tag.name}');
  }

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

class ReqPoint extends Handler {
  final Tag8 _tag;
  final ActionFunc _function;
  final StreamController<String> _cancel = StreamController.broadcast();

  ReqPoint(this._tag, this._function);

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
