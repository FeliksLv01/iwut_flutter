import 'dart:convert';

//import 'package:iwut_flutter/config/log/controller.dart';
import 'package:logger/logger.dart';

class Log {
  static final _log = Logger(filter: IwutFliter(), printer: PrefixPrinter(IwutPrinter()), output: IwutOut());

  static warning(String msg, {String? tag}) {
    //logConsoleController.logWarning(msg, tag: tag);
    _log.w(msg);
  }

  static info(String msg, {String? tag}) {
    //logConsoleController.logInfo(msg, tag: tag);
    _log.i(msg);
  }

  static debug(String msg, {String? tag}) {
    //logConsoleController.logDebug(msg, tag: tag);
    _log.d(msg);
  }

  static error(String msg, {String? tag}) {
    //logConsoleController.logError(msg, tag: tag);
    _log.e(msg);
  }
}

class IwutFliter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class IwutOut extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    super.output(event);
  }
}

class IwutPrinter extends LogPrinter {
  static final levelColors = {
    Level.verbose: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: AnsiColor.none(),
    Level.info: AnsiColor.fg(12),
    Level.warning: AnsiColor.fg(208),
    Level.error: AnsiColor.fg(196),
    Level.wtf: AnsiColor.fg(199),
  };

  final bool printTime;

  IwutPrinter({this.printTime = false});

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${DateTime.now().toIso8601String()}' : '';
    return ['$timeStr $messageStr$errorStr'];
  }

  String _stringifyMessage(dynamic message) {
    if (message is Map || message is Iterable) {
      var encoder = JsonEncoder.withIndent(null);
      return encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
