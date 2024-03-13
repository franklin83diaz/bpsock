import 'dart:io';
import 'dart:typed_data';

import 'package:bpsock/bpsock.dart';

void main(List<String> args) async {
  final socket = await Socket.connect('127.0.0.1', 4040);
  final bpsock = BpSock(socket);
  var text = Uint8List.fromList('test 1 '.codeUnits);
  bpsock.send(text, Tag16('text'));
  text = Uint8List.fromList('test 2'.codeUnits);
  bpsock.send(text, Tag16('text'));
  text = Uint8List.fromList('test 3'.codeUnits);
  bpsock.send(text, Tag16('text'));
}
