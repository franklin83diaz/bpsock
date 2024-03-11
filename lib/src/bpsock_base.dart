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
  bool _lockUpChannel = false;

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
  void send(Uint8List data, Tag16 tag) async {
    //lock up channel if it is busy
    while (_lockUpChannel) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    _lockUpChannel = true;
    _idChannel++;
    if (_idChannel > 65535) {
      _idChannel = 1;
    }
    _lockUpChannel = false;

    sendData(data, tag.name, _idChannel, _socket, _dmtu);
  }

  //request
  void req(Uint8List data, Tag8 tag, ActionFunc function) async {
    //lock up channel if it is busy
    while (_lockUpChannel) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    _lockUpChannel = true;
    _idChannel++;
    if (_idChannel > 65535) {
      _idChannel = 1;
    }
    _lockUpChannel = false;

    //
    ReqHandler handler = ReqHandler(tag, function);
    _addReqHandler(handler);

    sendData(data, '1${handler.tag}', _idChannel, _socket, _dmtu);
  }

  void res(Uint8List data, String tagName) async {
    //lock up channel if it is busy
    while (_lockUpChannel) {
      await Future.delayed(Duration(milliseconds: 10));
    }
    _lockUpChannel = true;
    _idChannel++;
    if (_idChannel > 65535) {
      _idChannel = 1;
    }
    _lockUpChannel = false;

    //check if the tag starts with 2
    if (!tagName.startsWith('2')) {
      throw ArgumentError('The tag must start with 2');
    }
    sendData(data, tagName, _idChannel, _socket, _dmtu);
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

  //ReqPoint
  void addReqPoint(ReqPoint handler) {
    //check if the tag already exists
    if (_handlers.any((e) => e.tag == handler.tag)) {
      throw ArgumentError('The tag already exists');
    }
    _handlers.add(handler);
  }

  void removeReqPoint(Tag8 tag) {
    _handlers.removeWhere((e) => e.tag == tag.name);
  }

  ListHandlers getAllReqPoint() {
    var all = _handlers.whereType<ReqPoint>();
    return all.toList();
  }

  //ReqHandler
  void _addReqHandler(ReqHandler handler) {
    //check if the tag already exists
    if (_handlers.any((e) => e.tag == handler.tag)) {
      throw ArgumentError('The tag already exists');
    }
    _handlers.add(handler);
  }

  void removeReqHandler(Tag8 tag) {
    _handlers.removeWhere((e) => e.tag == tag.name);
  }

  ListHandlers getAllReqHandler() {
    var all = _handlers.whereType<ReqHandler>();
    return all.toList();
  }
}
