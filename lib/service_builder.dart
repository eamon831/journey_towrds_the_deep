import 'dart:io';

const pageDirectoryPath = 'lib/app/service/services.dart';

void main() {
  final servicesFile = File(pageDirectoryPath);

  if (!servicesFile.existsSync()) {
    print('File does not exist.');
    return;
  }

  final lines = servicesFile.readAsLinesSync();
  final serviceMethods = extractServiceMethods(lines);

  printTable('Service Methods with Return Types', serviceMethods);
  final cleanedMethodNames = cleanMethodNames(serviceMethods);
  printTable('Cleaned Method Names', cleanedMethodNames);

  final newMethodName = getUniqueMethodName(cleanedMethodNames);
  final endPoint = getEndpoint();
  final customObjectName = getCustomObjectName();
  final methodType = getMethodType();
  final apiType = getApiType();
  final apiDataType = getApiDataType();

  final returnType = getReturnType();

  final newMethodReturnType = returnType.replaceAll(
    'CustomObject',
    customObjectName,
  );
  final newMethodSignature = 'Future<$newMethodReturnType?> $newMethodName';

  printSuccess('Selected values:');
  printSuccess('New method name: $newMethodName');
  printSuccess('Method type: $methodType');
  printSuccess('API type: $apiType');
  printSuccess('API data type: $apiDataType');
  printSuccess('Return type: $returnType');
  printSuccess('Custom object name: $customObjectName');
  printSuccess('Endpoint: $endPoint');
  printSuccess('New method return type: $newMethodReturnType');
  printSuccess('New method signature: $newMethodSignature');

  final method = generateMethod(
    newMethodSignature,
    methodType,
    apiType,
    endPoint,
    apiDataType,
    returnType,
    customObjectName,
  );

  print('New method body:');
  print(method);

  final copyMethod = getBooleanResponse(
    'Copy the new method to the services file? (y/n) [0 to exit]',
  );
  if (copyMethod) {
    copyMethodToFile(lines, method, servicesFile);
  } else {
    print('Exiting...');
    exit(0);
  }
}

List<String> extractServiceMethods(List<String> lines) {
  final methodPattern = RegExp(r'^\s*Future<([^>]+)>\s+(\w+)\s*\(');
  final serviceMethods = <String>[];

  for (final line in lines) {
    final match = methodPattern.firstMatch(line);
    if (match != null) {
      final datatype = match.group(1) ?? '';
      final methodName = match.group(2) ?? '';
      serviceMethods.add('Future<$datatype> $methodName');
    }
  }

  return serviceMethods;
}

List<String> cleanMethodNames(List<String> serviceMethods) {
  final specialCharPattern = RegExp(r'[^\w\s]');
  return serviceMethods
      .map((e) => e.split(' ').last.replaceAll(specialCharPattern, ''))
      .toList();
}

String generateMethod(
  String newMethodSignature,
  String methodType,
  String apiType,
  String endPoint,
  String apiDataType,
  String returnType,
  String customObjectName,
) {
  final requestLine = generateRequestLine(methodType, apiType, endPoint);
  final returnLine = generateReturnLine(returnType, customObjectName);

  return '''
  $newMethodSignature () async {
    const endPoint = '$endPoint';
    try {
      final Map<String, dynamic> data = {}..removeWhere(
          (key, value) => value == null,
        );

      $requestLine

      final responseData = response.data as $apiDataType?;
      if (responseData == null) {
        return null;
      }

      $returnLine
        
    } catch (e, s) {
      printError(e, s, endPoint);
      return null;
    }
  }
  ''';
}

String generateRequestLine(String methodType, String apiType, String endPoint) {
  if (methodType == 'dio.post') {
    return '''
    final response = await $methodType(
        $apiType,
        endPoint,
         {},
        query: data,
        headers: await _buildHeader(),
      );''';
  } else if (methodType == 'dio.get') {
    return '''
    final response = await $methodType(
        $apiType,
        endPoint,
        query: data,
        headers: await _buildHeader(),
      );''';
  }
  return '';
}

String generateReturnLine(String returnType, String customObjectName) {
  if (returnType == 'CustomObject') {
    return '''
    return parseObject(
        object: responseData,
        fromJson: $customObjectName.fromJson,
      );''';
  } else if (returnType == 'List<CustomObject>') {
    return '''
    return parseList(
        list: responseData,
        fromJson: $customObjectName.fromJson,
      );''';
  }
  return '';
}

void copyMethodToFile(List<String> lines, String method, File servicesFile) {
  final newMethodIndex =
      lines.lastIndexWhere((element) => element.contains('}'));
  lines.insert(newMethodIndex, method);
  servicesFile.writeAsStringSync(lines.join('\n'));
  print('Method copied to the services file.');
}

void printTable(String title, List<String> lines) {
  print('╔═════════════════════════════════════════╗');
  print('║ $title'.padRight(41) + ' ║');
  print('╠═════════════════════════════════════════╣');
  if (lines.isNotEmpty) {
    for (final line in lines) {
      print('║ ${line.padRight(39)} ║');
    }
  } else {
    print('║ No items found.                        ║');
  }
  print('╚═════════════════════════════════════════╝');
}

String getUniqueMethodName(List<String> existingNames) {
  while (true) {
    print('Enter the new method name (or 0 to exit):');
    final newMethodName = stdin.readLineSync() ?? '';

    if (newMethodName == '0') {
      print('Exiting...');
      exit(0);
    }

    if (existingNames.contains(newMethodName)) {
      print('Method name already exists. Please enter a different name.');
    } else {
      return newMethodName;
    }
  }
}

String getMethodType() {
  while (true) {
    print('Select the method type:');
    print('1. POST');
    print('2. GET');
    print('3. PUT');
    print('4. DELETE');
    print('0. Exit');
    final methodType = stdin.readLineSync() ?? '';

    if (methodType == '0') {
      print('Exiting...');
      exit(0);
    }

    switch (methodType) {
      case '1':
        return 'dio.post';
      case '2':
        return 'dio.get';
      case '3':
        return 'dio.put';
      case '4':
        return 'dio.delete';
      default:
        print('Invalid method type. Please enter a valid method type.');
    }
  }
}

String getApiType() {
  while (true) {
    print('Select the API type:');
    print('1. Public');
    print('2. Protected');
    print('0. Exit');
    final apiType = stdin.readLineSync() ?? '';

    if (apiType == '0') {
      print('Exiting...');
      exit(0);
    }

    switch (apiType) {
      case '1':
        return 'APIType.public';
      case '2':
        return 'APIType.protected';
      default:
        print('Invalid API type. Please enter a valid API type.');
    }
  }
}

String getApiDataType() {
  while (true) {
    print('Enter the expected data type from the API response:');
    print('1. Map<String, dynamic>');
    print('2. List');
    print('0. Exit');
    final apiDataType = stdin.readLineSync() ?? '';

    if (apiDataType == '0') {
      print('Exiting...');
      exit(0);
    }

    switch (apiDataType) {
      case '1':
        return 'Map<String, dynamic>';
      case '2':
        return 'List';
      default:
        print('Invalid data type. Please enter a valid data type.');
    }
  }
}

bool getBooleanResponse(String prompt) {
  while (true) {
    print(prompt);
    final response = stdin.readLineSync()?.toLowerCase() ?? '';

    if (response == '0') {
      print('Exiting...');
      exit(0);
    }

    if (response == 'y') {
      return true;
    } else if (response == 'n') {
      return false;
    } else {
      print('Invalid response. Please enter a valid response.');
    }
  }
}

String getReturnType() {
  while (true) {
    print('Enter the return type of the method:');
    print('1. List of custom object');
    print('2. Single object');
    print('0. Exit');
    final returnType = stdin.readLineSync() ?? '';

    if (returnType == '0') {
      print('Exiting...');
      exit(0);
    }

    switch (returnType) {
      case '1':
        return 'List<CustomObject>';
      case '2':
        return 'CustomObject';
      default:
        print('Invalid return type. Please enter a valid return type.');
    }
  }
}

String getCustomObjectName() {
  while (true) {
    print('Enter the custom object name: (or 0 to exit)');
    final customObjectName = stdin.readLineSync() ?? '';

    if (customObjectName == '0') {
      print('Exiting...');
      exit(0);
    }

    if (customObjectName.isNotEmpty) {
      return customObjectName;
    } else {
      print('Invalid custom object name. Please enter a valid name.');
    }
  }
}

String getEndpoint() {
  while (true) {
    print('Enter the API endpoint: (or 0 to exit)');
    final endPoint = stdin.readLineSync() ?? '';

    if (endPoint == '0') {
      print('Exiting...');
      exit(0);
    }

    if (endPoint.isNotEmpty) {
      return endPoint;
    } else {
      print('Invalid endpoint. Please enter a valid endpoint.');
    }
  }
}

void printSuccess(String message) {
  print('\x1B[32m$message\x1B[0m');
}

void printWarning(String message) {
  print('\x1B[33m$message\x1B[0m');
}

void printError(String message, [String? endPoint]) {
  print('\x1B[31m$message\x1B[0m');
  if (endPoint != null) {
    print('\x1B[31mError occurred at endpoint: $endPoint\x1B[0m');
  }
}
