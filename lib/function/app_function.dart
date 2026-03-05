import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

String? fileName;

Future<bool> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pcap', 'pcapng', 'cap'],
    withData: true,
  );

  if (result != null) {
    return processFile(result.files.first.name, result.files.first.bytes);
  }
  return false;
}

bool processFile(String name, Uint8List? bytes) {
  fileName = name;
  print("File Selected: $name");

  return true;
  // Here you would call your analyze() function
  // and pass the bytes to your Flask API
}
