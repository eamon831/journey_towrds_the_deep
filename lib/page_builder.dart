import 'dart:io';

Future<void> main() async {
  print(
    'Enter the page name: ',
  );
  final String pageName = stdin.readLineSync()!.trim().toLowerCase();

  // Convert to camelCase
  final pageFileName = _fileName(pageName);
  final pageClassName = _className(pageFileName);

  // Directory path for the new page
  final String pageDirectoryPath = 'lib/app/pages/$pageFileName';
  if (Directory(pageDirectoryPath).existsSync()) {
    print(
      'Page already exists at: $pageDirectoryPath',
    );
    return;
  }

  // Create directory structure
  await Directory(pageDirectoryPath).create(
    recursive: true,
  );

  // Create and write files
  await _createFile(
    '$pageDirectoryPath/bindings/${pageFileName}_binding.dart',
    _bindingContent(
      pageClassName,
      pageFileName,
    ),
  );
  await _createFile(
    '$pageDirectoryPath/controllers/${pageFileName}_controller.dart',
    _controllerContent(
      pageClassName,
    ),
  );
  await _createFile(
    '$pageDirectoryPath/views/${pageFileName}_view.dart',
    _viewContent(
      pageClassName,
      pageFileName,
    ),
  );

  final lowerCamelCasePageFileName = _lowerCamelCase(pageFileName);

  // Update routes and pages files
  _updateRoutesFile(lowerCamelCasePageFileName, pageClassName);
  _updatePagesFile(lowerCamelCasePageFileName, pageClassName, pageFileName);

  //run dart format
  await Process.run(
    'dart',
    ['format', '.'],
  );

  print(
    'Page created at: $pageDirectoryPath',
  );
}

Future<void> _createFile(String filePath, String content) async {
  final File file = File(filePath);
  await file.create(recursive: true);
  await file.writeAsString(content);
}

void _updateRoutesFile(String lowerCamelCasePageFileName, String className) {
  const String appRoutesPath = 'lib/app/routes/app_routes.dart';
  final File appRoutesFile = File(appRoutesPath);
  final List<String> lines = appRoutesFile.readAsLinesSync();

  final routesIndex = lines.indexWhere(
    (line) => line.contains(
      'abstract class Routes {',
    ),
  );
  final routesInsertIndex = lines.indexWhere(
    (line) => line.contains('}'),
    routesIndex,
  );

  final pathsIndex = lines.indexWhere(
    (line) => line.contains(
      'abstract class _Paths {',
    ),
  );
  final pathsInsertIndex = lines.indexWhere(
    (line) => line.contains('}'),
    pathsIndex,
  );

  // Insert route constant
  lines
    ..insert(
      routesInsertIndex,
      '  static const $lowerCamelCasePageFileName = _Paths.$lowerCamelCasePageFileName;',
    )

    // Insert path constant
    ..insert(
      pathsInsertIndex,
      "  static const $lowerCamelCasePageFileName = '/$lowerCamelCasePageFileName';",
    );

  appRoutesFile.writeAsStringSync(lines.join('\n'));
}

void _updatePagesFile(
  String lowerCamelCasePageFileName,
  String className,
  String fileName,
) {
  const String appPagesPath = 'lib/app/routes/app_pages.dart';
  final File appPagesFile = File(appPagesPath);
  final List<String> lines = appPagesFile.readAsLinesSync();

  final pageIndex = lines.indexWhere(
    (line) => line.contains('static final routes = ['),
  );
  final pageInsertIndex = lines.indexWhere(
    (line) => line.contains('];'),
    pageIndex,
  );

  // Create new route entry
  final newRouteEntry = '''
    GetPage(
      name: Routes.$lowerCamelCasePageFileName,
      page: ${className}View.new,
      binding: ${className}Binding(),
    ),
  ''';

  // Insert route entry
  lines.insert(pageInsertIndex, newRouteEntry);

  // Create new import statements
  final importIndex = lines.indexWhere((line) => line.contains('import '));
  final newImportStatement = '''
    import '/app/pages/$fileName/bindings/${fileName}_binding.dart';
    import '/app/pages/$fileName/views/${fileName}_view.dart';
  ''';

  // Insert import statements
  lines.insert(importIndex + 1, newImportStatement);

  appPagesFile.writeAsStringSync(lines.join('\n'));
}

String _bindingContent(String className, String fileName) => '''
import '/app/core/exporter.dart';
import '/app/pages/$fileName/controllers/${fileName}_controller.dart';

class ${className}Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<${className}Controller>(
      ${className}Controller.new,
      fenix: true,
    );
  }
}
''';

String _controllerContent(String className) => '''
import '/app/core/exporter.dart';

class ${className}Controller extends BaseController {
  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
''';

String _viewContent(String className, String fileName) => '''
import '/app/core/exporter.dart';
import '/app/pages/$fileName/controllers/${fileName}_controller.dart';

// ignore: must_be_immutable
class ${className}View extends BaseView<${className}Controller> {
  ${className}View({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Container();
  }
}
''';

String _fileName(String input) => input.toLowerCase().replaceAll(' ', '_');

String _className(String input) {
  final words = input.split('_');
  return words.map((word) => word.capitalize()).join();
}

String _lowerCamelCase(String input) {
  final words = input.split('_');
  final capitalizedWords = words.map((word) => word.capitalize()).toList();
  final firstWord = capitalizedWords.removeAt(0).toLowerCase();
  capitalizedWords.insert(0, firstWord);
  return capitalizedWords.join();
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
