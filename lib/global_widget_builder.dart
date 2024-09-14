import 'dart:io';

Future<void> main() async {
  print('Enter the Widget name: ');
  final String widgetName = stdin.readLineSync()!.trim().toLowerCase();

  // Convert to camelCase and ClassName format
  final widgetFileName = _fileName(widgetName);
  final widgetClassName = _className(widgetFileName);

  // Directory path for the new page
  const String widgetDirectoryPath = 'lib/app/global_widget';
  final String widgetFilePath = '$widgetDirectoryPath/$widgetFileName.dart';

  // Check if the widget already exists
  if (File(widgetFilePath).existsSync()) {
    print('Widget already exists at: $widgetFilePath');
    return;
  }

  // Create directory structure if not exists
  await Directory(widgetDirectoryPath).create(recursive: true);

  // Create and write widget file
  await _createFile(widgetFilePath, _widgetContent(widgetClassName));

  // Add export to exporter.dart
  const exporterPath = 'lib/app/core/exporter.dart';
  final exporterFile = File(exporterPath);

  if (await exporterFile.exists()) {
    final exporterContent = await exporterFile.readAsString();
    // Append the new export line
    final newExporterContent =
        "$exporterContent\nexport '/app/global_widget/$widgetFileName.dart';";
    await exporterFile.writeAsString(newExporterContent);
  } else {
    print('Exporter file not found at $exporterPath');
  }

  // Run dart format
  final formatResult = await Process.run('dart', ['format', '.']);
  print(formatResult.stdout);

  print('Widget created at: $widgetFilePath');
}

String _widgetContent(String widgetName) => '''
import '/app/core/exporter.dart';

class $widgetName extends StatelessWidget {
  const $widgetName({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
''';

String _fileName(String input) => input.toLowerCase().replaceAll(' ', '_');

String _className(String input) {
  final words = input.split('_');
  return words.map((word) => word.capitalize()).join();
}

Future<void> _createFile(String filePath, String content) async {
  final file = File(filePath);
  await file.create(recursive: true);
  await file.writeAsString(content);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
