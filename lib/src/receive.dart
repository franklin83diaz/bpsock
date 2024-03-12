import 'dart:typed_data';

import 'package:bpsock/src/core/handler.dart';
import 'package:bpsock/src/utils/tag_bytes_to_string.dart';
import 'package:bpsock/src/utils/type_def.dart';

void receiveData(
    List<int> data, ListHandlers connsHandler, BytesBuilder buffer) {
  buffer.add(data);

  // header is complete 22 bytes
  while (buffer.length >= 22) {
    // Convert the buffer to a list of bytes and clear the buffer
    var availableData = buffer.takeBytes();

    // extract the header
    final idBytes = availableData.sublist(0, 2);
    final tagBytes = availableData.sublist(2, 18);
    final lengthBytes = availableData.sublist(18, 22);
    final int idChannel = Uint8List.fromList(idBytes)
        .buffer
        .asByteData()
        .getUint16(0, Endian.big);
    final int lengthData = Uint8List.fromList(lengthBytes)
        .buffer
        .asByteData()
        .getUint32(0, Endian.big);

    String originalTag = tagBytesToString(tagBytes);
    String tag = originalTag;

    //Print the header
    // print("id Channel: $idChannel");
    // print("tag: $originalTag");
    //print("length Data: $lengthData");

    //1 request
    //2 response
    //3 cancel
    //if tag start with a number 1, 2, 3
    if (originalTag.startsWith('1')) {
      tag = tag.substring(8);

      //change original tag to response
      originalTag = "2${originalTag.substring(1)}";
    } else if (originalTag.startsWith('2')) {
      tag = tag.substring(1);
      originalTag = tag;
    } else if (originalTag.startsWith('3')) {
      tag = tag.substring(8);
    }
    late final Handler? connHandler;

    try {
      connHandler = connsHandler.firstWhere((e) => e.tag == tag);
    } catch (e) {
      print('tag not found: $tag');
      // add the rest of the buffer to the buffer
      if (availableData.length > lengthData) {
        buffer.add(availableData.sublist(22 + lengthData));
      }
      continue;
    }

    //if is cancel add the original tag to the cancel stream
    if (originalTag.startsWith('3')) {
      connHandler.cancel.add(originalTag.substring(1));

      // add the rest of the buffer to the buffer
      if (availableData.length > 22) {
        buffer.add(availableData.sublist(22));
      }
      continue;
    }

    //set the total length of the message
    int start = 22;
    int totalLengthData = start + lengthData;

    // check if the buffer has enough data to process
    if (availableData.length >= totalLengthData) {
      if (lengthData == 0) {
        //  print('End of Channel $idChannel');
        // run the function with the data and the original tag
        connHandler.function(connHandler, originalTag, idChannel);
      } else {
        final newData = <int, List<int>>{
          idChannel: availableData.sublist(start, totalLengthData)
        };
        connHandler.data.addEntries(newData.entries);
      }

      // add the rest of the buffer to the buffer
      if (availableData.length > totalLengthData) {
        buffer.add(availableData.sublist(totalLengthData));
      }
    } else {
      //need to wait for more data
      //TODO: add the rest of the buffer to the buffer
      break;
    }
  }
}
