import 'package:logger/logger.dart';

class EnvConfig {
  final String appName;
  final String baseUrl;
  final bool shouldCollectCrashLog;

  late final Logger logger;

  EnvConfig({
    required this.appName,
    required this.baseUrl,
    this.shouldCollectCrashLog = false,
  }) {
    logger = Logger(
      printer: PrettyPrinter(),
    );
  }
}
