import 'dart:convert';
import 'dart:io';

import 'package:bpsock/bpsock.dart';

void main(List<String> args) async {
  final serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
  serverSocket.listen((Socket socket) {
    socket.listen((List<int> event) {
      final bpsock = BpSock(socket);
      HookHandler example1 = HookHandler(Tag16('text'), (handler, tagName, id) {
        var data = utf8.decode(handler.data[id]!);
        print(data);
      });

      bpsock.addHook(example1);
    });
  });
}
