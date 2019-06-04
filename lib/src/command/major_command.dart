import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

class MajorCommand extends Command<int> {
  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'major';

  @override
  final description = 'Imcrement major version number.';

  MajorCommand();

  @override
  Future<int> run() async {
    var unsupported =
        argResults.rest.where((arg) => !arg.startsWith('-')).toList();
    if (unsupported.isNotEmpty) {
      throw UsageException(
          'Arguments were provided that are not supported: '
          '"${unsupported.join(' ')}".',
          argParser.usage);
    }

    final file = new File('pubspec.yaml');
    String contents = await file.readAsString();
    Pubspec currentPubspec = new Pubspec.parse(contents);
    Version nextMajorVersion =
        new Version.parse(currentPubspec.version.nextMajor.toString());

    List<String> lines = await file.readAsLines();
    List<String> outputLines = new List<String>();
    for (String line in lines) {
      if (line.startsWith("version:")) {
        outputLines.add("version: ${nextMajorVersion}");
      } else {
        outputLines.add(line);
      }
    }

    String output = outputLines.join("\n");

    final outputFile = new File('pubspec.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
    print("${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextMajorVersion}");
    return 0;
  }
}
