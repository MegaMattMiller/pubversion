import 'dart:async';
import 'dart:io';
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import '../mixins/message_helper.dart';

class PatchCommand extends Command<int> with MessageHelper {
  PatchCommand() {
    argParser.addOption("message", abbr: "m", defaultsTo: "");
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

    String messageText = getMessageString(argResults);

    final inputPubspecFile = new File('pubspec.yaml');
    String contents = await inputPubspecFile.readAsString();
    Pubspec currentPubspec = new Pubspec.parse(contents);
    Version nextPatchVersion =
        new Version.parse(currentPubspec.version.nextPatch.toString());
    List<String> lines = await inputPubspecFile.readAsLines();
    List<String> outputLines = new List<String>();
    for (String line in lines) {
      if (line.startsWith("version:")) {
        outputLines.add("version: ${nextPatchVersion}");
      } else {
        outputLines.add(line);
      }
    }
    String output = outputLines.join("\n");
    final outputPubspecFile = new File('pubspec.yaml');
    await outputPubspecFile.writeAsString(output, mode: FileMode.write);

    if (messageText.isNotEmpty) {
      final inputChagnelogFile = new File('CHANGELOG.md');
      List<String> lines = await inputChagnelogFile.readAsLines();
      List<String> outputLines = new List<String>();
      for (String line in lines) {
        outputLines.add(line);
      }
      outputLines.insert(0, "");
      outputLines.insert(0, "- ${messageText}");
      outputLines.insert(0, "");
      outputLines.insert(0, "## ${nextPatchVersion}");
      String output = outputLines.join("\n");
      print(output);
      final outputChangelogFile = new File('CHANGELOG.md');
      await outputChangelogFile.writeAsString(output, mode: FileMode.write);
    }

    print(
        "${currentPubspec.name} upgraded from ${currentPubspec.version} to ${nextPatchVersion}");
    if (messageText.isNotEmpty) print("with message ${messageText}");
    //TODO: write message to CHANGELOG.md.
    return 0;
  }
}
