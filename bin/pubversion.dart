import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:args/command_runner.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:pubversion/src/pubversion_command_runner.dart';

Future main(List<String> args) async {
  try {
    exitCode = await run(args);
  } on UsageException catch (e) {
    print(red.wrap(e.message));
    print(' ');
    print(e.usage);
    exitCode = ExitCode.usage.code;
  } on FileSystemException catch (e) {
    print(red.wrap('pubversion could not run in the current directory.'));
    print(e.message);
    if (e.path != null) {
      print('  ${e.path}');
    }
    exitCode = ExitCode.config.code;
  } on IsolateSpawnException catch (e) {
    print(red.wrap('pubversion failed with an unexpected exception.'));
    print(e.message);
    exitCode = ExitCode.software.code;
  }
}
