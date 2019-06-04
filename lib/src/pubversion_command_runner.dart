import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'command/major_command.dart';
import 'util.dart';
import 'version.dart';

export 'util.dart' show appName;

Future<int> run(List<String> args) => _CommandRunner().run(args);

class _CommandRunner extends CommandRunner<int> {
  _CommandRunner() : super(appName, 'A tool to develop Dart web projects.') {
    argParser.addFlag('version',
        negatable: false, help: 'Prints the version of pubversion.');
    addCommand(MajorCommand());
  }

  @override
  Future<int> runCommand(ArgResults topLevelResults) async {
    if (topLevelResults['version'] as bool) {
      print(packageVersion);
      return 0;
    }

    // In the case of `help`, `null` is returned. Treat that as success.
    return await super.runCommand(topLevelResults) ?? 0;
  }
}