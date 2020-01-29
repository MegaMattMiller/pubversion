import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../mixins/message_helper.dart';

class MinorCommand extends Command<int> with MessageHelper {
  MinorCommand();

  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'minor';

  @override
  final description = 'Imcrement minor version number.';

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

    var messageText = getMessageString(argResults);

    final file = File('pubspec.yaml');
    var contents = await file.readAsString();
    var currentPubspec = Pubspec.parse(contents);
    var nextMinorVersion =
        Version.parse(currentPubspec.version.nextMinor.toString());

    var lines = await file.readAsLines();
    var outputLines = List<String>();
    for (var line in lines) {
      if (line.startsWith('version:')) {
        outputLines.add('version: ${nextMinorVersion}');
      } else {
        outputLines.add(line);
      }
    }

    var output = outputLines.join('\n');

    final outputFile = File('pubspec.yaml');
    await outputFile.writeAsString(output, mode: FileMode.write);
    print(
        '${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextMinorVersion}');
    if (messageText.isNotEmpty) print('with message ${messageText}');
    return 0;
  }
}
