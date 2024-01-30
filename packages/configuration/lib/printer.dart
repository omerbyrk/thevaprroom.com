import 'package:colorize/colorize.dart';

import 'main.dart';

void debug(String message) {
  if (argResults[debugFlag]) {
    color('Debug: ' + message, front: Styles.CYAN, isBold: true);
  }
}

void info(String message) {
  color('Info: ' + message, front: Styles.BLUE, isBold: true);
}

void warning(String message) {
  color('Warning: ' + message, front: Styles.YELLOW, isBold: true);
}

void success(String message) {
  color('Success: ' + message, front: Styles.GREEN, isBold: true);
}

void error(String message) {
  color('Error: ' + message, front: Styles.RED, isBold: true);
}
