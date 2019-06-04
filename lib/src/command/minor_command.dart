import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

class MinorCommand extends Command<int> {
  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'minor';

  @override
  final description = 'Imcrement minor version number.';

  MinorCommand();

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
    Version nextMinorVersion =
        new Version.parse(currentPubspec.version.nextMinor.toString());

    List<String> lines = await file.readAsLines();
    List<String> outputLines = new List<String>();
    for (String line in lines) {
      if (line.startsWith("version:")) {
        outputLines.add("version: ${nextMinorVersion}");
      } else {
        outputLines.add(line);
      }
    }

    String output = outputLines.join("\n");

    final outputFile = new File('pubspec.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
    print(
        "${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextMinorVersion}");
    return 0;
  }
}
