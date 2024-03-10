import 'dart:io';
import 'dart:typed_data';

import 'package:bpsock/bpsock.dart';

import 'src/hooks.dart';

void main() async {
  server();
  await Future.delayed(Duration(seconds: 1));
  await client();
}

server() async {
  ServerSocket serverSocket =
      await ServerSocket.bind(InternetAddress.anyIPv4, 4040);

  serverSocket.listen((Socket socket) {
    final bpsock = BpSock(socket);
    bpsock.addHook(example1);
  });
}

client() async {
  Socket socket = await Socket.connect('127.0.0.1', 4040);

  final bpsock = BpSock(socket);

  bpsock.addHook(example1);

  bpsock.send(Uint8List.fromList('Hello'.codeUnits), example1.tagRow);
  bpsock.send(Uint8List.fromList('Hello2'.codeUnits), example1.tagRow);
  bpsock.send(Uint8List.fromList('Hello3'.codeUnits), Tag16("example3"));
}
