import 'dart:io';
import 'dart:typed_data';

import 'package:bpsock/src/handlers.dart';
import 'package:bpsock/src/receive.dart';
import 'package:bpsock/src/send.dart';
import 'package:bpsock/src/utils/tags.dart';
import 'package:bpsock/src/utils/type_def.dart';

/// BpSock (Basic Protocol Socket)
///
/// dmtu: Data Maximum Transmission Unit
/// socket: Socket for communication
class BpSock {
  late final int _dmtu;
  final Socket _socket;
  final ListHandlers _handlers = [];
  int _idChannel = 0;

  BpSock(this._socket, {int dmtu = 15000000}) {
    _dmtu = dmtu;
    if (_dmtu > 15000000) {
      throw ArgumentError(
          'the DMTU exceeds the maximum size of 15,000,000 bytes.');
    }

    // ignore: deprecated_export_use
    final buffer = BytesBuilder();

    //Listen to the socket
    //
    _socket.listen((List<int> data) {
      receiveData(data, _handlers, buffer);
    }, onDone: () {
      print('Connection closed');
      _socket.close();
    }, onError: (error) {
      print('Error: $error');
      _socket.close();
    });
  }

  //Send data
  void send(Uint8List data, Tag16 tag) {
    _idChannel++;
    if (_idChannel > 65535) {
      _idChannel = 1;
    }
    sendData(data, tag.name, _idChannel, _socket, _dmtu);
  }

  //Hook
  void addHook(HookHandler handler) {
    //check if the tag already exists
    if (_handlers.any((e) => e.tag == handler.tag)) {
      throw ArgumentError('The tag already exists');
    }
    _handlers.add(handler);
  }

  void removeHook(Tag16 tag) {
    _handlers.removeWhere((e) => e.tag == tag.name);
  }

  ListHandlers getAllHooks() {
    var all = _handlers.whereType<HookHandler>();
    return all.toList();
  }
}
