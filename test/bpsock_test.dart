import 'dart:io';

import 'package:bpsock/bpsock.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    late final BpSock bpsock;
    () async {
      ServerSocket.bind(InternetAddress.anyIPv4, 4040);
    }();

    //setUp(() {});

    test('hook Test', () async {
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

    test('hook Test 2', () async {
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
  });
}
