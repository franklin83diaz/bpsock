import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bpsock/bpsock.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late final BpSock bpsock;
    late ServerSocket serverSocket;
    () async {
      serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    }();

    setUp(() {});

    test('hook', () async {
      await Future.delayed(Duration(seconds: 1));
      Socket socket = await Socket.connect('127.0.0.1', 4040);
      bpsock = BpSock(socket);

      HookHandler example1 =
          HookHandler(Tag16('example1'), (handler, data, id) {
        print('hook: $data');
      });
      HookHandler example2 =
          HookHandler(Tag16('example2'), (handler, data, id) {
        print('hook: $data');
      });

      bpsock.addHook(example1);
      bpsock.addHook(example2);

      expect(bpsock.getAllHooks()[0].tag, "example1");
      expect(bpsock.getAllHooks()[1].tag, "example2");
    });

    test('hook repeated', () async {
      HookHandler example2 =
          HookHandler(Tag16('example2'), (handler, data, id) {
        print('hook: $data');
      });
      try {
        bpsock.addHook(example2);
      } catch (e) {
        expect(e, isA<ArgumentError>());
      }
    });

    test('send', () async {
      serverSocket.listen((Socket socket) {
        final bpsock = BpSock(socket);
        HookHandler example1 =
            HookHandler(Tag16('example send'), (handler, data, id) {
          var data = utf8.decode(handler.data[id]!);
          expect(data, 'Hello');
        });
        bpsock.addHook(example1);
      });
      bpsock.send(Uint8List.fromList('Hello'.codeUnits), Tag16("example send"));
      await Future.delayed(Duration(seconds: 1));
    });

    test('remove hook', () async {
      bpsock.removeHook(Tag16('example1'));
      expect(bpsock.getAllHooks().length, 1);
    });

    test('ReqPoint', () async {
      ReqPoint reqPoint1 = ReqPoint(Tag8('ReqP1'), (handler, data, id) {});
      bpsock.addReqPoint(reqPoint1);

      expect('ReqP1', bpsock.getAllReqPoint()[0].tag);
    });

    test('ReqHandler', () async {
      //Color Green
      print(
          "\x1B[32m The tag no found 2 time is normal, is the data and the endChannel \x1B[0m");
      bpsock.req(Uint8List.fromList('Hello'.codeUnits), Tag8('R1'),
          (handler, data, id) {});

      bpsock.req(Uint8List.fromList('Hello'.codeUnits), Tag8('ReqH0001'),
          (handler, data, id) {});

      expect('R1', bpsock.getAllReqHandler()[0].tag.substring(8));
      expect('ReqH0001', bpsock.getAllReqHandler()[1].tag.substring(8));
      await Future.delayed(Duration(seconds: 1));
    });
  });
}
