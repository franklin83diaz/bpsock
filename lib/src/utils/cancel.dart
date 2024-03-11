import 'package:bpsock/src/core/handler.dart';

class IsCanceled {
  bool status = false;
}

IsCanceled cancelHandler(Handler handler, String tagName) {
  IsCanceled isCanceled = IsCanceled();
  handler.cancel.stream.listen((tagCancel) {
    if ('2$tagCancel' == tagName) {
      isCanceled.status = true;
    }
  });
  return isCanceled;
}
