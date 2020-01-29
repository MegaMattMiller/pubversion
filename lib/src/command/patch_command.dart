import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../mixins/message_helper.dart';

class PatchCommand extends Command<int> with MessageHelper {
  PatchCommand() {
    argParser.addOption('message', abbr: 'm', defaultsTo: '');
  }

  @override
  final argParser = ArgParser(usageLineLength: 80);

  @override
  final name = 'patch';

  @override
  final description = 'Imcrement patch version number.';

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

    final inputPubspecFile = File('pubspec.yaml');
    var contents = await inputPubspecFile.readAsString();
    var currentPubspec = Pubspec.parse(contents);
    var nextPatchVersion =
        Version.parse(currentPubspec.version.nextPatch.toString());
    var lines = await inputPubspecFile.readAsLines();
    var outputLines = List<String>();
    for (var line in lines) {
      if (line.startsWith('version:')) {
        outputLines.add('version: ${nextPatchVersion}');
      } else {
        outputLines.add(line);
      }
    }
    var output = outputLines.join('\n');
    final outputPubspecFile = File('pubspec.yaml');
    await outputPubspecFile.writeAsString(output, mode: FileMode.write);

    if (messageText.isNotEmpty) {
      final inputChagnelogFile = File('CHANGELOG.md');
      var lines = await inputChagnelogFile.readAsLines();
      var outputLines = List<String>();
      for (var line in lines) {
        outputLines.add(line);
      }
      outputLines.insert(0, '');
      outputLines.insert(0, '- ${messageText}');
      outputLines.insert(0, '');
      outputLines.insert(0, '## ${nextPatchVersion}');
      var output = outputLines.join('\n');
      print(output);
      final outputChangelogFile = File('CHANGELOG.md');
      await outputChangelogFile.writeAsString(output, mode: FileMode.write);
    }

    print(
        '${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextPatchVersion}');
    if (messageText.isNotEmpty) print('with message ${messageText}');
    //TODO: write message to CHANGELOG.md.
    return 0;
  }
}
