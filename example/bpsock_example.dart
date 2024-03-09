import 'dart:io';

import 'package:bpsock/bpsock.dart';

void main() async {
  var server = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
  await Future.delayed(Duration(seconds: 1));

  Socket socket = await Socket.connect('127.0.0.1', 4040);

  final bpsock = BpSock(socket);
  HookHandler example1 = HookHandler(Tag16('example1'), (handler, data, id) {
    print('hook: $data');
  });
  HookHandler example2 = HookHandler(Tag16('example2'), (handler, data, id) {
    print('hook: $data');
  });

  bpsock.addHook(example1);
  bpsock.addHook(example2);

  bpsock.getAllHooks().forEach((element) {
    print(element.tag);
  });
}
