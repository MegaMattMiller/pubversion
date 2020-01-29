import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

class PatchCommand extends Command<int> {
  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'patch';

  @override
  final description = 'Imcrement patch version number.';

  PatchCommand();

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

    final file = File('pubspec.yaml');
    String contents = await file.readAsString();
    Pubspec currentPubspec = Pubspec.parse(contents);
    Version nextPatchVersion =
        Version.parse(currentPubspec.version.nextPatch.toString());

    List<String> lines = await file.readAsLines();
    List<String> outputLines = List<String>();
    for (String line in lines) {
      if (line.startsWith("version:")) {
        outputLines.add("version: ${nextPatchVersion}");
      } else {
        outputLines.add(line);
      }
    }

    String output = outputLines.join("\n");

    final outputFile = File('pubspec.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
    print(
        "${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextPatchVersion}");
    return 0;
  }
}
