import 'dart:convert';

import 'package:bpsock/bpsock.dart';

HookHandler example1 = HookHandler(Tag16('example1'), (handler, tag, id) {
  print('hook: $tag');
  final data = utf8.decode(handler.data[id]!);
  print('data: $data');
});
