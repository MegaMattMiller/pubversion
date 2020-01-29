import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../mixins/message_helper.dart';

class MajorCommand extends Command<int> with MessageHelper {
  MajorCommand();
  
  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'major';

  @override
  final description = 'Imcrement major version number.';

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

    String messageText = getMessageString(argResults);

    final file = File('pubspec.yaml');
    String contents = await file.readAsString();
    Pubspec currentPubspec = Pubspec.parse(contents);
    Version nextMajorVersion =
        Version.parse(currentPubspec.version.nextMajor.toString());

    List<String> lines = await file.readAsLines();
    List<String> outputLines = List<String>();
    for (String line in lines) {
      if (line.startsWith("version:")) {
        outputLines.add("version: ${nextMajorVersion}");
      } else {
        outputLines.add(line);
      }
    }

    String output = outputLines.join("\n");

    final outputFile = File('pubspec.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
    print(
        "${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextMajorVersion}");
    if (messageText.isNotEmpty) print("with message ${messageText}");
    return 0;
  }
}
