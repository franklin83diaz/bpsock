import 'dart:typed_data';

List<Uint8List> splitData(Uint8List data, int dmtu) {
  final listData = <Uint8List>[];

  for (var i = 0; i < data.length; i += dmtu) {
    var end = i + dmtu;
    //check end for not exceed the length of data
    if (end > data.length) {
      end = data.length;
    }

    final chunk = data.sublist(i, end);
    listData.add(chunk);
  }

  return listData;
}
